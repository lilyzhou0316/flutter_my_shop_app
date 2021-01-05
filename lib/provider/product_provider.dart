/*
 * @Author: your name
 * @Date: 2020-12-23 16:13:40
 * @LastEditTime: 2021-01-05 15:11:27
 * @LastEditors: Please set LastEditors
 * @Description: In User Settings Edit
 * @FilePath: /flutter/udemy_flutter_sec8/lib/provider/product_provider.dart
 */
//use mix-in with key word: with
import 'package:flutter/material.dart';

import './product.dart';

class Products with ChangeNotifier {
  List<Product> _items = [
    Product(
      id: 'p1',
      title: 'Red Shirt',
      description: 'A red shirt - it is pretty red!',
      price: 29.99,
      imageUrl:
          'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    ),
    Product(
      id: 'p2',
      title: 'Trousers',
      description: 'A nice pair of trousers.',
      price: 59.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    ),
    Product(
      id: 'p3',
      title: 'Yellow Scarf',
      description: 'Warm and cozy - exactly what you need for the winter.',
      price: 19.99,
      imageUrl:
          'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    ),
    Product(
      id: 'p4',
      title: 'A Pan',
      description: 'Prepare any meal you want.',
      price: 49.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    ),
  ]; //it will be changed, so it is not final

  //var _showFavoritesOnly = false;

  // void showFavoritesOnly() {
  //   _showFavoritesOnly = true;
  //   notifyListeners();
  // }

  // void showAll() {
  //   _showFavoritesOnly = false;
  //   notifyListeners();
  // }

  List<Product> get items {
    //we cannot return _items directly, because then we can
    //change the _items list directly later, but we should not do that.
    return [..._items];
  }

  List<Product> get favoriteItems {
    return _items.where((pro) => pro.isFavorite).toList();
  }

  void addProduct(Product product) {
    final newProduct = Product(
      id: DateTime.now().toString(),
      title: product.title,
      description: product.description,
      imageUrl: product.imageUrl,
      price: product.price,
    );
    //_items.add(newProduct);//尾插
    _items.insert(0, newProduct); //头插
    //notifyListeners will establish a communicate channel for use between
    //the class and other widgets we interested in, then if the list change
    //it will trigger the widgets to update(rebuild)
    notifyListeners();
  }

  Product findById(String id) {
    return _items.firstWhere((pro) => pro.id == id);
  }

  void updateProduct(String id, Product product) {
    //根据传入的id找list里对应的商品在list里的id
    final productIndex = _items.indexWhere((pro) => pro.id == id);
    if (productIndex >= 0) {
      //如果能找到，则把在list中对应index的商品替换成传入的新商品
      _items[productIndex] = product;
      notifyListeners();
    } else {
      //如果没找到，则啥也不做
    }
  }

  void deleteProduct(String id) {
    _items.removeWhere((pro) => pro.id == id);
    notifyListeners();
  }
}
