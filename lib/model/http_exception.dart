/*
 * @Author: your name
 * @Date: 2021-01-06 14:29:23
 * @LastEditTime: 2021-01-06 14:32:59
 * @LastEditors: Please set LastEditors
 * @Description: In User Settings Edit
 * @FilePath: /flutter/udemy_flutter_sec9/lib/model/http_exception.dart
 */
//自定义error class， 用于product_provider.dart
class HttpException implements Exception {
  final String message;
  HttpException(this.message);

  @override
  String toString() {
    return message;
    //return super.toString();
  }
}
