/*
 * @Author: your name
 * @Date: 2021-01-04 16:14:12
 * @LastEditTime: 2021-01-05 14:20:12
 * @LastEditors: Please set LastEditors
 * @Description: In User Settings Edit
 * @FilePath: /flutter/udemy_flutter_sec9/lib/page/edit_product_page.dart
 */
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/product.dart';
import '../provider/product_provider.dart';
import '../page/user_product_page.dart';

class AddProductPage extends StatefulWidget {
  static const routeName = '/add_product_page';
  @override
  _AddProductPageState createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final _priceFocusNode = FocusNode(); //指定焦点移动到对应的输入框
  final _descriptionFocusNode = FocusNode();
  final _imageFocusNode = FocusNode();
  final _imageUrlController = TextEditingController(); //获取url输入框内容

  //global key用于控制整个表单
  final _form = GlobalKey<FormState>();

  //product对象，用于保存用户编辑后的商品各个属性
  var _editedProduct = Product(
    id: null,
    title: '',
    price: 0,
    description: '',
    imageUrl: '',
  );

  @override
  void initState() {
    //初始化时就对image url输入框进行监听
    _imageFocusNode.addListener(_updateImageURL);
    super.initState();
  }

  @override
  void dispose() {
    _imageFocusNode.removeListener(_updateImageURL);
    //clear up memory
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageFocusNode.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  void _updateImageURL() {
    //如果url输入框没有焦点了，则刷新widget
    if (!_imageFocusNode.hasFocus) {
      setState(() {});
    }
  }

//保存表单里的各个输入框的内容（当此方法被触发时，各个输入框会自动触发它们的onsaved方法）
  void _saveForm() {
    //先检验用户输入是否符合设定的规则
    final isValid = _form.currentState.validate();
    if (!isValid) {
      //如果不符合，则不保存，并显示error message
      return;
    }
    //如果符合，才保存输入的内容到一个新建的product对象中
    _form.currentState.save();
    //然后将该对象加入到products list中(通过provider获取当前products list)
    Provider.of<Products>(context, listen: false).addProduct(_editedProduct);
    //最后跳转到user_product_page
    Navigator.of(context).pushNamed(UserProductPage.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add a new product'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveForm,
          ),
        ],
      ),
      //用户输入表单
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _form,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Title',
                    //这里可设定error message相关参数
                  ),
                  //将键盘上的确定按钮设置为移动至下一个输入框按钮（->）
                  textInputAction: TextInputAction.next,
                  //当按下键盘上的下一个（->）按钮时,触发回调函数，将焦点移动到指定的输入框
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_priceFocusNode);
                  },
                  //搭配global key一起使用，当确认提交按钮触发时，此函数会自动被触发
                  onSaved: (value) {
                    _editedProduct = Product(
                      id: null,
                      title: value,
                      price: _editedProduct.price,
                      description: _editedProduct.description,
                      imageUrl: _editedProduct.imageUrl,
                    );
                  },
                  //对用户输入的内容进行检测，看是否符合设定的规则
                  //value即为用户输入的内容，如果return null说明输入符合规则
                  validator: (value) {
                    if (value.isEmpty) {
                      //显示error message
                      return 'Title should not be empty!';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Price',
                  ),
                  textInputAction: TextInputAction.next,
                  //设置键盘为数字键盘
                  keyboardType: TextInputType.number,
                  //指定焦点移动到对应的输入框
                  focusNode: _priceFocusNode,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_descriptionFocusNode);
                  },
                  onSaved: (value) {
                    _editedProduct = Product(
                      id: null,
                      title: _editedProduct.title,
                      price: double.parse(value),
                      description: _editedProduct.description,
                      imageUrl: _editedProduct.imageUrl,
                    );
                  },
                  validator: (value) {
                    if (value.isEmpty) {
                      //price输入为空
                      return 'Price should not be empty!';
                    }
                    if (double.tryParse(value) == null) {
                      //price输入为非数字
                      return 'Please enter a valid number!';
                    }
                    if (double.parse(value) <= 0) {
                      //price输入的数字小于0
                      return 'Please enter a number greater than 0!';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Description',
                  ),
                  maxLines: 3,
                  //设置键盘为多行输入
                  keyboardType: TextInputType.multiline,
                  focusNode: _descriptionFocusNode,
                  onSaved: (value) {
                    _editedProduct = Product(
                      id: null,
                      title: _editedProduct.title,
                      price: _editedProduct.price,
                      description: value,
                      imageUrl: _editedProduct.imageUrl,
                    );
                  },
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Description should not be empty!';
                    }
                    if (value.length < 10) {
                      return 'Should be at least 10 characters long!';
                    }
                    return null;
                  },
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    //Container用于预览图片
                    Container(
                      width: 100,
                      height: 100,
                      margin: EdgeInsets.only(top: 8, right: 10),
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 1,
                          color: Colors.grey,
                        ),
                      ),
                      child: _imageUrlController.text.isEmpty
                          ? Text('enter a url!')
                          : FittedBox(
                              child: Image.network(
                                _imageUrlController.text,
                                fit: BoxFit.cover,
                              ),
                            ),
                    ),
                    Expanded(
                      child: TextFormField(
                        decoration: InputDecoration(labelText: 'Image URL'),
                        //设置���盘为url输入
                        keyboardType: TextInputType.url,
                        //TextInputAction.done表示键盘右下角显示为✅
                        textInputAction: TextInputAction.done,
                        controller: _imageUrlController,
                        focusNode: _imageFocusNode,
                        //当键盘右下角完成按钮点击时，触发_saveForm函数
                        onFieldSubmitted: (_) {
                          _saveForm();
                        },
                        onSaved: (value) {
                          _editedProduct = Product(
                            id: null,
                            title: _editedProduct.title,
                            price: _editedProduct.price,
                            description: _editedProduct.description,
                            imageUrl: value,
                          );
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Image URL should not be empty!';
                          }
                          if (!value.startsWith('http') &&
                              !value.startsWith('https')) {
                            return 'Please enter a valid URL!';
                          }
                          if (!value.endsWith('.png') &&
                              !value.endsWith('.jpg') &&
                              !value.endsWith('.jpeg')) {
                            return 'Please enter a valid image URL!';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
