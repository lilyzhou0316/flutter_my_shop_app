/*
 * @Author: your name
 * @Date: 2021-01-04 13:46:00
 * @LastEditTime: 2021-01-08 14:19:08
 * @LastEditors: Please set LastEditors
 * @Description: In User Settings Edit
 * @FilePath: /flutter/udemy_flutter_sec8/lib/widget/order_item.dart
 */
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../provider/order.dart';

class OrderItemShow extends StatefulWidget {
  final OrderItem order;
  OrderItemShow(this.order);

  @override
  _OrderItemShowState createState() => _OrderItemShowState();
}

class _OrderItemShowState extends State<OrderItemShow> {
  var _expanded = false; //to indicate whether icon button has been clicked

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      height:
          _expanded ? min(widget.order.products.length * 20.0 + 110, 200) : 100,
      child: Card(
        margin: EdgeInsets.all(10),
        child: Column(children: [
          ListTile(
            title: Text('\$ ${widget.order.amount}'),
            subtitle: Text(
              DateFormat('dd/MM/yyyy hh:mm').format(widget.order.dateTime),
            ),
            trailing: IconButton(
              icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
              onPressed: () {
                setState(() {
                  _expanded = !_expanded;
                });
              },
            ),
          ),
          AnimatedContainer(
            duration: Duration(milliseconds: 300),
            padding: EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 4,
            ),
            height: _expanded
                ? min(widget.order.products.length * 20.0 + 10, 180)
                : 0,
            child: ListView(
              children: widget.order.products
                  .map(
                    (product) => Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          product.title,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          ' ${product.quantity} * \$ ${product.price} ',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey,
                          ),
                        )
                      ],
                    ),
                  )
                  .toList(),
            ),
          )
        ]),
      ),
    );
  }
}
