import 'package:flutter/material.dart';
import 'package:my_app/provider/product_provider.dart';
import 'package:provider/provider.dart';

class AdminProductScreen extends StatelessWidget {
  static const routeName = '/admin-product';

  const AdminProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<ProductProvider>(context);

    // TODO: implement build
    throw UnimplementedError();
  }


}