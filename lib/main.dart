import 'package:flutter/material.dart';
import 'package:my_app/model/cart.dart';
import 'package:my_app/model/order.dart';
import 'package:my_app/provider/auth_provider.dart';
import 'package:my_app/provider/product_provider.dart';
import 'package:my_app/screen/admin_product_edit_screen.dart';
import 'package:my_app/screen/admin_product_screen.dart';
import 'package:my_app/screen/auth_screen.dart';
import 'package:my_app/screen/cart_screen.dart';
import 'package:my_app/screen/order_screen.dart';
import 'package:my_app/screen/product_detail_screen.dart';
import 'package:my_app/screen/products_overview_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProvider(create: (context) => ProductProvider()),
        ChangeNotifierProvider(create: (context) => Cart()),
        ChangeNotifierProxyProvider<AuthProvider, Orders>(
          create: (ctx) =>
              Orders(Provider.of<AuthProvider>(ctx, listen: false).token, []),
          update: (ctx, auth, previous) =>
              Orders(auth.token, previous?.orders ?? []),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, auth, _) => MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          fontFamily: 'Roboto',
          colorScheme: ColorScheme.fromSwatch(
            primarySwatch: Colors.blue,
            accentColor: Colors.deepOrangeAccent,
          ),
        ),
        home: auth.isAuth
            ? const ProductsOverviewScreen()
            : FutureBuilder(
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else {
                    return const AuthScreen();
                  }
                },
                future: auth.tryAutoLogin(),
              ),
        routes: {
          ProductsOverviewScreen.routeName: (ctx) =>
              const ProductsOverviewScreen(),
          ProductDetailScreen.routeName: (ctx) => const ProductDetailScreen(),
          CartScreen.routeName: (ctx) => const CartScreen(),
          OrderScreen.routeName: (ctx) => const OrderScreen(),
          AdminProductScreen.routeName: (ctx) => const AdminProductScreen(),
          AdminProductEditScreen.routeName: (ctx) =>
              const AdminProductEditScreen(),
        },
      ),
    );
  }
}
