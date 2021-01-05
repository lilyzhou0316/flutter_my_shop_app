/*
 * @Author: your name
 * @Date: 2020-12-23 14:38:34
 * @LastEditTime: 2020-12-23 19:11:53
 * @LastEditors: Please set LastEditors
 * @Description: In User Settings Edit
 * @FilePath: /flutter/udemy_flutter_sec8/lib/model/product.dart
 */
import 'package:flutter/foundation.dart';

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

  void toggleFavorite() {
    isFavorite = !isFavorite;
    //use notifyListeners to let widgets which listen to this provider know
    //that whether isFavorite is changed.
    notifyListeners();
  }
}
