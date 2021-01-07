/*
 * @Author: your name
 * @Date: 2021-01-04 13:38:07
 * @LastEditTime: 2021-01-06 16:56:17
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
    return Scaffold(
        appBar: AppBar(
          title: Text('your orders '),
        ),
        drawer: AppDrawer(),
        body: FutureBuilder(
          future: Provider.of<Order>(context, listen: false).fetchOrders(),
          builder: (ctx, dataSnapshot) {
            //FutureBuilder作用跟products_overview_page.dart里面init里的方法1Future.delayed基本一致
            //用FutureBuilder替换Future.delayed和_isLoading
            //这样就可以不用将此widget改为stateful widget
            if (dataSnapshot.connectionState == ConnectionState.waiting) {
              //ConnectionState.waiting说明正在处理数据中，需要显示loading page
              return Center(child: CircularProgressIndicator());
            } else {
              if (dataSnapshot.error != null) {
                //如果出现错误
                //...
                return Center(
                  child: Text('An error occurred!'),
                );
              } else {
                //如果数据处理成功
                return Consumer<Order>(
                  builder: (ctx, orderData, child) => ListView.builder(
                    //orderData.orders = orderData.getOrders()调用类order的get方法
                    itemCount: orderData.orders.length,
                    itemBuilder: (context, index) => OrderItemShow(
                      orderData.orders[index],
                    ),
                  ),
                );
              }
            }
          },
        ));
  }
}
