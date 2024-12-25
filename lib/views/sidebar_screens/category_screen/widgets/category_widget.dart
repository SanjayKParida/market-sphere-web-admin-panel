import 'package:flutter/material.dart';
import 'package:market_sphere_admin_panel/controllers/category_controller.dart';

import '../../../../models/category_model.dart';

class CategoryWidget extends StatefulWidget {
  const CategoryWidget({super.key});

  @override
  State<CategoryWidget> createState() => _CategoryWidgetState();
}

class _CategoryWidgetState extends State<CategoryWidget> {
  //FUTURE THAT WILL HOLD THE CATGORIES ONCE FETCHED FROM THE API
  late Future<List<CategoryModel>> futureCategories;

  @override
  void initState() {
    super.initState();
    futureCategories = CategoryController().loadCategories();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: futureCategories,
      builder: (context, snapshots) {
        if (snapshots.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshots.hasError) {
          return Center(
            child: Text('Error : ${snapshots.error}'),
          );
        } else if (!snapshots.hasData || snapshots.data!.isEmpty) {
          return const Center(
            child: Text("No Catgories"),
          );
        } else {
          final categories = snapshots.data;
          return Expanded(
            child: GridView.builder(
              shrinkWrap: true,
              itemCount: categories!.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 6, mainAxisSpacing: 10, crossAxisSpacing: 10),
              itemBuilder: (context, index) {
                final category = categories[index];
                return Column(
                  spacing: 5,
                  children: [
                    Image.network(
                      category.image,
                      height: 100,
                      width: 100,
                    ),
                    Text(category.name)
                  ],
                );
              },
            ),
          );
        }
      },
    );
  }
}
