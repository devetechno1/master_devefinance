import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import '../data_model/slider_response.dart';
import '../helpers/shimmer_helper.dart';
import '../services/navigation_service.dart';
import 'aiz_image.dart';

class HomeBannersList extends StatelessWidget {
  final bool isBannersInitial;
  final List<AIZSlider> bannersImagesList;
  final double aspectRatio;
  final double viewportFraction;

  const HomeBannersList(
      {Key? key,
      required this.isBannersInitial,
      required this.bannersImagesList, 
      this.aspectRatio = 2, 
      this.viewportFraction = 0.5})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // When data is loading and no images are available
    if (isBannersInitial && bannersImagesList.isEmpty) {
      return Padding(
        padding:
            const EdgeInsets.only(left: 18.0, right: 18, top: 10, bottom: 20),
        child: ShimmerHelper().buildBasicShimmer(height: 120),
      );
    }

    // When banner images are available
    else if (bannersImagesList.isNotEmpty) {
      return CarouselSlider(
        options: CarouselOptions(
          aspectRatio: aspectRatio,
          viewportFraction: viewportFraction,
          initialPage: 0,
          // padEnds: false,
          enlargeCenterPage: true,
          enlargeStrategy: CenterPageEnlargeStrategy.height,
          enableInfiniteScroll: true,
          autoPlay: true,
        ),
        items: bannersImagesList.map((i) {
          return Container(
            margin: const EdgeInsetsDirectional.only(start: 12, bottom: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Color(0xff000000).withOpacity(0.1),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: InkWell(
                onTap: () => NavigationService.handleUrls(i.url, context),
                child: AIZImage.radiusImage(i.photo, 6),
              ),
            ),
          );
        }).toList(),
      );
    } else {
      return SizedBox();
    }
  }
}
