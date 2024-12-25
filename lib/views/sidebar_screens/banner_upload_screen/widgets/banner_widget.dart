import 'package:flutter/material.dart';

import '../../../../controllers/banner_controller.dart';
import '../../../../models/banner_model.dart';

class BannerWidget extends StatefulWidget {
  const BannerWidget({super.key});

  @override
  State<BannerWidget> createState() => _BannerWidgetState();
}

class _BannerWidgetState extends State<BannerWidget> {
  //FUTURE TO HOLD LIST OF BANNERS ONCE LOADED FROM THE API
  late Future<List<BannerModel>> banners;

  @override
  void initState() {
    super.initState();
    banners = BannerController().loadBanners();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: banners,
      builder: (context, snapshots) {
        if (snapshots.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshots.hasError) {
          return Center(
            child: Text("Error: ${snapshots.error}"),
          );
        } else if (!snapshots.hasData || snapshots.data!.isEmpty) {
          return const Center(
            child: Text("No Banners"),
          );
        } else {
          final data = snapshots.data!;

          return Expanded(
            child: GridView.builder(
              itemCount: data.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 6,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemBuilder: (context, index) {
                final banner = data[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.network(
                    banner.image,
                    height: 100,
                    width: 100,
                  ),
                );
              },
            ),
          );
        }
      },
    );
  }
}
