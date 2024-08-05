import 'package:flutter/material.dart';
import 'package:my_app/model/cart.dart';

class Order {
  final String orderTrackingNumber;
  final double totalPrice;
  final List<CartItem> cartItems;
  final DateTime orderDate;

  Order({
    required this.orderTrackingNumber,
    required this.totalPrice,
    required this.cartItems,
    required this.orderDate,
  });

  String get formattedDate {
    return '${orderDate.day}/${orderDate.month}/${orderDate.year}';
  }

}

class Orders with ChangeNotifier {
  final List<Order> _orders = [];

  List<Order> get orders {
    return [..._orders];
  }

  void addOrder(List<CartItem> cartItems, double total) {
    _orders.insert(
      0,
      Order(
        orderTrackingNumber: DateTime.now().microsecondsSinceEpoch.toString(),
        totalPrice: total,
        cartItems: cartItems,
        orderDate: DateTime.now(),
      ),
    );
    notifyListeners();
  }
}