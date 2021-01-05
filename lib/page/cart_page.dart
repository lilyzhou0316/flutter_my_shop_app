/*
 * @Author: your name
 * @Date: 2020-12-23 20:58:54
 * @LastEditTime: 2021-01-04 14:32:21
 * @LastEditors: Please set LastEditors
 * @Description: In User Settings Edit
 * @FilePath: /flutter/udemy_flutter_sec8/lib/page/cart_page.dart
 */
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/cart.dart';
import '../widget/cart_item.dart';
import '../provider/order.dart';

class CartPage extends StatelessWidget {
  static const routeName = '/cart_page';

  @override
  Widget build(BuildContext context) {
    //get cart data and set up listener
    final cart = Provider.of<Cart>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Cart Page'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Card(
            margin: EdgeInsets.all(15),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total: ',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  //SizedBox(width: 10),
                  Spacer(),
                  Chip(
                    label: Text(
                      '\$ ${cart.totalAmount.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 20,
                        fontFamily: 'RobotoCondensed',
                        color: Colors.white,
                      ),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: cart.itemCount,
              itemBuilder: (ctx, index) => CartItemShow(
                //cart.items is a map(_items)
                //its value is obj CartItem
                //its key is productId
                id: cart.items.values.toList()[index].id,
                price: cart.items.values.toList()[index].price,
                quantity: cart.items.values.toList()[index].quantity,
                title: cart.items.values.toList()[index].title,
                productId: cart.items.keys.toList()[index],
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(0, 0, 15, 0),
            child: RaisedButton(
              child: Text(
                'order now',
                style: TextStyle(
                  fontSize: 22,
                ),
              ),
              onPressed: () {
                //listen to Order
                Provider.of<Order>(context, listen: false).addOrder(
                  cart.items.values.toList(),
                  cart.totalAmount,
                );
                //once create the order, then clear the cart
                cart.clear();
              },
              color: Theme.of(context).primaryColor,
              textColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
