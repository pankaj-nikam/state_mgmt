import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:state_mgmt/providers/product.dart';
import 'package:state_mgmt/providers/products_provider.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit-product';
  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _form = GlobalKey<FormState>();
  var isInit = true;
  var isLoading = false;

  var _editedProduct = Product(
    id: null,
    title: '',
    price: 0,
    description: '',
    imageUrl: '',
  );

  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      if ((!_imageUrlController.text.startsWith('http') &&
              !_imageUrlController.text.startsWith('https')) ||
          (!_imageUrlController.text.endsWith('.png') &&
              !_imageUrlController.text.endsWith('.jpg') &&
              !_imageUrlController.text.endsWith('.jpeg'))) {
        return;
      }
      setState(() {});
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlController.dispose();
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _imageUrlFocusNode.dispose();
    super.dispose();
  }

  Future<void> _saveForm() async {
    if (_form.currentState.validate()) {
      _form.currentState.save();
      setState(() {
        isLoading = true;
      });
      if (_editedProduct.id != null) {
        Provider.of<Products>(context, listen: false)
            .updateProduct(_editedProduct);
        setState(() {
          isLoading = false;
        });
        Navigator.of(context).pop();
      } else {
        try {
          await Provider.of<Products>(context, listen: false)
              .addProduct(_editedProduct);
        } catch (error) {
          await showDialog<Null>(
            context: context,
            builder: (ctx) => AlertDialog(
              title: Text('An error occurred'),
              content: Text('Something went wrong.'),
              actions: [
                FlatButton(
                  child: Text('Okay'),
                  onPressed: () => Navigator.of(ctx).pop(),
                ),
              ],
            ),
          );
        } finally {
          setState(() {
            isLoading = false;
          });
          Navigator.of(context).pop();
        }

        //     .catchError().then((_) {
        //   setState(() {
        //     isLoading = false;
        //   });
        //   Navigator.of(context).pop();
        // });
      }
    }
  }

  @override
  void didChangeDependencies() {
    if (isInit) {
      final productId = ModalRoute.of(context).settings.arguments as String;
      if (productId != null) {
        _editedProduct = Provider.of<Products>(
          context,
          listen: false,
        ).getProductById(productId);
        _imageUrlController.text = _editedProduct.imageUrl;
      }
    }
    isInit = false;
    super.didChangeDependencies();
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
          )
        ],
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _form,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      TextFormField(
                        initialValue: _editedProduct.title,
                        decoration: InputDecoration(labelText: 'Title'),
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_priceFocusNode);
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please provide a value.';
                          }
                          return null;
                        },
                        onSaved: (newValue) {
                          _editedProduct = Product(
                            title: newValue,
                            price: _editedProduct.price,
                            description: _editedProduct.description,
                            id: _editedProduct.id,
                            imageUrl: _editedProduct.imageUrl,
                            isFavorite: _editedProduct.isFavorite,
                          );
                        },
                      ),
                      TextFormField(
                        decoration: InputDecoration(labelText: 'Price'),
                        initialValue: _editedProduct.price.toString(),
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.number,
                        focusNode: _priceFocusNode,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context)
                              .requestFocus(_descriptionFocusNode);
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter a price';
                          } else if (double.tryParse(value) == null) {
                            return 'Please enter a valid price';
                          } else if (double.parse(value) <= 0) {
                            return 'Price must be greater than zero.';
                          }
                          return null;
                        },
                        onSaved: (newValue) {
                          _editedProduct = Product(
                            title: _editedProduct.title,
                            price: double.parse(newValue),
                            description: _editedProduct.description,
                            id: _editedProduct.id,
                            imageUrl: _editedProduct.imageUrl,
                            isFavorite: _editedProduct.isFavorite,
                          );
                        },
                      ),
                      TextFormField(
                        decoration: InputDecoration(labelText: 'Description'),
                        maxLines: 3,
                        initialValue: _editedProduct.description,
                        keyboardType: TextInputType.multiline,
                        focusNode: _descriptionFocusNode,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Description is required.';
                          } else if (value.length < 10) {
                            return 'Description should be at least 10 characters long.';
                          }
                          return null;
                        },
                        onSaved: (newValue) {
                          _editedProduct = Product(
                            title: _editedProduct.title,
                            price: _editedProduct.price,
                            description: newValue,
                            id: _editedProduct.id,
                            imageUrl: _editedProduct.imageUrl,
                            isFavorite: _editedProduct.isFavorite,
                          );
                        },
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            height: 100,
                            width: 100,
                            margin: EdgeInsets.only(top: 8, right: 10),
                            decoration: BoxDecoration(
                              border: Border.all(width: 1, color: Colors.grey),
                            ),
                            child: _imageUrlController.text.isEmpty
                                ? Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text('Enter a URL'),
                                  )
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
                              keyboardType: TextInputType.url,
                              textInputAction: TextInputAction.done,
                              controller: _imageUrlController,
                              focusNode: _imageUrlFocusNode,
                              onFieldSubmitted: (_) {
                                _saveForm();
                              },
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Please enter an image';
                                } else if (!value.startsWith('http') &&
                                    !value.startsWith('https')) {
                                  return 'Please enter a valid url.';
                                } else if (!value.endsWith('.jpg') &&
                                    !value.endsWith('.png') &&
                                    !value.endsWith('.jpeg')) {
                                  return 'Please enter a valid image url.';
                                }
                                return null;
                              },
                              onSaved: (newValue) {
                                _editedProduct = Product(
                                  title: _editedProduct.title,
                                  price: _editedProduct.price,
                                  description: _editedProduct.description,
                                  id: _editedProduct.id,
                                  imageUrl: newValue,
                                  isFavorite: _editedProduct.isFavorite,
                                );
                              },
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
