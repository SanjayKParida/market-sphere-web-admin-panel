import 'dart:convert';

import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter/material.dart';
import 'package:market_sphere_admin_panel/core/constants/constants.dart';
import 'package:market_sphere_admin_panel/models/banner_model.dart';
import 'package:http/http.dart' as http;
import 'package:market_sphere_admin_panel/services/api_service.dart';
import 'package:market_sphere_admin_panel/services/snackbar_service.dart';

class BannerController {
  uploadBannerImage({
    required dynamic pickedImage,
    required BuildContext context,
  }) async {
    try {
      final cloudinary =
          CloudinaryPublic('dclpagbgi', 'market_sphere_cloudinary');
      CloudinaryResponse bannerImageResponse =
          await cloudinary.uploadFile(CloudinaryFile.fromBytesData(
        pickedImage,
        identifier: 'pickedBannerImage',
        folder: 'banners',
      ));

      String image = bannerImageResponse.secureUrl;

      BannerModel banner = BannerModel(
        id: '',
        image: image,
      );

      http.Response response = await http.post(Uri.parse('$URI/api/banner'),
          body: banner.toJson(),
          headers: <String, String>{
            "Content-Type": "application/json; charset=UTF-8"
          });
      manageHttpResponse(
        response: response,
        context: context,
        onSuccess: () {
          showSnackbar(context, 'Banner Uploaded Successfully');
        },
      );
    } catch (e) {
      print('Error : $e');
    }
  }

  Future<List<BannerModel>> loadBanners() async {
    try {
      http.Response response = await http.get(
        Uri.parse('$URI/api/banner'),
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8"
        },
      );
      if (response.statusCode == 200) {
        List<dynamic> bannerData = jsonDecode(response.body);

        List<BannerModel> banners = bannerData
            .map(
              (banner) => BannerModel.fromJson(banner),
            )
            .toList();
        return banners;
      } else {
        throw Exception('Failed to load banners');
      }
    } catch (e) {
      throw Exception('Error : $e');
    }
  }
}
