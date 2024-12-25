import 'dart:convert';

import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:market_sphere_admin_panel/services/api_service.dart';
import 'package:market_sphere_admin_panel/services/snackbar_service.dart';
import '../core/constants/constants.dart';
import '../models/subCategory_model.dart';

class SubcategoryController {
  uploadSubcategory(
      {required String categoryId,
      required String categoryName,
      required dynamic pickedImage,
      required String subCategoryName,
      required BuildContext context}) async {
    try {
      final cloudinary = CloudinaryPublic(
        "dclpagbgi",
        "market_sphere_cloudinary",
      );
      //UPLOAD CATEGORY IMAGE
      CloudinaryResponse subCategoryImageResponse = await cloudinary.uploadFile(
        CloudinaryFile.fromBytesData(
          pickedImage,
          identifier: 'pickedSubCategoryImage',
          folder: 'subCategoryImages',
        ),
      );
      String subCategoryImageUrl = subCategoryImageResponse.secureUrl;

      //CREATING INSTANCE OF SUBCATEGORY
      SubcategoryModel subcategory = SubcategoryModel(
        id: '',
        categoryId: categoryId,
        categoryName: categoryName,
        image: subCategoryImageUrl,
        subCategoryName: subCategoryName,
      );

      //INITIALIZING POST REQUEST
      http.Response response = await http.post(
        Uri.parse('$URI/api/subcategories'),
        body: subcategory.toJson(),
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
        },
      );

      manageHttpResponse(
        response: response,
        context: context,
        onSuccess: () {
          showSnackbar(context, 'Subcategory Uploaded!!');
        },
      );
    } catch (e) {
      print(e);
    }
  }

  Future<List<SubcategoryModel>> loadSubcategories() async {
    try {
      http.Response response = await http.get(
        Uri.parse('$URI/api/subcategories'),
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        List<SubcategoryModel> subCategoryList = data
            .map(
              (subCategory) => SubcategoryModel.fromJson(subCategory),
            )
            .toList();
        return subCategoryList;
      } else {
        throw Exception("Failed to load Sub-Categories");
      }
    } catch (e) {
      throw Exception("Error : $e");
    }
  }

  loadDynamicSubcategory({required String categoryName}) async {
    try {
      http.Response response = await http.get(
        Uri.parse(
          '$URI/api/categories/$categoryName/subcategories',
        ),
      );
      print(response.body);
      if (response.statusCode == 200) {}
    } catch (e) {}
  }
}
