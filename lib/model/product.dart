import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_app/model/http_exception.dart';

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

  Future<void> toggleFavoriteStatus(String token) async {
    final url = Uri.parse('http://10.0.2.2:8080/api/favorite');
    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Accept': '*/*',
      'Authorization': 'Bearer $token',
    };

    final response = await http.post(url,
        headers: headers,
        body: json.encode({'productId': id, 'favorite': !isFavourite}));

    if (response.statusCode == 200) {
      isFavourite = !isFavourite;
    } else {
      throw HttpException('Failed to toggle favorite status');
    }

    notifyListeners();
  }
}
