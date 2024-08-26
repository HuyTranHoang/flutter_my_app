import 'package:flutter/material.dart';
import 'package:my_app/model/cart.dart';
import 'package:my_app/widget/badget.dart';
import 'package:my_app/widget/navbar_drawer.dart';
import 'package:provider/provider.dart';


import '../provider/product_provider.dart';
import '../widget/products_grid.dart';
import 'cart_screen.dart';

enum FilterOptions {
  favorites,
  all,
}

class ProductsOverviewScreen extends StatefulWidget {
  const ProductsOverviewScreen({super.key});

  @override
  State<StatefulWidget> createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {

  bool _showOnlyFavorites = false;
  bool _isInit = true;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      context.watch<ProductProvider>().fetchAndSetProducts()
          .then((value) => null);
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Shop'),
        actions: <Widget>[
          PopupMenuButton(
            icon: const Icon(Icons.more_vert),
            itemBuilder: (_) => [
              const PopupMenuItem(
                  value: FilterOptions.favorites,
                  child: Text('Only favorites')),
              const PopupMenuItem(
                  value: FilterOptions.all, child: Text('Show All')),
            ],
            onSelected: (FilterOptions selectedValue) => {
              setState(() {
                if (selectedValue == FilterOptions.favorites) {
                  _showOnlyFavorites = true;
                } else {
                  _showOnlyFavorites = false;
                }
              }),
            },
          ),
          Consumer<Cart>(
              builder: (context, cartData, _) => Badge(
                  value: cartData.itemCount.toString(),
                  child: IconButton(
                    icon: const Icon(Icons.shopping_cart),
                    onPressed: () =>
                        Navigator.of(context).pushNamed(CartScreen.routeName),
                  )))
        ],
      ),
      drawer: const NavbarDrawer(),
      body: RefreshIndicator(
        onRefresh: () async => await context.watch<ProductProvider>().fetchAndSetProducts(),
        child: ProductsGrid(_showOnlyFavorites),
      ),
    );
  }
}
