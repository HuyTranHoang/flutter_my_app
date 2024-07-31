import 'package:flutter/material.dart';

import '../provider/product_provider.dart';
import 'package:provider/provider.dart';

class ProductDetailScreen extends StatelessWidget {
  static const routeName = '/product-detail';

  const ProductDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context)?.settings.arguments as int;
    final productDetail = context.read<ProductProvider>().findById(productId);

    return Scaffold(
        appBar: AppBar(
          title: Text(productDetail.name),
        )
    );
  }

}