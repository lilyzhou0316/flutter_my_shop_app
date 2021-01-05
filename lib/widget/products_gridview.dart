/*
 * @Author: your name
 * @Date: 2020-12-23 17:18:33
 * @LastEditTime: 2020-12-23 20:15:30
 * @LastEditors: Please set LastEditors
 * @Description: In User Settings Edit
 * @FilePath: /flutter/udemy_flutter_sec8/lib/widget/products_gridview.dart
 */
//this is a widget extracted from products_overview_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widget/product_item.dart';
import '../provider/product_provider.dart';

class ProductsGridView extends StatelessWidget {
  //receive showFavorites passed from porducts_overview_page.dart
  final bool showFavorites;
  ProductsGridView(this.showFavorites);

  @override
  Widget build(BuildContext context) {
    //because products_gridview widget is the child of MaterialApp(in main.dart)
    //so we can set a connection between this widget and provider class
    //use of<Products> to specify the provider class
    final productsData = Provider.of<Products>(context);
    final products =
        showFavorites ? productsData.favoriteItems : productsData.items;
    return GridView.builder(
      padding: const EdgeInsets.all(10),
      itemCount: products.length,
      //use ChangeNotifierProvider to listen to each single product
      //so each time the single product is changed, the ProductItem widget
      //will rebuild.(in product_item.dart we need to receive the provider)

      //note, if we reuse the provider object instead of create an instance of it(see in main.dart),
      //we should use ChangeNotifierProvider.value instead of ChangeNotifierProvider
      itemBuilder: (ctx, index) => ChangeNotifierProvider.value(
        value: products[index],
        child: ProductItem(),
      ),
      //to set how many columns a row the grid should have
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, //2 columns a row
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 20,
      ),
    );
  }
}
