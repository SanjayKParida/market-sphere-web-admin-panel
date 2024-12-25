import 'package:flutter/material.dart';
import 'package:market_sphere_admin_panel/controllers/category_controller.dart';
import 'package:market_sphere_admin_panel/models/subCategory_model.dart';

import '../../../../controllers/subcategory_controller.dart';

class SubcategoryWidget extends StatefulWidget {
  const SubcategoryWidget({super.key});

  @override
  State<SubcategoryWidget> createState() => _SubcategoryWidgetState();
}

class _SubcategoryWidgetState extends State<SubcategoryWidget> {
  //FUTURE THAT WILL HOLD THE CATGORIES ONCE FETCHED FROM THE API
  late Future<List<SubcategoryModel>> futureSubcategories;

  @override
  void initState() {
    super.initState();
    futureSubcategories = SubcategoryController().loadSubcategories();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: futureSubcategories,
      builder: (context, snapshots) {
        if (snapshots.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshots.hasError) {
          return Center(
            child: Text('Error : ${snapshots.error}'),
          );
        } else if (!snapshots.hasData || snapshots.data!.isEmpty) {
          return const Center(
            child: Text("No Subcatgories"),
          );
        } else {
          final subcategories = snapshots.data;
          return Expanded(
            child: GridView.builder(
              shrinkWrap: true,
              itemCount: subcategories!.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 6, mainAxisSpacing: 10, crossAxisSpacing: 10),
              itemBuilder: (context, index) {
                final subcategory = subcategories[index];
                return Column(
                  spacing: 5,
                  children: [
                    Image.network(
                      subcategory.image,
                      height: 100,
                      width: 100,
                    ),
                    Text(subcategory.subCategoryName)
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
