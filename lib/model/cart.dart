import 'package:flutter/foundation.dart';

class CartItem {
  final String productId;
  final String name;
  final double unitPrice;
  final int quantity;

  CartItem({
    required this.productId,
    required this.name,
    required this.unitPrice,
    required this.quantity,
  });
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  int get itemCount {
    return _items.length;
  }

  double get totalAmount {
    var total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.unitPrice * cartItem.quantity;
    });
    return total;
  }

  void addItem(
      String productId,
      String name,
      double price,
      ) {
    if (_items.containsKey(productId)) {
      _items.update(
        productId,
            (existingCartItem) => CartItem(
          productId: existingCartItem.productId,
          name: existingCartItem.name,
          unitPrice: existingCartItem.unitPrice,
          quantity: existingCartItem.quantity + 1,
        ),
      );
    } else {
      _items.putIfAbsent(
        productId,
            () => CartItem(
          productId: productId,
          name: name,
          unitPrice: price,
          quantity: 1,
        ),
      );
    }
    notifyListeners();
  }

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void removeSingleItem(String productId) {
    if (!_items.containsKey(productId)) {
      return;
    }
    if (_items[productId]!.quantity > 1) {
      _items.update(
        productId,
            (existingCartItem) => CartItem(
          productId: existingCartItem.productId,
          name: existingCartItem.name,
          unitPrice: existingCartItem.unitPrice,
          quantity: existingCartItem.quantity - 1,
        ),
      );
    } else {
      _items.remove(productId);
    }
    notifyListeners();
  }

  void clear() {
    _items = {};
    notifyListeners();
  }
}