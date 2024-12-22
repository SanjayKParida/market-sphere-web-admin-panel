import 'package:flutter/material.dart';

class ProductScreen extends StatelessWidget {
  static const String id = "\product-screen";

  const ProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text("Product Screen"),
      ),
    );
  }
}
