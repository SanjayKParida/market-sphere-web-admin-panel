import 'dart:convert';

import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter/material.dart';
import 'package:market_sphere_admin_panel/core/constants/constants.dart';
import 'package:market_sphere_admin_panel/models/category_model.dart';
import 'package:http/http.dart' as http;
import 'package:market_sphere_admin_panel/services/api_service.dart';
import 'package:market_sphere_admin_panel/services/snackbar_service.dart';

class CategoryController {
  uploadCategory(
      {required dynamic pickedImage,
      required dynamic pickedBanner,
      required String name,
      required BuildContext context}) async {
    try {
      final cloudinary =
          CloudinaryPublic("dclpagbgi", "market_sphere_cloudinary");
      //UPLOAD CATEGORY IMAGE
      CloudinaryResponse categoryImageResponse = await cloudinary.uploadFile(
        CloudinaryFile.fromBytesData(pickedImage,
            identifier: 'pickedCategoryImage', folder: 'categoryImages'),
      );
      String categoryImageUrl = categoryImageResponse.secureUrl;

      //UPLOAD  BANNER IMAGE
      CloudinaryResponse bannerImageResponse = await cloudinary.uploadFile(
          CloudinaryFile.fromBytesData(pickedBanner,
              identifier: 'bannerImage', folder: 'bannerImages'));
      String bannerImageUrl = bannerImageResponse.secureUrl;

      CategoryModel category = CategoryModel(
        id: "",
        name: name,
        image: categoryImageUrl,
        banner: bannerImageUrl,
      );

      http.Response response = await http.post(Uri.parse("$URI/api/categories"),
          body: category.toJson(),
          headers: <String, String>{
            "Content-Type": "application/json; charset=UTF-8"
          });

      manageHttpResponse(
          response: response,
          context: context,
          onSuccess: () {
            showSnackbar(context, "Category Uploaded Successfully");
          });
    } catch (e) {
      debugPrint("Error uploading: $e");
    }
  }

  //LOAD THE UPLOADED CATEGORY
  Future<List<CategoryModel>> loadCategories() async {
    try {
      http.Response response = await http.get(Uri.parse('$URI/api/categories'));
      print(response.body);
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        List<CategoryModel> categoryList = data
            .map(
              (category) => CategoryModel.fromJson(category),
            )
            .toList();
        return categoryList;
      } else {
        throw Exception("Failed to load Categories");
      }
    } catch (e) {
      throw Exception('Error : $e');
    }
  }
}
