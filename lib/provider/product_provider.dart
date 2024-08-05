import 'package:flutter/material.dart';
import 'package:my_app/model/product.dart';


class ProductProvider with ChangeNotifier {
  final List<Product> _items = [
    Product(id: 1, name: 'Machine Learning: 4 Books in 1', description: 'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industrys standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.', unitPrice: 35.01, imageUrl: 'https://i.postimg.cc/rF9fSZg4/BOOK-PROGRAMMING-1011.jpg',),
    Product(id: 2, name: 'Beginning Programming All-in-One', description: 'Desk Reference For Dummies', unitPrice: 32.89, imageUrl: 'https://i.postimg.cc/vBLVpk4L/BOOK-PROGRAMMING-1010.jpg',),
    Product(id: 3, name: 'Head First Design Patterns', description: 'Building Extensible and Maintainable OOP', unitPrice: 32.43, imageUrl: 'https://i.postimg.cc/4NF9kzxM/BOOK-PROGRAMMING-1009.jpg',),
    Product(id: 4, name: 'Effective C', description: 'An Introduction to Professional C Programming', unitPrice: 35.01, imageUrl: 'https://i.postimg.cc/sXyB9mTB/BOOK-PROGRAMMING-1008.jpg',),
    Product(id: 5, name: 'Computer Programming: The Bible', description: 'Learn from the basics to advanced', unitPrice: 14.95, imageUrl: 'https://i.postimg.cc/4NMmFs8R/BOOK-PROGRAMMING-1007.jpg',),
    Product(id: 6, name: 'The Self-Taught Programmer', description: 'The Definitive Guide to Programming', unitPrice: 21.87, imageUrl: 'https://i.postimg.cc/Dwk7XZj0/BOOK-PROGRAMMING-1006.jpg',),
    Product(id: 7, name: 'Python Programming for Beginners', description: 'The Ultimate Guide for Beginners', unitPrice: 21.99, imageUrl: 'https://i.postimg.cc/wBFzZk6R/BOOK-PROGRAMMING-1005.jpg',),
  ];

  List<Product> get items {
    return [..._items];
  }

  Product findById(int id) {
    return _items.firstWhere((element) => element.id == id);
  }

  List<Product> get favoriteItems {
    return _items.where((element) => element.isFavourite).toList();
  }
}