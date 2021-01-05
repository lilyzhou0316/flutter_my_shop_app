/*
 * @Author: your name
 * @Date: 2021-01-04 14:54:53
 * @LastEditTime: 2021-01-05 14:52:35
 * @LastEditors: Please set LastEditors
 * @Description: In User Settings Edit
 * @FilePath: /flutter/udemy_flutter_sec9/lib/main.dart
 */
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './provider/cart.dart';
import './page/product_detail_page.dart';
import './page/products_overview_page.dart';
import './provider/product_provider.dart';
import './page/cart_page.dart';
import './provider/order.dart';
import './page/order_page.dart';
import './page/user_product_page.dart';
import './page/add_product_page.dart';
import './page/edit_product_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Products(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Cart(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Order(),
        )
      ],
      child: MaterialApp(
        title: 'My App',
        theme: ThemeData(
          primarySwatch: Colors.blueGrey,
          accentColor: Colors.red,
          fontFamily: 'Raleway',
        ),
        home: ProductsOverviewPage(),
        routes: {
          ProductDetailPage.routeName: (ctx) => ProductDetailPage(),
          CartPage.routeName: (ctx) => CartPage(),
          OrderPage.routeName: (ctx) => OrderPage(),
          UserProductPage.routeName: (ctx) => UserProductPage(),
          AddProductPage.routeName: (ctx) => AddProductPage(),
          EditProductPage.routeName: (ctx) => EditProductPage(),
        },
        onGenerateRoute: (settings) {},
        onUnknownRoute: (settings) {},
      ),
    );
  }
}
