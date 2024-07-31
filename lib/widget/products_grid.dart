import 'package:flutter/material.dart';
import 'package:my_app/widget/products_item.dart';
import 'package:provider/provider.dart';

import '../provider/product_provider.dart';


class ProductsGrid extends StatelessWidget {
  const ProductsGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final productsData = context.watch<ProductProvider>();
    final products = productsData.items;

    return GridView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: products.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 2/3,
          crossAxisSpacing: 15,
          mainAxisSpacing: 15,
        ),
        itemBuilder: (ctx, idx) =>
            ChangeNotifierProvider.value(
              value: products[idx],
              child: const ProductsItem(),
            )

    );
  }

}