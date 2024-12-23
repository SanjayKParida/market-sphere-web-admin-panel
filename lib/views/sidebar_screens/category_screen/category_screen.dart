import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:market_sphere_admin_panel/controllers/category_controller.dart';

class CategoryScreen extends StatefulWidget {
  static const String id = "\category-screen";

  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late String categoryName;
  final CategoryController _categoryController = CategoryController();
  dynamic _categoryImage;
  dynamic _bannerImage;

  pickCategoryImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );
    if (result != null) {
      setState(() {
        _categoryImage = result.files.first.bytes;
      });
    }
  }

  pickBannerImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );
    if (result != null) {
      setState(() {
        _bannerImage = result.files.first.bytes;
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
                "Categories",
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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //CATEGORY IMAGE SELECTION
              Column(
                spacing:10,
                children: [
                  Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(10)),
                    child: Center(
                      child: _categoryImage != null
                          ? Image.memory(_categoryImage)
                          : const Text("Category Image"),
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
              //BANNER IMAGE SELECTION
              Column(
                children: [
                  Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(10)),
                    child: Center(
                      child: _bannerImage != null
                          ? Image.memory(_bannerImage)
                          : const Text("Banner Image"),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        pickBannerImage();
                      },
                      style: TextButton.styleFrom(backgroundColor: Colors.blue),
                      child: const Text(
                        "Pick Image",
                        style: TextStyle(color: Colors.white),
                      ))
                ],
              ),
              //FORM FIELDS AND BUTTONS
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: SizedBox(
                  width: 200,
                  child: TextFormField(
                    onChanged: (input) {
                      categoryName = input;
                    },
                    validator: (value) {
                      if (value!.isNotEmpty) {
                        return null;
                      } else {
                        return 'Please enter category name';
                      }
                    },
                    decoration:
                        const InputDecoration(labelText: "Enter Category Name"),
                  ),
                ),
              ),
              TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(backgroundColor: Colors.blue),
                child:
                    const Text("Cancel", style: TextStyle(color: Colors.white)),
              ),
              const SizedBox(
                width: 10,
              ),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    await _categoryController.uploadCategory(
                        name: categoryName,
                        pickedImage: _categoryImage,
                        context: context,
                        pickedBanner: _bannerImage);
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
          const Padding(
            padding: EdgeInsets.all(4.0),
            child: Divider(
              color: Colors.grey,
            ),
          )
        ],
      ),
    );
  }
}
