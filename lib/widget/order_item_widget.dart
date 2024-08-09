import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_app/model/order.dart';

class OrderItemWidget extends StatefulWidget {
  final Order order;

  const OrderItemWidget({
    required this.order,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _OrderItemWidgetState();
}

class _OrderItemWidgetState extends State<OrderItemWidget> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
        child: Column(
      children: [
        ListTile(
          title: Text('Total: \$${widget.order.totalPrice}'),
          subtitle:
              Text(DateFormat.yMMMMEEEEd().format(widget.order.orderDate)),
          trailing: IconButton(
              onPressed: () => setState(() {
                    _expanded = !_expanded;
                  }),
              icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more)),
        ),
        if (_expanded)
          SizedBox(
              height: 80 * widget.order.cartItems.length.toDouble(),
              child: Material(
                elevation: 4.0,
                borderRadius: BorderRadius.circular(5.0),
                color: Colors.lightBlue,
                child: ListView(
                  children: widget.order.cartItems
                      .map((item) => ListTile(
                            title: Text(item.name,
                                style: const TextStyle(color: Colors.white)),
                            subtitle: Text(
                                '${item.quantity} x \$${item.unitPrice}',
                                style: const TextStyle(color: Colors.white)),
                          ))
                      .toList(),
                ),
              )),
      ],
    ));
  }
}
