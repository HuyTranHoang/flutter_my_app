import 'package:flutter/material.dart';
import 'package:my_app/widget/order_item_widget.dart';
import 'package:provider/provider.dart';

import '../model/order.dart';
import '../widget/navbar_drawer.dart';

class OrderScreen extends StatelessWidget {
  static const routeName = '/orders';

  const OrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final orders = context.watch<Orders>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Orders'),
      ),
      drawer: const NavbarDrawer(),
      body: ListView.builder(
          itemCount: orders.orders.length,
          itemBuilder: (ctx, idx) =>
              OrderItemWidget(order: orders.orders[idx])),
    );
  }
}
