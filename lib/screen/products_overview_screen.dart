import 'package:flutter/material.dart';

import '../model/product.dart';

class ProductsOverviewScreen extends StatelessWidget {
  ProductsOverviewScreen({super.key});

  final List<Product> loadedProduct = [
    Product(
      id: 1,
      name: 'Machine Learning: 4 Books in 1',
      description: 'An Overview for Beginners to Master',
      unitPrice: 35.01,
      imageUrl: 'https://i.postimg.cc/rF9fSZg4/BOOK-PROGRAMMING-1011.jpg',
    ),
    Product(
      id: 2,
      name: 'Beginning Programming All-in-One',
      description: 'Desk Reference For Dummies',
      unitPrice: 32.89,
      imageUrl: 'https://i.postimg.cc/vBLVpk4L/BOOK-PROGRAMMING-1010.jpg',
    ),
    Product(
      id: 3,
      name: 'Head First Design Patterns',
      description: 'Building Extensible and Maintainable OOP',
      unitPrice: 32.43,
      imageUrl: 'https://i.postimg.cc/4NF9kzxM/BOOK-PROGRAMMING-1009.jpg',
    ),
    Product(
      id: 4,
      name: 'Effective C',
      description: 'An Introduction to Professional C Programming',
      unitPrice: 35.01,
      imageUrl: 'https://i.postimg.cc/sXyB9mTB/BOOK-PROGRAMMING-1008.jpg',
    ),
    Product(
      id: 5,
      name: 'Computer Programming: The Bible',
      description: 'Learn from the basics to advanced',
      unitPrice: 14.95,
      imageUrl: 'https://i.postimg.cc/4NMmFs8R/BOOK-PROGRAMMING-1007.jpg',
    ),
    Product(
      id: 6,
      name: 'The Self-Taught Programmer',
      description: 'The Definitive Guide to Programming',
      unitPrice: 21.87,
      imageUrl: 'https://i.postimg.cc/Dwk7XZj0/BOOK-PROGRAMMING-1006.jpg',
    ),
    Product(
      id: 7,
      name: 'Python Programming for Beginners',
      description: 'The Ultimate Guide for Beginners',
      unitPrice: 21.99,
      imageUrl: 'https://i.postimg.cc/wBFzZk6R/BOOK-PROGRAMMING-1005.jpg',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('My Shop'),
        ),
        body: GridView.builder(
          itemCount: loadedProduct.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 2 / 3,
            crossAxisSpacing: 10,
          ),
          itemBuilder: (ctx, index) => GridTile(
            child: Image.network(loadedProduct[index].imageUrl, fit: BoxFit.cover),
          )
        )
    );
  }
}
