
import 'package:flutter/material.dart';

import '../widget/navbar_drawer.dart';


class OrderScreen extends StatelessWidget {
  static const routeName = '/orders';

  const OrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Orders'),
      ),
      drawer: const NavbarDrawer(),
    );
  }

}