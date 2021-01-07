/*
 * @Author: your name
 * @Date: 2020-12-23 14:37:03
 * @LastEditTime: 2021-01-06 16:57:16
 * @LastEditors: Please set LastEditors
 * @Description: In User Settings Edit
 * @FilePath: /flutter/udemy_flutter_sec8/lib/page/products_page.dart
 */
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widget/products_gridview.dart';
import '../widget/badge.dart';
import '../widget/app_drawer.dart';
import '../provider/cart.dart';
import '../provider/product_provider.dart';
import '../page/cart_page.dart';

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

  //控制didChangeDependencies只运行一次
  var _isInit = true;

  //控制是否显示loading页面
  var _isLoading = false;

  //获取firebase中的数据
  @override
  void initState() {
    //Provider.of<Products>(context).fetchProducts();//单独用会报错，因为在initState阶段widget还没渲染完成
    //解决方法1:
    // Future.delayed(Duration.zero).then((res) {
    //   Provider.of<Products>(context).fetchProducts();
    // });
    super.initState();
  }

  //解决方法2:
  @override
  void didChangeDependencies() {
    //didChangeDependencies是在整个widget都渲染完成后build render前运行，
    //但是它会多次运行，所以需要一个变量来控制
    if (_isInit) {
      setState(() {
        _isLoading = true; //在数据获取还没完成时显示loading页面
      });
      Provider.of<Products>(context).fetchProducts().then((res) {
        setState(() {
          //在数据都获取完成后不再显示loading页面（即获取过程中一直显示loading）
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

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
      body: _isLoading
          ? Center(
              //loading页面
              child: CircularProgressIndicator(),
            )
          : ProductsGridView(
              _showFavoritesOnly), //we don't know how many products will have, so use builder
    );
  }
}
//解决方法3见order_page.dart
