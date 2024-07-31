import 'dart:developer';

import 'package:flutter/material.dart';

import '../widget/products_grid.dart';

class ProductsOverviewScreen extends StatelessWidget {
  const ProductsOverviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Shop'),
        actions: <Widget>[
          PopupMenuButton(
            icon: const Icon(Icons.more_vert),
            itemBuilder: (_) => [
              const PopupMenuItem(value: 0, child: Text('Only favorites')),
              const PopupMenuItem(value: 1, child: Text('Show All')),
            ],
            onSelected: (int selectedValue) => log('Value $selectedValue'),
          )
        ],
      ),
      body: const ProductsGrid(),
    );
  }

}