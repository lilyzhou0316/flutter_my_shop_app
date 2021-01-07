/*
 * @Author: your name
 * @Date: 2021-01-04 12:56:16
 * @LastEditTime: 2021-01-06 16:26:03
 * @LastEditors: Please set LastEditors
 * @Description: In User Settings Edit
 * @FilePath: /flutter/udemy_flutter_sec8/lib/provider/order.dart
 */
import 'dart:convert'; //用于转换json数据
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../provider/cart.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({
    @required this.id,
    @required this.amount,
    @required this.products,
    @required this.dateTime,
  });
}

class Order with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    //将新增order保存在数据库中
    const url =
        'https://flutter-my-shop-app-6a2d3-default-rtdb.firebaseio.com/orders.json';
    final timestamp = DateTime.now();

    final response = await http.post(
      url,
      //body需要传入json格式的数据，所以这里需要我们将product对象转换成json数据
      //调用json.encode（）传入一个map对象,进行转换
      body: json.encode({
        'amount': total,
        //把cartProducts这个list转换成map
        'products': cartProducts
            .map((cp) => {
                  'id': cp.id,
                  'title': cp.title,
                  'quantity': cp.quantity,
                  'price': cp.price,
                })
            .toList(),
        'dateTime': timestamp.toIso8601String(), //这种格式可以很容易还原成时间戳
      }),
    );

    //添加数据库成功，则将新订单加入list
    _orders.insert(
        0,
        OrderItem(
          id: json.decode(response.body)['name'],
          amount: total,
          products: cartProducts,
          dateTime: timestamp,
        ));
    notifyListeners();
  }

  Future<void> fetchOrders() async {
    //从数据库中获取已存在的order
    const url =
        'https://flutter-my-shop-app-6a2d3-default-rtdb.firebaseio.com/orders.json';
    try {
      final response = await http.get(url);
      final data =
          json.decode(response.body) as Map<String, dynamic>; //map of all data
      final List<OrderItem> orderList = []; //保存从数据库中取出的所有订单对象
      //先检查数据库里是否有订单，没有则直接返回
      if (data == null) {
        return;
      }
      //data里的每一个key都是一个订单的id，每一个value都是该订单的信息（也是map格式）
      data.forEach((id, info) {
        orderList.insert(
          0,
          OrderItem(
            id: id,
            amount: info['amount'],
            dateTime: DateTime.parse(info['dateTime']), //把时间戳从string转换成datetime
            products: (info['products'] as List<dynamic>)
                .map(
                  (item) => CartItem(
                    id: item['id'],
                    price: item['price'],
                    quantity: item['quantity'],
                    title: item['title'],
                  ),
                )
                .toList(), //把获取到的map list转换成CartItem list
          ),
        );
      });
      _orders = orderList;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }
}
