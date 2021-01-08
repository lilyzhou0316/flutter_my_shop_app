/*
 * @Author: your name
 * @Date: 2020-12-23 16:13:40
 * @LastEditTime: 2021-01-07 17:28:41
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
  ]; //it will be changed, so it is not final

//接受从auth.dart传过来的token(在main.dart里实现)
  final String authToken;
  final String userId;
  Products(this.authToken, this.userId, this._items);

  List<Product> get items {
    //we cannot return _items directly, because then we can
    //change the _items list directly later, but we should not do that.
    return [..._items];
  }

  List<Product> get favoriteItems {
    return _items.where((pro) => pro.isFavorite).toList();
  }

//[bool filterByUser = false]代表如果没有传入filterByUser值，则默认为false
  Future<void> fetchProducts([bool filterByUser = false]) async {
    //用http.get（）从firebase中获取已存在的商品data
    //根据指定的用户id只加载该用户创建的商品
    //注意：firebase需要在database rules里指定需要操作的index，如下：
    // "products":{
    //    ".indexOn":["creator"]
    // }
    //用filterString来控制是否使用filterByUser
    final filterString =
        filterByUser ? 'orderBy="creator"&equalTo="$userId"' : '';
    final urlProducts =
        'https://flutter-my-shop-app-6a2d3-default-rtdb.firebaseio.com/products.json?auth=$authToken&$filterString';
    try {
      final response = await http.get(urlProducts);
      final data =
          json.decode(response.body) as Map<String, dynamic>; //map of all data
      final List<Product> proList = []; //保存从数据库中取出的所有商品

      //先检查数据库中是否有商品
      if (data == null) {
        return;
      }
      //从数据库中得到当前登录的用户的每个商品的favorite信息
      final urlFavorite =
          'https://flutter-my-shop-app-6a2d3-default-rtdb.firebaseio.com/userFavorites/$userId.json?auth=$authToken';
      final favoriteResponse = await http.get(urlFavorite);
      final favoriteData = json.decode(favoriteResponse.body);

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
            //根据商品id找到该用户对应的商品的favorite信息
            //如果当前用户没有favorite商品，则所有商品的favorite都为false
            //但是即使favoriteData不为null,指定的id找到的商品也有可能不存在
            //用??如果对应的商品不存在，则返回false,否则返回它自己的值
            isFavorite:
                favoriteData == null ? false : favoriteData[id] ?? false,
          ),
        );
      });

      _items = proList;
      notifyListeners();
    } catch (error) {
      //print(error);
    }
  }

  Future<void> addProduct(Product product) async {
    //用http.post（）向firebase中添加新商品数据
    //url为创建的firebase的realtime database的链接 + collection名 + .json（json为firebase特有）
    final url =
        'https://flutter-my-shop-app-6a2d3-default-rtdb.firebaseio.com/products.json?auth=$authToken';

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
          //给每个商品加上它的创建者id，这样在编辑修改商品时，用户就只能修改自己创建的商品
          //避免修改了其他用户上传的商品
          'creator': userId,
          //'isFavorite': product.isFavorite,
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
          'https://flutter-my-shop-app-6a2d3-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken';
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
        'https://flutter-my-shop-app-6a2d3-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken';

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
