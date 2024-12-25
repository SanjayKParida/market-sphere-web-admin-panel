import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';
import 'package:market_sphere_admin_panel/views/sidebar_screens/banner_upload_screen/banner_upload_screen.dart';
import 'package:market_sphere_admin_panel/views/sidebar_screens/buyer_screen/buyer_screen.dart';
import 'package:market_sphere_admin_panel/views/sidebar_screens/category_screen/category_screen.dart';
import 'package:market_sphere_admin_panel/views/sidebar_screens/order_screen/order_screen.dart';
import 'package:market_sphere_admin_panel/views/sidebar_screens/products_screen.dart/product_screen.dart';
import 'package:market_sphere_admin_panel/views/sidebar_screens/subcategory_screen/subcategory_screen.dart';
import 'package:market_sphere_admin_panel/views/sidebar_screens/vendor_screen/vendor_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  Widget _selectedScreen = const VendorScreen();

  screenSelector(item) {
    switch (item.route) {
      case VendorScreen.id:
        setState(() {
          _selectedScreen = const VendorScreen();
        });
        break;
      case BuyerScreen.id:
        setState(() {
          _selectedScreen = const BuyerScreen();
        });
        break;
      case OrderScreen.id:
        setState(() {
          _selectedScreen = const OrderScreen();
        });
        break;
      case CategoryScreen.id:
        setState(() {
          _selectedScreen = const CategoryScreen();
        });
        break;
      case SubcategoryScreen.id:
        setState(() {
          _selectedScreen = const SubcategoryScreen();
        });
        break;
      case BannerUploadScreen.id:
        setState(() {
          _selectedScreen = const BannerUploadScreen();
        });
        break;
      case ProductScreen.id:
        setState(() {
          _selectedScreen = const ProductScreen();
        });
        break;
      default:
    }
  }

  @override
  Widget build(BuildContext context) {
    return AdminScaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade100,
        centerTitle: true,
        title: const Text(
          "MARKET SPHERE",
          style: TextStyle(letterSpacing: 1.2, fontWeight: FontWeight.bold),
        ),
      ),
      body: _selectedScreen,
      sideBar: SideBar(
        header: Container(
          height: 50,
          width: double.infinity,
          decoration: BoxDecoration(color: Colors.blue.shade100),
          child: const Center(
            child: Text(
              "MANAGEMENT",
              style: TextStyle(letterSpacing: 1.2, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        items: const [
          AdminMenuItem(
            title: "Vendors",
            route: VendorScreen.id,
            icon: Icons.person_pin_outlined,
          ),
          AdminMenuItem(
            title: "Buyers",
            route: BuyerScreen.id,
            icon: Icons.person_pin,
          ),
          AdminMenuItem(
            title: "Orders",
            route: OrderScreen.id,
            icon: Icons.shopping_bag,
          ),
          AdminMenuItem(
            title: "Categories",
            route: CategoryScreen.id,
            icon: Icons.category_rounded,
          ),
          AdminMenuItem(
            title: "Sub-Categories",
            route: SubcategoryScreen.id,
            icon: Icons.group_work_outlined,
          ),
          AdminMenuItem(
            title: "Upload Banners",
            route: BannerUploadScreen.id,
            icon: Icons.add,
          ),
          AdminMenuItem(
            title: "Products",
            route: ProductScreen.id,
            icon: Icons.shopping_cart_outlined,
          ),
        ],
        selectedRoute: VendorScreen.id,
        onSelected: (item) {
          screenSelector(item);
        },
      ),
    );
  }
}
