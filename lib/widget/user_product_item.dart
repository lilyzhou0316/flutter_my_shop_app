/*
 * @Author: your name
 * @Date: 2021-01-04 15:56:14
 * @LastEditTime: 2021-01-05 15:14:46
 * @LastEditors: Please set LastEditors
 * @Description: In User Settings Edit
 * @FilePath: /flutter/udemy_flutter_sec9/lib/widget/user_product_item.dart
 */
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../page/edit_product_page.dart';
import '../provider/product_provider.dart';

class UserProductItem extends StatelessWidget {
  final String title;
  final String imageURL;
  final String id;
  //final Function deleteHandler;
  UserProductItem({this.title, this.imageURL, this.id});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageURL),
      ),
      trailing: Container(
        width: 100,
        child: Row(
          children: [
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                //edit
                Navigator.of(context).pushNamed(
                  EditProductPage.routeName,
                  arguments: id, //将对应的商品的id传给EditProductPage
                );
              },
              color: Theme.of(context).primaryColor,
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                //delete
                Provider.of<Products>(context, listen: false).deleteProduct(id);
              },
              color: Theme.of(context).errorColor,
            ),
          ],
        ),
      ),
    );
  }
}
