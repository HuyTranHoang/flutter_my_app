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
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              SizedBox(
                height: 500,
                width: double.infinity,
                child: Image.network(productDetail.imageUrl, fit: BoxFit.cover),
              ),
              Text(
                '\$${productDetail.unitPrice}',
                style: const TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  productDetail.description,
                  textAlign: TextAlign.center,
                  softWrap: true,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 20,
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
