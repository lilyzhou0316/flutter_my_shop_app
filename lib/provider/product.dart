/*
 * @Author: your name
 * @Date: 2020-12-23 14:38:34
 * @LastEditTime: 2021-01-06 15:14:08
 * @LastEditors: Please set LastEditors
 * @Description: In User Settings Edit
 * @FilePath: /flutter/udemy_flutter_sec8/lib/model/product.dart
 */
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String imageUrl;
  final String description;
  final double price;
  bool isFavorite;

  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.imageUrl,
    @required this.price,
    this.isFavorite = false,
  });

  Future<void> toggleFavorite() async {
    //用http将指定id的商品的isFavorite值保存到数据库中
    final url =
        'https://flutter-my-shop-app-6a2d3-default-rtdb.firebaseio.com/products/$id.json';

    final oldStatus = isFavorite; //用于防止更新失败时回滚到之前的值
    //先更新在list中的值
    isFavorite = !isFavorite;
    notifyListeners();
    //然后更新在数据库中的值
    try {
      final response = await http.patch(
        url,
        body: json.encode({'isFavorite': isFavorite}),
      );
      if (response.statusCode >= 400) {
        //更新数据库失败，则把list中对应的值回滚到之前的值
        isFavorite = oldStatus;
        notifyListeners();
      }
    } catch (err) {
      //不会执行到这里，因为patch和delete一样自己不会抛出error
    }
  }
}
