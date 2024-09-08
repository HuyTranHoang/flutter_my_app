
import 'package:flutter/material.dart';
import 'package:my_app/provider/auth_provider.dart';
import 'package:my_app/screen/admin_product_screen.dart';
import 'package:my_app/screen/order_screen.dart';
import 'package:provider/provider.dart';

class NavbarDrawer extends StatelessWidget {
  const NavbarDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: const Text('Menu'),
            automaticallyImplyLeading: false,
          ),
          ListTile(
            leading: const Icon(Icons.payment_outlined),
            title: const Text('Orders'),
            onTap: () => Navigator.of(context).pushReplacementNamed(OrderScreen.routeName),
          ),
          ListTile(
            leading: const Icon(Icons.shop),
            title: const Text('Shop'),
            onTap: () => Navigator.of(context).pushReplacementNamed('/'),
          ),
          ListTile(
            leading: const Icon(Icons.edit),
            title: const Text('Manage Product'),
            onTap: () => Navigator.of(context).pushReplacementNamed(AdminProductScreen.routeName),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text('Logout'),
            onTap: () {
              Navigator.of(context).pop();
              context.read<AuthProvider>().logout();
            },
          ),
        ],
      ),
    );
  }


}