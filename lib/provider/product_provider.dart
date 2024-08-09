import 'package:flutter/material.dart';
import 'package:my_app/model/product.dart';


class ProductProvider with ChangeNotifier {
  final List<Product> _items = [
    Product(id: 1, name: 'Machine Learning: 4 Books in 1', description: 'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industrys standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.', unitPrice: 35.01, imageUrl: 'https://picsum.photos/id/1/200/300',),
    Product(id: 2, name: 'Beginning Programming All-in-One', description: 'Desk Reference For Dummies', unitPrice: 32.89, imageUrl: 'https://picsum.photos/id/2/200/300',),
    Product(id: 3, name: 'Head First Design Patterns', description: 'Building Extensible and Maintainable OOP', unitPrice: 32.43, imageUrl: 'https://picsum.photos/id/3/200/300',),
    Product(id: 4, name: 'Effective C', description: 'An Introduction to Professional C Programming', unitPrice: 35.01, imageUrl: 'https://picsum.photos/id/4/200/300',),
    Product(id: 5, name: 'Computer Programming: The Bible', description: 'Learn from the basics to advanced', unitPrice: 14.95, imageUrl: 'https://picsum.photos/id/5/200/300',),
    Product(id: 6, name: 'The Self-Taught Programmer', description: 'The Definitive Guide to Programming', unitPrice: 21.87, imageUrl: 'https://picsum.photos/id/6/200/300',),
    Product(id: 7, name: 'Python Programming for Beginners', description: 'The Ultimate Guide for Beginners', unitPrice: 21.99, imageUrl: 'https://picsum.photos/id/7/200/300',),
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