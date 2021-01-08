/*
 * @Author: your name
 * @Date: 2020-12-23 14:54:40
 * @LastEditTime: 2021-01-08 14:03:24
 * @LastEditors: Please set LastEditors
 * @Description: In User Settings Edit
 * @FilePath: /flutter/udemy_flutter_sec8/lib/widget/product_item.dart
 */
//this is the widget to show how a product item should look like on screen
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../page/product_detail_page.dart';
import '../provider/product.dart';
import '../provider/cart.dart';
import '../provider/auth.dart';

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    final authData = Provider.of<Auth>(context, listen: false);
    //another way to set listener to product provider is using Consumer

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            //use pushnamed to jump to a named route
            //and pass the id to the new route
            Navigator.of(context).pushNamed(
              ProductDetailPage.routeName,
              arguments: product.id,
            );
          },
          child: Hero(
            tag: product.id,
            child: FadeInImage(
              placeholder: AssetImage('assets/images/product-placeholder.png'),
              image: NetworkImage(product.imageUrl),
              fit: BoxFit.cover,
            ),
          ),
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black54,

          //only wrap the widget that need to rebuild with Consumer
          leading: Consumer<Product>(
            //the child in the parameters is the part of widget that we don't want to
            //rebuild when provider is changed
            builder: (ctx, product, child) => IconButton(
              icon: Icon(
                product.isFavorite ? Icons.favorite : Icons.favorite_border,
              ),
              color: Theme.of(context).accentColor,
              onPressed: () {
                //传递token给product.dart
                product.toggleFavorite(authData.token, authData.userId);
              },
            ),
          ),
          title: Text(
            product.title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
            ),
            //是否需要换行
            softWrap: true,
            // 将溢出的文本淡化为透明
            overflow: TextOverflow.fade,
          ),
          trailing: IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              cart.addItem(product.id, product.price, product.title);
              //first hide current popup(snackbar)
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              //then show a new popup after clicking the shop_cart icon button
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Add to cart successfully!',
                    textAlign: TextAlign.center,
                  ),
                  duration: Duration(seconds: 2),
                  action: SnackBarAction(
                    label: 'Undo',
                    onPressed: () {
                      cart.removeSingleItem(product.id);
                    },
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
