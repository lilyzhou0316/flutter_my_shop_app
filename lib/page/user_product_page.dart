/*
 * @Author: your name
 * @Date: 2021-01-04 15:46:48
 * @LastEditTime: 2021-01-07 17:37:12
 * @LastEditors: Please set LastEditors
 * @Description: In User Settings Edit
 * @FilePath: /flutter/udemy_flutter_sec9/lib/page/user_product_page.dart
 */
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/product_provider.dart';
import '../widget/user_product_item.dart';
import '../widget/app_drawer.dart';
import '../page/add_product_page.dart';

class UserProductPage extends StatelessWidget {
  static const routeName = '/user_product_page';

  @override
  Widget build(BuildContext context) {
    //用provider获取并监听products对象(在product_porvider.dart)
    //final productsData = Provider.of<Products>(context);

    //刷新功能函数
    Future<void> _refresh(BuildContext ctx) async {
      //因为此widget是stateless，所以需要传递BuildContext
      await Provider.of<Products>(ctx, listen: false).fetchProducts(true);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Products'),
        actions: [
          //增加新商品
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(AddProductPage.routeName);
            },
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: _refresh(context),
        builder: (ctx, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : RefreshIndicator(
                    //实现下拉加载刷新功能
                    onRefresh: () => _refresh(context),
                    child: Consumer<Products>(
                      builder: (ctx, productsData, child) => Padding(
                        padding: EdgeInsets.all(8),
                        child: ListView.builder(
                          itemCount: productsData.items.length,
                          itemBuilder: (_, index) => Column(
                            children: [
                              UserProductItem(
                                title: productsData.items[index].title,
                                imageURL: productsData.items[index].imageUrl,
                                id: productsData.items[index].id,
                              ),
                              Divider(),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
      ),
    );
  }
}
