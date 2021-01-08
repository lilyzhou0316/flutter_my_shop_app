/*
 * @Author: your name
 * @Date: 2020-12-23 15:38:32
 * @LastEditTime: 2021-01-08 14:13:58
 * @LastEditors: Please set LastEditors
 * @Description: In User Settings Edit
 * @FilePath: /flutter/udemy_flutter_sec8/lib/page/product_detail_page.dart
 */
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/product_provider.dart';

class ProductDetailPage extends StatelessWidget {
  static const routeName = '/product_detail';

  @override
  Widget build(BuildContext context) {
    //get product id passed from product_item.dart by arguments
    final productId = ModalRoute.of(context).settings.arguments as String;
    //get products list from provider
    final products = Provider.of<Products>(
      //if we set listen to false, then this widget will not rebuild if
      //the provider changed, it is not an active listener.
      context,
      listen: false,
    );
    //get current product from products list by id
    final currentProduct = products.findById(productId);

    return Scaffold(
      // appBar: AppBar(
      //   title: Text(currentProduct.title),
      // ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            //appbar永远显示在头部
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(currentProduct.title),
              background: Hero(
                tag: currentProduct.id,
                child: Image.network(
                  currentProduct.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              SizedBox(
                height: 10,
              ),
              //2.show the price
              Text(
                '\$ ${currentProduct.price}',
                style: TextStyle(
                  //color: Colors.grey,
                  fontSize: 24,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 10,
              ),
              //3. show description
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 10,
                ),
                width: double.infinity,
                child: Text(
                  currentProduct.description,
                  textAlign: TextAlign.center,
                  softWrap: true, //wrap to new lines
                  style: TextStyle(
                    fontSize: 22,
                  ),
                ),
              ),
              SizedBox(height: 800),
            ]),
          ),
        ],
      ),
    );
  }
}
