/*
 * @Author: your name
 * @Date: 2020-12-23 20:58:54
 * @LastEditTime: 2021-01-06 16:06:26
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
            alignment: Alignment.center,
            margin: EdgeInsets.fromLTRB(0, 0, 0, 15),
            child: OrderButton(cart: cart),
          ),
        ],
      ),
    );
  }
}

class OrderButton extends StatefulWidget {
  const OrderButton({
    Key key,
    @required this.cart,
  }) : super(key: key);

  final Cart cart;

  @override
  _OrderButtonState createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  //控制当点击order now按钮后，在处理数据的过程中显示loading page
  var _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      child: _isLoading
          ? CircularProgressIndicator()
          : Text(
              'order now',
              style: TextStyle(
                fontSize: 22,
              ),
            ),
      //如果订单的金额小于等于0或者正在处理订单过程中（上传数据）则按钮呈灰色
      onPressed: (widget.cart.totalAmount <= 0 || _isLoading == true)
          ? null
          : () async {
              setState(() {
                _isLoading = true;
              });
              //listen to Order
              await Provider.of<Order>(context, listen: false).addOrder(
                widget.cart.items.values.toList(),
                widget.cart.totalAmount,
              );
              //数据提交数据库完成后不再显示loading page
              setState(() {
                _isLoading = false;
              });
              //once create the order, then clear the cart
              widget.cart.clear();
            },
      color: Theme.of(context).primaryColor,
      textColor: Colors.white,
    );
  }
}
