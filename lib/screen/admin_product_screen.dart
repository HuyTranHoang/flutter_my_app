import 'package:flutter/material.dart';
import 'package:my_app/provider/product_provider.dart';
import 'package:my_app/screen/admin_product_edit_screen.dart';
import 'package:my_app/widget/admin_product_item_widget.dart';
import 'package:my_app/widget/navbar_drawer.dart';
import 'package:provider/provider.dart';

class AdminProductScreen extends StatelessWidget {
  static const routeName = '/admin-product';

  const AdminProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<ProductProvider>(context);

    return Scaffold(
        appBar: AppBar(
          title: const Text('Admin Product'),
          actions: [
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () => Navigator.of(context)
                  .pushNamed(AdminProductEditScreen.routeName),
            ),
          ],
        ),
        drawer: const NavbarDrawer(),
        body: Padding(
          padding: const EdgeInsets.all(8),
          child: ListView.builder(
            itemCount: productsData.items.length,
            itemBuilder: (ctx, i) => AdminProductItemWidget(
              id: productsData.items[i].id,
              title: productsData.items[i].name,
              imageUrl: productsData.items[i].imageUrl,
            ),
          ),
        ));
  }
}
