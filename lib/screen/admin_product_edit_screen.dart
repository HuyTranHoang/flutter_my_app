import 'dart:math';

import 'package:flutter/material.dart';
import 'package:my_app/model/product.dart';

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
  final _imageUrlController = TextEditingController();

  final _form = GlobalKey<FormState>();

  Product _editedProduct =
      Product(id: 0, name: '', description: '', unitPrice: 0, imageUrl: '');

  void _saveForm() {
    _form.currentState!.save();

    print(_editedProduct.name);
    print(_editedProduct.unitPrice);
    print(_editedProduct.description);
    print(_editedProduct.imageUrl);
  }

  _updateImageUrl() {
    if (!_imageFocusNode.hasFocus) {
      setState(() {});
    }
  }

  @override
  void initState() {
    _imageUrlController.addListener(_updateImageUrl);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
      body: Form(
        key: _form,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Name'),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_priceFocusNode);
                },
                onSaved: (value) {
                  _editedProduct = Product(
                    id: 0,
                    name: value!,
                    description: _editedProduct.description,
                    unitPrice: _editedProduct.unitPrice,
                    imageUrl: _editedProduct.imageUrl,
                  );
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Price'),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                focusNode: _priceFocusNode,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_descriptionFocusNode);
                },
                onSaved: (value) {
                  _editedProduct = Product(
                    id: 0,
                    name: _editedProduct.name,
                    description: _editedProduct.description,
                    unitPrice: double.parse(value!),
                    imageUrl: _editedProduct.imageUrl,
                  );
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Description'),
                maxLines: 3,
                focusNode: _descriptionFocusNode,
                textInputAction: TextInputAction.next,
                onSaved: (value) {
                  _editedProduct = Product(
                    id: 0,
                    name: _editedProduct.name,
                    description: value!,
                    unitPrice: _editedProduct.unitPrice,
                    imageUrl: _editedProduct.imageUrl,
                  );
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
                        id: 0,
                        name: _editedProduct.name,
                        description: _editedProduct.description,
                        unitPrice: _editedProduct.unitPrice,
                        imageUrl: value!,
                      );
                    },
                  ))
                ],
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {},
                child: const Text('Save'),
              ),
            ],
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
    _imageUrlController.dispose();
    super.dispose();
  }
}
