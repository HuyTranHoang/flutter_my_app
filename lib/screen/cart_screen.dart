import 'package:flutter/material.dart';
import '../model/cart.dart';
import 'package:provider/provider.dart';

import '../widget/cart_item_widget.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart';

  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<Cart>();
    return Scaffold(
      appBar: AppBar(title: const Text('Your Cart'),),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.all(15),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                children: [
                  const Text('Total', style: TextStyle(fontSize: 20),),
                  const Spacer(),
                  Chip(
                    label: Text('\$ ${cart.totalAmount.toStringAsFixed(2)}'),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  const SizedBox(width: 10,),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      'ORDER NOW',
                      style: TextStyle(color: Theme.of(context).primaryColor),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10,),
          Expanded(
              child: ListView.builder(
                  itemCount: cart.itemCount,
                  itemBuilder: (ctx, idx) => CartItemWidget(
                    keyCartItem: cart.items.keys.toList()[idx],
                    productId: cart.items.values.toList()[idx].productId,
                    unitPrice: cart.items.values.toList()[idx].unitPrice,
                    quantity: cart.items.values.toList()[idx].quantity,
                    name: cart.items.values.toList()[idx].name,
                  )
              )
          ),
        ],
      ),
    );
  }

}