import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:market_sphere_admin_panel/controllers/banner_controller.dart';

class BannerUploadScreen extends StatefulWidget {
  static const String id = "\banner-upload-screen";

  const BannerUploadScreen({super.key});

  @override
  State<BannerUploadScreen> createState() => _BannerUploadScreenState();
}

class _BannerUploadScreenState extends State<BannerUploadScreen> {
  final BannerController _bannerController = BannerController();
  dynamic _bannerImage;

  pickBannerImage() async {
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(type: FileType.image, allowMultiple: false);
    if (result != null) {
      setState(() {
        _bannerImage = result.files.first.bytes;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              alignment: Alignment.topLeft,
              child: const Text(
                "Banners",
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const Divider(
            color: Colors.grey,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 10,
            children: [
              Column(
                spacing: 10,
                children: [
                  Container(
                      height: 150,
                      width: 150,
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Center(
                        child: _bannerImage != null
                            ? Image.memory(_bannerImage)
                            : const Text("Banner Image"),
                      )),
                  ElevatedButton(
                    onPressed: () {
                      pickBannerImage();
                    },
                    style: TextButton.styleFrom(backgroundColor: Colors.blue),
                    child: const Text(
                      "Pick Image",
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                ],
              ),
              ElevatedButton(
                onPressed: () {
                  _bannerController.uploadBannerImage(
                      pickedImage: _bannerImage, context: context);
                },
                style: TextButton.styleFrom(backgroundColor: Colors.blue),
                child: const Text(
                  "Save",
                  style: TextStyle(color: Colors.white),
                ),
              )
            ],
          ),
          const Divider(
            color: Colors.grey,
          )
        ],
      ),
    );
  }
}
