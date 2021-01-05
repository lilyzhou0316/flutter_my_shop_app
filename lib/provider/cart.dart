/*
 * @Author: your name
 * @Date: 2020-12-23 20:16:39
 * @LastEditTime: 2021-01-04 15:31:21
 * @LastEditors: Please set LastEditors
 * @Description: In User Settings Edit
 * @FilePath: /flutter/udemy_flutter_sec8/lib/provider/cart.dart
 */
import 'package:flutter/material.dart';

class CartItem {
  final String id; //cartitem's id not product id
  final String title;
  final int quantity;
  final double price;

  CartItem({
    @required this.id,
    @required this.price,
    @required this.quantity,
    @required this.title,
  });
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {}; //一个cart里有很多个商品，这里string 即productId

  Map<String, CartItem> get items {
    return {..._items};
  }

  int get itemCount {
    return _items.length;
  }

  double get totalAmount {
    double total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.price * cartItem.quantity;
    });
    return total;
  }

//add product item to current cart item
  void addItem(
    String productId,
    double price,
    String title,
  ) {
    if (_items.containsKey(productId)) {
      //如果在，则改变该商品数量
      _items.update(
        productId,
        (existingCartItem) => CartItem(
          id: existingCartItem.id,
          price: existingCartItem.price,
          quantity: existingCartItem.quantity + 1,
          title: existingCartItem.title,
        ),
      );
    } else {
      //如果当前商品不在_items里，新建一个cartitem
      _items.putIfAbsent(
        productId, //use productId as key
        () => CartItem(
          id: DateTime.now().toString(),
          title: title,
          price: price,
          quantity: 1,
        ),
      );
    }
    notifyListeners();
  }

  void removeItem(String proudctId) {
    //to remove an entry from a map just use .remove();
    _items.remove(proudctId);
    notifyListeners();
  }

//delete a single product in the cart
  void removeSingleItem(String productId) {
    //if the product doesn't exist in the cart, return nothing
    if (!_items.containsKey(productId)) {
      return;
    }
    //if the product exists and quantity is > 1, reduce 1 from the quantity
    if (_items[productId].quantity > 1) {
      _items.update(
          productId,
          (existingCartItem) => CartItem(
                id: existingCartItem.id,
                title: existingCartItem.title,
                price: existingCartItem.price,
                quantity: existingCartItem.quantity - 1,
              ));
    } else {
      //if the product exists and quantity is 1, delete the product
      _items.remove(productId);
    }
  }

  void clear() {
    _items = {};
    notifyListeners();
  }
}
