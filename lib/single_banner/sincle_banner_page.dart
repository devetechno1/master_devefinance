import 'package:active_ecommerce_cms_demo_app/custom/lang_text.dart';
import 'package:active_ecommerce_cms_demo_app/helpers/shimmer_helper.dart';
import 'package:active_ecommerce_cms_demo_app/single_banner/photo_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../single_banner/model.dart';
// Path to your provider file

class PhotoWidget extends StatelessWidget {
  const PhotoWidget(this.slug);
  final String slug;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<SingleBanner>>(
      future: Provider.of<PhotoProvider>(context, listen: false).fetchPhotos(slug),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return ShimmerHelper()
              .buildBasicShimmer(height: 50); // Show shimmer while loading
        }

        if (snapshot.hasError) {
          return Center(
              child: Text(LangText(context).local.error_loading_photos)); // Handle API call errors
        }

        return Consumer<PhotoProvider>(
          builder: (context, photoProvider, child) {
            if (snapshot.data?.isNotEmpty != true) {
              return SizedBox(); // No photos fallback
              // return Center(
              //     child: Text('No photos available.')); // No photos fallback
            }

            final photoData = snapshot.data!.first;

            return GestureDetector(
              onTap: () async {
                final url = photoData.url;
                if (url.isNotEmpty) {
                  final uri = Uri.parse(url);
                  if (await canLaunchUrl(uri)) {
                    await launchUrl(uri);
                  } else {
                    throw 'Could not launch $url';
                  }
                } else {
                  print('URL is empty');
                }
              },
              child: Image.network(photoData.photo),
            );
          },
        );
      },
    );
  }
}
