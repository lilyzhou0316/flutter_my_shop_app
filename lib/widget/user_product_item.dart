/*
 * @Author: your name
 * @Date: 2021-01-04 15:56:14
 * @LastEditTime: 2021-01-06 14:53:55
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
    //在下面delete的try-catch里不能直接使用ScaffoldMessenger.of(context)
    //因为这里的context很有可能已经指向的不是同一个widget了（已经刷新了）
    //所以需要在这里直接获取最初的context
    final scaffold = ScaffoldMessenger.of(context);
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
              onPressed: () async {
                //delete
                try {
                  await Provider.of<Products>(context, listen: false)
                      .deleteProduct(id);
                } catch (err) {
                  scaffold.showSnackBar(
                    SnackBar(
                      content: Text('Deleting failed!'),
                    ),
                  );
                }
              },
              color: Theme.of(context).errorColor,
            ),
          ],
        ),
      ),
    );
  }
}
