import 'package:flutter/material.dart';
import 'package:my_app/provider/product_provider.dart';
import 'package:my_app/screen/admin_product_edit_screen.dart';
import 'package:provider/provider.dart';

class AdminProductItemWidget extends StatelessWidget {
  final int id;
  final String title;
  final String imageUrl;

  const AdminProductItemWidget({
    required this.id,
    required this.title,
    required this.imageUrl,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageUrl),
      ),
      trailing: SizedBox(
        width: 100,
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                Navigator.of(context).pushNamed(AdminProductEditScreen.routeName, arguments: id);
              },
              color: Theme
                  .of(context)
                  .primaryColor,
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () async => await context.read<ProductProvider>().deleteProduct(id),
              color: Theme
                  .of(context)
                  .errorColor,
            ),
          ],
        ),
      ),
    );
  }
}
