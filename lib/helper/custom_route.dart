/*
 * @Author: your name
 * @Date: 2021-01-08 14:22:14
 * @LastEditTime: 2021-01-08 14:43:12
 * @LastEditors: Please set LastEditors
 * @Description: In User Settings Edit
 * @FilePath: /flutter/udemy_flutter_sec9/lib/helper/custom_route.dart
 */
import 'package:flutter/material.dart';

//给每个页面加载加上自定义动画效果:
//将原本自带的效果（所有内容从下往上加载）变成了appbar固定不动，其它内容加载效果

//CustomRoute针对单一一个页面进行改变，见app_drawer.dart里：给order page加上自定义动画效果
//下的代码
class CustomRoute<T> extends MaterialPageRoute<T> {
  CustomRoute({WidgetBuilder builder, RouteSettings settings})
      : super(
          builder: builder,
          settings: settings,
        );

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    //
    if (settings.name == '/') {
      return child;
    }
    return FadeTransition(
      opacity: animation,
      child: child,
    );
  }
}

//CustomPageTransitionBuilder是针对同时改变所有页面的加载效果的
//代码见main.dart里：改变所有页面加载效果下面的代码
class CustomPageTransitionBuilder extends PageTransitionsBuilder {
  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    //
    if (route.settings.name == '/') {
      return child;
    }
    return FadeTransition(
      opacity: animation,
      child: child,
    );
  }
}
