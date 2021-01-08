/*
 * @Author: your name
 * @Date: 2021-01-07 13:16:08
 * @LastEditTime: 2021-01-07 20:13:15
 * @LastEditors: Please set LastEditors
 * @Description: In User Settings Edit
 * @FilePath: /flutter/udemy_flutter_sec9/lib/provider/auth.dart
 */
//监听用户输入的验证信息
import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../model/http_exception.dart';

class Auth with ChangeNotifier {
  String _token;
  DateTime _expireDate;
  String _userId;
  Timer _authTimer;

  bool get isAuth {
    //确定当前用户是否是登入状态，这样显示不同的home界面
    return token != null; //这里的token是下面的get token方法，它会返回一个str或者null
    //如果返回非空，说明当前为登入状态
  }

  String get token {
    if (_expireDate != null &&
        _expireDate.isAfter(DateTime.now()) &&
        _token != null) {
      //如果token的有效时间还没过期,且token不为空，则返回当前的有效token
      return _token;
    }
    return null;
  }

  String get userId {
    return _userId;
  }

  Future<void> _authenticate(
      String email, String password, String authMode) async {
    //具体教程见firebase auth REST API:https://firebase.google.com/docs/reference/rest/auth
//url里的API_KEY即为firebase里project settings 里的Web API Key
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:$authMode?key=AIzaSyCE-GbUymibVOXXTFqZ1kgthvNNEszf5r8';

    try {
      final response = await http.post(
        url,
        body: json.encode({
          'email': email,
          'password': password,
          'returnSecureToken': true, //该值永远设置为true
        }),
      );
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        //如果注册或者登录出现错误
        throw HttpException(responseData['error']['message']);
      }
      //获取当前token
      _token = responseData['idToken'];
      //获取当前用户id（数据库生成）
      _userId = responseData['localId'];
      //获取token的过期时间
      _expireDate = DateTime.now().add(
        //当前时间加上它的有效时长即为它过期的时间点
        Duration(seconds: int.parse(responseData['expiresIn'])),
      );
      //一旦获取到_expireDate后就开始计时，到时间后自动登出
      _autoLogout();
      //最后通知main.dart， token值发生改变了
      notifyListeners();

      //保存当前的token等信息到shared preferrences
      //这样当用户切换到其它app后再切换回来时，如果token还没过期，则仍然处在登录状态
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode({
        //json.encode把一个map变成string
        'token': _token,
        'userId': _userId,
        'expireDate': _expireDate.toIso8601String(),
      });
      prefs.setString('userData', userData);
    } catch (err) {
      throw err;
    }
  }

//新建用户账户
  Future<void> signUp(String email, String password) async {
    return _authenticate(email, password, 'signUp');
  }

//登录已有账户
  Future<void> logIn(String email, String password) async {
    return _authenticate(email, password, 'signInWithPassword');
  }

//登出
  Future<void> logout() async {
    _token = null;
    _userId = null;
    _expireDate = null;
    //取消当前计时器
    if (_authTimer != null) {
      _authTimer.cancel();
      _authTimer = null;
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('userData');
    //或者可以用prefs.clear();
    //但是prefs.clear()会清空保存在prefs里的所有数据，
    //如果prefs保存了除了userData外的其它数据，则最好用prefs.remove
  }

  void _autoLogout() {
    //在使用任何计时器前，先检查是否有其它计时器存在，如果有则取消这个存在的计时器
    if (_authTimer != null) {
      _authTimer.cancel();
    }
    //当token过期时，自动logout
    //计算过期时间点和当前时间点之间的差值（以秒为单位）
    final timeOut = _expireDate.difference(DateTime.now()).inSeconds;
    //然后定一个计时器计时，当时间到了后，登出
    _authTimer = Timer(Duration(seconds: timeOut), logout);
  }

  //用户切换出app后，再切换回来时如果token没过期则自动登录
  Future<bool> autoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      //如果没有userData信息时，直接返回false
      return false;
    }
    //否则说明有userData信息,获取userData，然后把它还原成map对象
    final extractedUserData =
        json.decode(prefs.getString('userData')) as Map<String, Object>;
    //然后获得过期时间
    final expireDate = DateTime.parse(extractedUserData['expireDate']);
    //然后检查是否过期:如果当前时间点在过期时间点之后，说明已经过期
    if (expireDate.isBefore(DateTime.now())) {
      return false;
    }
    //否则说明没过期,重新登录
    _token = extractedUserData['token'];
    _expireDate = expireDate;
    _userId = extractedUserData['userId'];
    notifyListeners();
    _autoLogout();
    return true;
  }
}
