/*
 * @Author: your name
 * @Date: 2021-01-04 13:38:07
 * @LastEditTime: 2021-01-04 14:17:58
 * @LastEditors: Please set LastEditors
 * @Description: In User Settings Edit
 * @FilePath: /flutter/udemy_flutter_sec8/lib/page/order_page.dart
 */
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import '../provider/order.dart';
import '../widget/order_item.dart';
import '../widget/app_drawer.dart';

class OrderPage extends StatelessWidget {
  static const routeName = '/orders';
  @override
  Widget build(BuildContext context) {
    //get orders data from Order provider
    final orderData = Provider.of<Order>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('your orders '),
      ),
      drawer: AppDrawer(),
      body: ListView.builder(
        //orderData.orders = orderData.getOrders()调用类order的get方法
        itemCount: orderData.orders.length,
        itemBuilder: (context, index) => OrderItemShow(
          orderData.orders[index],
        ),
      ),
    );
  }
}
