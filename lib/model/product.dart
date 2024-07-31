import 'package:flutter/material.dart';

class Product with ChangeNotifier {
  int id;
  String name;
  String description;
  double unitPrice;
  String imageUrl;
  bool isFavourite;

  Product(
      {required this.id,
      required this.name,
      required this.description,
      required this.unitPrice,
      required this.imageUrl,
      this.isFavourite = false});

  void toggleFavoriteStatus() {
    isFavourite = !isFavourite;
    notifyListeners();
  }
}

