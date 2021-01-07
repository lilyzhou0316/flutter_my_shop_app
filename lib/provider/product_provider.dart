/*
 * @Author: your name
 * @Date: 2020-12-23 16:13:40
 * @LastEditTime: 2021-01-06 16:26:51
 * @LastEditors: Please set LastEditors
 * @Description: In User Settings Edit
 * @FilePath: /flutter/udemy_flutter_sec8/lib/provider/product_provider.dart
 */
//use mix-in with key word: with
import 'dart:convert'; //用于转换json数据
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import './product.dart';
import '../model/http_exception.dart';

class Products with ChangeNotifier {
  List<Product> _items = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
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

  Future<void> fetchProducts() async {
    //用http.get（）从firebase中获取已存在的商品data
    const url =
        'https://flutter-my-shop-app-6a2d3-default-rtdb.firebaseio.com/products.json';
    try {
      final response = await http.get(url);
      final data =
          json.decode(response.body) as Map<String, dynamic>; //map of all data
      final List<Product> proList = []; //保存从数据库中取出的所有商品
      //先检查数据库中是否有商品
      if (data == null) {
        return;
      }
      //data里的每一个key都是一个商品的id，每一个value都是该商品的信息（也是map格式）
      data.forEach((id, info) {
        proList.insert(
          0,
          Product(
            id: id,
            description: info['description'],
            imageUrl: info['imageURL'],
            price: info['price'],
            title: info['title'],
            isFavorite: info['isFavorite'],
          ),
        );
      });
      _items = proList;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> addProduct(Product product) async {
    //用http.post（）向firebase中添加新商品数据
    //url为创建的firebase的realtime database的链接 + collection名 + .json（json为firebase特有）
    const url =
        'https://flutter-my-shop-app-6a2d3-default-rtdb.firebaseio.com/products.json';

    //用try-catch处理error
    try {
      //post返回一个future对象，将它保存为response变量
      final response = await http.post(
        url,
        //body需要传入json格式的数据，所以这里需要我们将product对象转换成json数据
        //调用json.encode（）传入一个map对象,进行转换
        body: json.encode({
          'title': product.title,
          'description': product.description,
          'imageURL': product.imageUrl,
          'price': product.price,
          'isFavorite': product.isFavorite,
        }),
      );

      //当http post执行成功(直接运行接着的代码)，则将新商品加入list
      final newProduct = Product(
        //response对象里包含firebase随机生成的unique id,可将它作为商品的id
        //用json.decode将json数据对象转换成map
        id: json.decode(response.body)['name'], //DateTime.now().toString(),
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
    } catch (error) {
      //当post执行失败
      //print(error);
      throw error;
    }

    //.then((response) {
    //then也返回一个future对象，所以可以then().then()....

    //}).catchError((error) {
    //当future执行失败时,处理error
    // print(error);
    //抛出一个新的error对象给edit_product_page和add_product_page
    //throw error;
    //});
  }

  Product findById(String id) {
    return _items.firstWhere((pro) => pro.id == id);
  }

  Future<void> updateProduct(String id, Product product) async {
    //根据传入的id找list里对应的商品在list里的id
    final productIndex = _items.indexWhere((pro) => pro.id == id);
    if (productIndex >= 0) {
      //用http.patch()更新数据库中指定商品(根据传入id)的信息
      final url =
          'https://flutter-my-shop-app-6a2d3-default-rtdb.firebaseio.com/products/$id.json';
      await http.patch(
        url,
        body: json.encode({
          'title': product.title,
          'description': product.description,
          'imageURL': product.imageUrl,
          'price': product.price,
        }),
      );
      //如果能找到，则把在list中对应index的商品替换成传入的新商品
      _items[productIndex] = product;
      notifyListeners();
    } else {
      //如果没找到，则啥也不做
    }
  }

  Future<void> deleteProduct(String id) async {
    final url =
        'https://flutter-my-shop-app-6a2d3-default-rtdb.firebaseio.com/products/$id.json';

//先找到该商品在list中的index
//注意：这里用existingPro指向了被删除对象，它就暂时不会被GC回收
    final existingProIndex = _items.indexWhere((pro) => pro.id == id);
    var existingPro = _items[existingProIndex];

    //从list中删除该商品
    _items.removeAt(existingProIndex);
    notifyListeners();

    //用http.delete()删除数据库中指定id的商品
    final response = await http.delete(url);

    if (response.statusCode >= 400) {
      //如果在数据库中删除失败,则把被删除的商品对象又重新插入回list中它原本的index处
      _items.insert(existingProIndex, existingPro);
      notifyListeners();
      //delete方法并不会抛出error,而是显示statusCode，所以它始终进入then()
      //当statusCode >= 400时说明出现错误,自定义抛出错误
      throw HttpException(
          'Could not delete the product, something went wrong!');
    }
    //如果数据库中删除成功，则让existingPro指向null，即让被删除的商品对象被回收掉
    existingPro = null;
  }
}
