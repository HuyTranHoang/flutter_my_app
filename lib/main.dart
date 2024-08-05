import 'package:flutter/material.dart';
import 'package:my_app/model/cart.dart';
import 'package:my_app/provider/product_provider.dart';
import 'package:my_app/screen/product_detail_screen.dart';
import 'package:my_app/screen/products_overview_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (BuildContext context) => ProductProvider()),
        ChangeNotifierProvider(create: (BuildContext context) => Cart()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
            fontFamily: 'Roboto',
            // primarySwatch: Colors.blue,
            colorScheme: ColorScheme.fromSwatch(
              primarySwatch: Colors.blue,
              accentColor: Colors.deepOrangeAccent,
            )
        ),
        home: const ProductsOverviewScreen(),
        routes: {
          ProductDetailScreen.routeName: (ctx) => const ProductDetailScreen()
        },
      ),
    );
  }
}
