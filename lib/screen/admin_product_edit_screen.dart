import 'package:flutter/material.dart';
import 'package:my_app/model/product.dart';
import 'package:my_app/provider/product_provider.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

class AdminProductEditScreen extends StatefulWidget {
  static const routeName = '/admin-product-edit';

  const AdminProductEditScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _AdminProductEditScreenState();
  }
}

class _AdminProductEditScreenState extends State<AdminProductEditScreen> {
  final _descriptionFocusNode = FocusNode();
  final _priceFocusNode = FocusNode();
  final _imageFocusNode = FocusNode();
  final _categoryFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();

  final _form = GlobalKey<FormState>();
  bool _isLoading = false;
  final Timer _timer = Timer(const Duration(milliseconds: 1), () {});

  Product _editedProduct = Product(
    id: 0,
    name: '',
    description: '',
    unitPrice: 0,
    imageUrl: '',
    category: '',
  );

  var _initValues = {
    'name': '',
    'description': '',
    'unitPrice': '',
    'imageUrl': '',
    'category': '',
  };

  Future<bool> isUrlValid(url) async {
    try {
      final response = await http.head(Uri.parse(url));
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<void> _saveForm() async {
    bool isValid = _form.currentState!.validate();
    if (!isValid) {
      return;
    }
    if (!await isUrlValid(_imageUrlController.text)) {
      return;
    }
    setState(() {
      _isLoading = true;
    });
    _form.currentState!.save();

    try {
      if (_editedProduct.id != 0) {
        await context.read<ProductProvider>().updateProduct(_editedProduct);
      } else {
        await context.read<ProductProvider>().addProduct(_editedProduct);
      }
    } catch (error) {
      await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('An error occurred!'),
          content: Text(error.toString()),
          actions: [
            TextButton(
              child: const Text('Okay'),
              onPressed: () => Navigator.of(ctx).pop(),
            )
          ],
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
      Navigator.of(context).pop();
    }
  }

  _updateImageUrl() async {
    if (!_imageFocusNode.hasFocus) {
      if (_imageUrlController.text.isEmpty ||
          (!_imageUrlController.text.startsWith('http') &&
              !_imageUrlController.text.startsWith('https')) ||
          (!_imageUrlController.text.endsWith('.png') &&
              !_imageUrlController.text.endsWith('.jpg') &&
              !_imageUrlController.text.endsWith('.jpeg'))) {
        return;
      }
      if (await isUrlValid(_imageUrlController.text)) {
        setState(() {});
      }
    }
  }

  @override
  void initState() {
    _imageUrlController.addListener(_updateImageUrl);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (ModalRoute.of(context)!.settings.arguments != null) {
      final productId = ModalRoute.of(context)!.settings.arguments as int;
      if (productId != 0) {
        _editedProduct = context.read<ProductProvider>().findById(productId);
        _initValues = {
          'name': _editedProduct.name,
          'description': _editedProduct.description,
          'unitPrice': _editedProduct.unitPrice.toString(),
          'imageUrl': _editedProduct.imageUrl,
          'category': _editedProduct.category,
        };
        _imageUrlController.text = _editedProduct.imageUrl;
      }
    }

    final deviceSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Product'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveForm,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : SingleChildScrollView(
        child: Container(
          height: deviceSize.height,
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _form,
            child: Column(
              children: [
                TextFormField(
                  initialValue: _initValues['name'],
                  decoration: const InputDecoration(labelText: 'Name'),
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_priceFocusNode);
                  },
                  onSaved: (value) {
                    _editedProduct = Product(
                      id: _editedProduct.id,
                      name: value!,
                      description: _editedProduct.description,
                      unitPrice: _editedProduct.unitPrice,
                      imageUrl: _editedProduct.imageUrl,
                      category: _editedProduct.category,
                    );
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please provide a value';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  initialValue: _initValues['unitPrice'],
                  decoration: const InputDecoration(labelText: 'Price'),
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.number,
                  focusNode: _priceFocusNode,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_descriptionFocusNode);
                  },
                  onSaved: (value) {
                    _editedProduct = Product(
                      id: _editedProduct.id,
                      name: _editedProduct.name,
                      description: _editedProduct.description,
                      unitPrice: double.parse(value!),
                      imageUrl: _editedProduct.imageUrl,
                      category: _editedProduct.category,
                    );
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a price';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Please enter a valid number';
                    }
                    if (double.parse(value) <= 0) {
                      return 'Please enter a number greater than zero';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  initialValue: _initValues['description'],
                  decoration: const InputDecoration(labelText: 'Description'),
                  maxLines: 3,
                  focusNode: _descriptionFocusNode,
                  textInputAction: TextInputAction.next,
                  onSaved: (value) {
                    _editedProduct = Product(
                      id: _editedProduct.id,
                      name: _editedProduct.name,
                      description: value!,
                      unitPrice: _editedProduct.unitPrice,
                      imageUrl: _editedProduct.imageUrl,
                      category: _editedProduct.category,
                    );
                  },
                ),
                TextFormField(
                  initialValue: _initValues['category'],
                  decoration: const InputDecoration(labelText: 'Category'),
                  textInputAction: TextInputAction.next,
                  focusNode: _categoryFocusNode,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_imageFocusNode);
                  },
                  onSaved: (value) {
                    _editedProduct = Product(
                      id: _editedProduct.id,
                      name: _editedProduct.name,
                      description: _editedProduct.description,
                      unitPrice: _editedProduct.unitPrice,
                      imageUrl: _editedProduct.imageUrl,
                      category: value!,
                    );
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a category';
                    }

                    if (value.length > 1) {
                      return 'Category must be a single character';
                    }
                    return null;
                  },
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    SizedBox(
                      width: 100,
                      height: 100,
                      child: FittedBox(
                        child: _imageUrlController.text.isEmpty
                            ? const Text('Enter a URL')
                            : Image.network(_imageUrlController.text),
                      ),
                    ),
                    Expanded(
                      child: TextFormField(
                        decoration: const InputDecoration(labelText: 'Image URL'),
                        focusNode: _imageFocusNode,
                        keyboardType: TextInputType.url,
                        textInputAction: TextInputAction.done,
                        controller: _imageUrlController,
                        onEditingComplete: () {
                          setState(() {});
                        },
                        onSaved: (value) {
                          _editedProduct = Product(
                            id: _editedProduct.id,
                            name: _editedProduct.name,
                            description: _editedProduct.description,
                            unitPrice: _editedProduct.unitPrice,
                            imageUrl: value!,
                            category: _editedProduct.category,
                          );
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter an image URL';
                          }
                          if (!value.startsWith('http') &&
                              !value.startsWith('https')) {
                            return 'Please enter a valid URL';
                          }
                          if (!value.endsWith('.png') &&
                              !value.endsWith('.jpg') &&
                              !value.endsWith('.jpeg')) {
                            return 'Please enter a valid image URL';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _saveForm,
                  child: const Text('Save'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _imageFocusNode.removeListener(_updateImageUrl);
    _descriptionFocusNode.dispose();
    _priceFocusNode.dispose();
    _imageFocusNode.dispose();
    _categoryFocusNode.dispose();
    _imageUrlController.dispose();
    _timer.cancel();
    super.dispose();
  }
}