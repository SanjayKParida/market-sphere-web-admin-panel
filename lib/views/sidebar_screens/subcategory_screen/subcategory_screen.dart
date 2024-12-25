import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:market_sphere_admin_panel/controllers/category_controller.dart';
import 'package:market_sphere_admin_panel/controllers/subcategory_controller.dart';
import 'package:market_sphere_admin_panel/views/sidebar_screens/subcategory_screen/widgets/subcategory_widget.dart';

import '../../../models/category_model.dart';

class SubcategoryScreen extends StatefulWidget {
  static const String id = 'subcategory-screen';
  const SubcategoryScreen({super.key});

  @override
  State<SubcategoryScreen> createState() => _SubcategoryScreenState();
}

class _SubcategoryScreenState extends State<SubcategoryScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final SubcategoryController _subcategoryController = SubcategoryController();
  late String subCategoryName;
  late Future<List<CategoryModel>> futureCategories;
  CategoryModel? selectedCategory;
  dynamic _subCategoryImage;

  @override
  void initState() {
    super.initState();
    futureCategories = CategoryController().loadCategories();
  }

  pickCategoryImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );
    if (result != null) {
      setState(() {
        _subCategoryImage = result.files.first.bytes;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              alignment: Alignment.topLeft,
              child: const Text(
                "Sub-Categories",
                style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(4.0),
            child: Divider(
              color: Colors.grey,
            ),
          ),
          FutureBuilder(
              future: futureCategories,
              builder: (context, snapshots) {
                if (snapshots.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshots.hasError) {
                  return Center(
                    child: Text('Error: ${snapshots.error}'),
                  );
                } else if (!snapshots.hasData || snapshots.data!.isEmpty) {
                  return const Center(
                    child: Text("No Categories found!"),
                  );
                } else {
                  return DropdownButton<CategoryModel>(
                    value: selectedCategory,
                    hint: const Text("Select Category"),
                    items: snapshots.data!.map((CategoryModel category) {
                      return DropdownMenuItem(
                        value: category,
                        child: Text(category.name),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedCategory = value;
                      });
                    },
                  );
                }
              }),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //SUBCATEGORY IMAGE SELECTION
              Column(
                spacing: 10,
                children: [
                  Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(10)),
                    child: Center(
                      child: _subCategoryImage != null
                          ? Image.memory(_subCategoryImage)
                          : const Text("Subcategory Image"),
                    ),
                  ),
                  ElevatedButton(
                      onPressed: () {
                        pickCategoryImage();
                      },
                      style: TextButton.styleFrom(backgroundColor: Colors.blue),
                      child: const Text(
                        "Pick Image",
                        style: TextStyle(color: Colors.white),
                      ))
                ],
              ),
              const SizedBox(
                width: 10,
              ),

              //FORM FIELDS AND BUTTONS
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: SizedBox(
                  width: 200,
                  child: TextFormField(
                    onChanged: (input) {
                      subCategoryName = input;
                    },
                    validator: (value) {
                      if (value!.isNotEmpty) {
                        return null;
                      } else {
                        return 'enter sub-category name';
                      }
                    },
                    decoration: const InputDecoration(
                        labelText: "Enter Sub-Category Name"),
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  _formKey.currentState!.reset();
                  _subCategoryImage = null;
                },
                style: TextButton.styleFrom(backgroundColor: Colors.blue),
                child:
                    const Text("Clear", style: TextStyle(color: Colors.white)),
              ),
              const SizedBox(
                width: 10,
              ),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    await _subcategoryController.uploadSubcategory(
                      categoryId: selectedCategory!.id,
                      categoryName: selectedCategory!.name,
                      pickedImage: _subCategoryImage,
                      subCategoryName: subCategoryName,
                      context: context,
                    );
                  }
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                child: const Text(
                  "Save",
                  style: TextStyle(color: Colors.white),
                ),
              )
            ],
          ),
          const Divider(
            color: Colors.grey,
          ),
          const SubcategoryWidget()
        ],
      ),
    );
  }
}
