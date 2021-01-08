/*
 * @Author: your name
 * @Date: 2021-01-04 14:54:53
 * @LastEditTime: 2021-01-08 14:42:47
 * @LastEditors: Please set LastEditors
 * @Description: In User Settings Edit
 * @FilePath: /flutter/udemy_flutter_sec9/lib/main.dart
 */
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './provider/cart.dart';
import './provider/product_provider.dart';
import './provider/order.dart';
import './provider/auth.dart';
import './page/cart_page.dart';
import './page/product_detail_page.dart';
import './page/products_overview_page.dart';
import './page/order_page.dart';
import './page/user_product_page.dart';
import './page/add_product_page.dart';
import './page/edit_product_page.dart';
import './page/auth_page.dart';
import './page/splash_screen.dart';
import 'helper/custom_route.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        //添加需要监听的对象
        providers: [
          ChangeNotifierProvider(
            create: (ctx) => Auth(),
          ),
          ChangeNotifierProxyProvider<Auth, Products>(
            //此provider基于auth，所以auth的位置一定要在它之前
            //传递token给prduct_provider.dart
            update: (ctx, auth, previousProducts) => Products(
              auth.token,
              auth.userId,
              previousProducts == null ? [] : previousProducts.items,
            ),
          ),
          ChangeNotifierProvider(
            create: (ctx) => Cart(),
          ),
          ChangeNotifierProxyProvider<Auth, Order>(
            //传递token给order.dart
            update: (ctx, auth, previousOrders) => Order(
              auth.token,
              auth.userId,
              previousOrders == null ? [] : previousOrders.orders,
            ),
          ),
        ],
        child: Consumer<Auth>(
          builder: (ctx, auth, child) => MaterialApp(
            title: 'My App',
            theme: ThemeData(
              primarySwatch: Colors.blueGrey,
              accentColor: Colors.red,
              fontFamily: 'Raleway',
              //改变所有页面加载效果
              pageTransitionsTheme: PageTransitionsTheme(
                builders: {
                  TargetPlatform.android: CustomPageTransitionBuilder(),
                  TargetPlatform.iOS: CustomPageTransitionBuilder(),
                },
              ),
            ),
            //home页面根据用户是否登入来判断显示哪个
            home: auth.isAuth
                ? ProductsOverviewPage()
                : FutureBuilder(
                    //尝试自动登录，如果自动登录成功则先展示loading页面
                    //如果不成功则展示登录页面
                    future: auth.autoLogin(),
                    builder: (ctx, authResultSnapshot) =>
                        authResultSnapshot.connectionState ==
                                ConnectionState.waiting
                            ? SplashScreen()
                            : AuthPage(),
                  ),
            routes: {
              //注册除了home以外的其它页面
              ProductDetailPage.routeName: (ctx) => ProductDetailPage(),
              CartPage.routeName: (ctx) => CartPage(),
              OrderPage.routeName: (ctx) => OrderPage(),
              UserProductPage.routeName: (ctx) => UserProductPage(),
              AddProductPage.routeName: (ctx) => AddProductPage(),
              EditProductPage.routeName: (ctx) => EditProductPage(),
              //ProductsOverviewPage.routeName: (ctx) => ProductsOverviewPage(),
              //AuthPage.routeName: (ctx) => AuthPage(),
            },
            onGenerateRoute: (settings) {},
            onUnknownRoute: (settings) {},
          ),
        ));
  }
}
