/*
 * @Author: your name
 * @Date: 2021-01-05 14:24:53
 * @LastEditTime: 2021-01-06 14:07:38
 * @LastEditors: Please set LastEditors
 * @Description: In User Settings Edit
 * @FilePath: /flutter/udemy_flutter_sec9/lib/page/edit_product_page.dart
 */
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/product.dart';
import '../provider/product_provider.dart';
import '../page/user_product_page.dart';

class EditProductPage extends StatefulWidget {
  static const routeName = '/edit_product_page';
  @override
  _EditProductPageState createState() => _EditProductPageState();
}

class _EditProductPageState extends State<EditProductPage> {
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

  //根据_isInit值，使得initialize form操作只进行一次
  var _isInit = true;

//根据_isLoading值，判断是否显示loading页面
  var _isLoading = false;

  //用_initValue保存根据id获取到的商品对象的信息
  var _initValue = {
    'title': '',
    'description': '',
    'price': '',
    'imageURL': '',
  };
  @override
  void initState() {
    //初始化时就对image url输入框进行监听
    _imageFocusNode.addListener(_updateImageURL);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      //拿到从user_product_item页面传过来的对应商品的id
      final productId = ModalRoute.of(context).settings.arguments as String;
      //如果该商品存在
      if (productId != null) {
        //根据该id找到对应的商品对象
        final product = Provider.of<Products>(context).findById(productId);
        //再根据得到的对象把它的信息展示在当前页面上
        _editedProduct = product;
        _initValue = {
          'title': _editedProduct.title,
          'description': _editedProduct.description,
          //textcontroller和initvalue不能同时使用
          //'imageURL': _editedProduct.imageUrl,
          'imageURL': '',
          'price': _editedProduct.price.toString(),
        };
        _imageUrlController.text = _editedProduct.imageUrl;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
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
  Future<void> _saveForm() async {
    //先检验用户输入是否符合设定的规则
    final isValid = _form.currentState.validate();
    if (!isValid) {
      //如果不符合，则不保存，并显示error message
      return;
    }
    //如果符合，才保存输入的内容到一个新建的product对象中
    _form.currentState.save();

    //表单保存后，更改_isLoading值为true
    setState(() {
      _isLoading = true;
    });

    //然后将修改后的商品对象替换调list中的原对象
    if (_editedProduct.id != null) {
      //如果当前商品在list中则替换
      await Provider.of<Products>(context, listen: false)
          .updateProduct(_editedProduct.id, _editedProduct);
    } else {
      //如果不在则直接添加
      try {
        await Provider.of<Products>(context, listen: false)
            .addProduct(_editedProduct);
      } catch (error) {
        //如果添加失败则处理error
        await showDialog<Null>(
          context: context,
          builder: (ctx) => AlertDialog(
              title: Text('An error occured!'),
              content: Text('Something went wrong: $error'),
              actions: [
                FlatButton(
                  child: Text('Ok'),
                  onPressed: () {
                    //取消弹出对话框
                    Navigator.of(ctx).pop();
                  },
                )
              ]),
        );
      }
      // finally {
      //   //不管addProduct成功失败都会执行跳转到UserProductPage
      //   setState(() {
      //     _isLoading = false;
      //   });
      //   //跳转到user_product_page
      //   Navigator.of(context).pushNamed(UserProductPage.routeName);
      // }
    }
    //不管编辑商品成功失败都会执行跳转到UserProductPage
    setState(() {
      _isLoading = false;
    });

    //最后跳转到user_product_page
    Navigator.of(context).pushNamed(UserProductPage.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveForm,
          ),
        ],
      ),
      //根据_isLoading值展示不同页面
      body: _isLoading
          ? Center(
              //loading页面
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              //用户输入表单
              child: Form(
                key: _form,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      TextFormField(
                        //把根据id获取到的商品的信息显示在输入框中
                        initialValue: _initValue['title'],
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
                            id: _editedProduct.id,
                            isFavorite: _editedProduct.isFavorite,
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
                        initialValue: _initValue['price'],
                        decoration: InputDecoration(
                          labelText: 'Price',
                        ),
                        textInputAction: TextInputAction.next,
                        //设置键盘为数字键盘
                        keyboardType: TextInputType.number,
                        //指定焦点移动到对应的输入框
                        focusNode: _priceFocusNode,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context)
                              .requestFocus(_descriptionFocusNode);
                        },
                        onSaved: (value) {
                          _editedProduct = Product(
                            id: _editedProduct.id,
                            isFavorite: _editedProduct.isFavorite,
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
                            //price输入���非数字
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
                        initialValue: _initValue['description'],
                        decoration: InputDecoration(
                          labelText: 'Description',
                        ),
                        maxLines: 3,
                        //设置键盘为���行输入
                        keyboardType: TextInputType.multiline,
                        focusNode: _descriptionFocusNode,
                        onSaved: (value) {
                          _editedProduct = Product(
                            id: _editedProduct.id,
                            isFavorite: _editedProduct.isFavorite,
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
                              decoration:
                                  InputDecoration(labelText: 'Image URL'),
                              //设置键盘为url输入
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
                                  id: _editedProduct.id,
                                  isFavorite: _editedProduct.isFavorite,
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
