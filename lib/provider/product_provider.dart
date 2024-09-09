import 'package:flutter/material.dart';
import 'package:my_app/model/http_exception.dart';
import 'package:my_app/model/product.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ProductProvider with ChangeNotifier {
  final String authToken;

  List<Product> _items = [];

  ProductProvider(this.authToken, this._items);

  List<Product> get items {
    return [..._items];
  }

  Product findById(int id) {
    return _items.firstWhere((element) => element.id == id);
  }

  List<Product> get favoriteItems {
    return _items.where((element) => element.isFavourite).toList();
  }

  Future<void> fetchAndSetProducts() async {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': '*/*',
      'Authorization': 'Bearer $authToken'
    };

    try {
      var url = Uri.parse('http://10.0.2.2:8080/api/favorite');
      final favoriteResponse = await http.get(url, headers: headers);
      if (favoriteResponse.statusCode != 200) {
        throw HttpException('Failed to fetch favorite products');
      }
      Map<String, dynamic> favoriteData = json.decode(favoriteResponse.body);
      Set<String> favoriteIds = Set<String>.from(favoriteData['favorites'] ?? []);

      url = Uri.parse('http://10.0.2.2:8080/api/products');
      final response = await http.get(url, headers: headers);
      if (response.statusCode != 200) {
        throw HttpException('Failed to fetch products');
      }
      final extractedData = json.decode(response.body)['products'] as List<dynamic>;

      final List<Product> loadedProducts = extractedData.map((element) {
        return Product(
          id: element['id'],
          name: element['name'],
          description: element['description'],
          unitPrice: element['unitPrice'].toDouble(),
          imageUrl: element['imageUrl'],
          category: element['category'],
          isFavourite: favoriteIds.contains(element['id']),
        );
      }).toList();

      _items.clear();
      _items.addAll(loadedProducts);
      notifyListeners();
    } catch (error) {
      print('Error fetching products: $error');
      rethrow;
    }
  }

  Future<void> addProduct(Product product) async {
    final url = Uri.parse('http://10.0.2.2:8080/api/products/add');
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': '*/*'
    };
    try {
      final response = await http.post(url,
          headers: headers,
          body: json.encode({
            'name': product.name,
            'description': product.description,
            'unitPrice': product.unitPrice,
            'imageUrl': product.imageUrl,
            'date': DateTime.now().toIso8601String(),
            'category': product.category,
          }));
      final res = json.decode(response.body);
      final newProduct = Product(
        name: res['name'],
        description: res['description'],
        unitPrice: res['unitPrice'],
        imageUrl: res['imageUrl'],
        id: res['id'],
        category: res['category'],
      );
      _items.add(newProduct);
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> updateProduct(Product product) async {
    final url = Uri.parse('http://10.0.2.2:8080/api/products/update');
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': '*/*'
    };
    try {
      final response = await http.post(
        url,
        headers: headers,
        body: json.encode({
          'id': product.id,  // Include the id in the request body
          'name': product.name,
          'description': product.description,
          'unitPrice': product.unitPrice,
          'imageUrl': product.imageUrl,
          'date': DateTime.now().toIso8601String(),
          'category': product.category,
        }),
      );

      if (response.statusCode >= 400) {
        throw HttpException('Failed to update product');
      }

      final res = json.decode(response.body);
      final updatedProduct = Product(
        id: res['id'],
        name: res['name'],
        description: res['description'],
        unitPrice: res['unitPrice'],
        imageUrl: res['imageUrl'],
        category: res['category'],
      );

      final index = _items.indexWhere((element) => element.id == updatedProduct.id);
      if (index >= 0) {
        _items[index] = updatedProduct;
        notifyListeners();
      } else {
        print('Product not found in the list');
      }
    } catch (error) {
      print('Error updating product: $error');
      rethrow;
    }
  }

  Future<void> deleteProduct(int id) async {
    final url = Uri.parse('http://10.0.2.2:8080/api/products/delete/$id');
    try {
      final response = await http.delete(url);
      if (response.statusCode == 204) {
        _items.removeWhere((element) => element.id == id);
        notifyListeners();
      } else {
        throw 'Failed to delete product';
      }
    } catch (error) {
      rethrow;
    }
  }
}
