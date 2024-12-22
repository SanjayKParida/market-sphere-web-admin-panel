import 'package:flutter/material.dart';

class VendorScreen extends StatelessWidget {
  static const String id = "\vendor-screen";

  const VendorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text("Vendor Screen"),
      ),
    );
  }
}
