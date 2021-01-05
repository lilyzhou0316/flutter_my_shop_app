/*
 * @Author: your name
 * @Date: 2020-12-23 14:37:03
 * @LastEditTime: 2021-01-04 14:16:42
 * @LastEditors: Please set LastEditors
 * @Description: In User Settings Edit
 * @FilePath: /flutter/udemy_flutter_sec8/lib/page/products_page.dart
 */
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widget/products_gridview.dart';
import '../provider/cart.dart';
import '../widget/badge.dart';
import '../page/cart_page.dart';
import '../widget/app_drawer.dart';

enum FilterOptions {
  Favorites,
  All,
}

class ProductsOverviewPage extends StatefulWidget {
  @override
  _ProductsOverviewPageState createState() => _ProductsOverviewPageState();
}

class _ProductsOverviewPageState extends State<ProductsOverviewPage> {
  //because _showFavoritesOnly only affects this widget, so we use statefullwidget
  //instead of provider(global) here to change the value of _showFavoritesOnly
  //then pass it to ProductsGridView()
  bool _showFavoritesOnly = false;
  @override
  Widget build(BuildContext context) {
    //Provider.of<Products> will use get() in provider to return a list
    // final productsList = Provider.of<Products>(
    //   context,
    //   listen: false,
    // );

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My Shop Home Page',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          PopupMenuButton(
            onSelected: (FilterOptions selectedValue) {
              //print(selectedValue);
              setState(() {
                if (selectedValue == FilterOptions.Favorites) {
                  _showFavoritesOnly = true;
                } else {
                  _showFavoritesOnly = false;
                }
              });
            },
            icon: Icon(
              Icons.more_vert,
            ),
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text('Only Favorites'),
                value: FilterOptions.Favorites,
              ),
              PopupMenuItem(
                child: Text('Show All'),
                value: FilterOptions.All,
              ),
            ],
          ),
          Consumer<Cart>(
            builder: (_, cartData, child) => Badge(
              child: child,
              value: cartData.itemCount.toString(),
            ),
            child: IconButton(
              icon: Icon(
                Icons.shopping_cart,
              ),
              onPressed: () {
                Navigator.of(context).pushNamed(CartPage.routeName);
              },
            ),
          )
        ],
      ),
      drawer: AppDrawer(),
      //we don't know how many products will have, so use builder
      body: ProductsGridView(_showFavoritesOnly),
    );
  }
}
