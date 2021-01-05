/*
 * @Author: your name
 * @Date: 2021-01-04 14:06:34
 * @LastEditTime: 2021-01-04 16:10:28
 * @LastEditors: Please set LastEditors
 * @Description: In User Settings Edit
 * @FilePath: /flutter/udemy_flutter_sec8/lib/widget/app_drawer.dart
 */
import 'package:flutter/material.dart';

import '../page/order_page.dart';
import '../page/user_product_page.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: Text('hello friend!'),
            //don't show the back button here
            automaticallyImplyLeading: false,
          ),
          ListTile(
            leading: Icon(
              Icons.payment,
            ),
            title: Text('Orders'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(OrderPage.routeName);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(
              Icons.shop,
            ),
            title: Text('Shop'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(
              Icons.edit,
            ),
            title: Text('Manage Products'),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(UserProductPage.routeName);
            },
          ),
        ],
      ),
    );
  }
}