import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/cart.dart';

class CartItemWidget extends StatelessWidget {
  final int keyCartItem;
  final int productId;
  final double unitPrice;
  final int quantity;
  final String name;

  const CartItemWidget({
    required this.keyCartItem,
    required this.productId,
    required this.unitPrice,
    required this.quantity,
    required this.name,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(productId),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) {
        return showDialog(context: context, builder: (ctx) => AlertDialog(
          title: const Text('Are you sure?'),
          content: const Text('Do you want to remove the item from the cart?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop(false);
              },
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop(true);
              },
              child: const Text('Yes'),
            ),
          ],
        ));
      },
      background: Container(
        color: Theme.of(context).errorColor,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        child: const Icon(Icons.delete, color: Colors.white, size: 40,),
      ),
      onDismissed: (direction) {
        context.read<Cart>().removeItem(keyCartItem);
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: ListTile(
            leading: CircleAvatar(
              child: FittedBox(
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: Text('$unitPrice'),
                  )
              ),
            ),
            title: Text(name),
            subtitle: Text('Total: \$ ${(unitPrice*quantity).toStringAsFixed(2)}'),
            trailing: Text('x $quantity'),
          ),
        ),
      ),
    );
  }

}