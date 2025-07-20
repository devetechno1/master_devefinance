import 'package:active_ecommerce_cms_demo_app/constants/app_dimensions.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import '../../data_model/slider_response.dart';
import '../../services/navigation_service.dart';
import '../aiz_image.dart';
import '../dynamic_size_image_banner.dart';

class HomeBannersListAnimation extends StatelessWidget {
  final bool isBannersInitial;
  final List<AIZSlider> bannersImagesList;
  final double aspectRatio;
  final double viewportFraction;

  const HomeBannersListAnimation({
    Key? key,
    required this.isBannersInitial,
    required this.bannersImagesList,
    this.aspectRatio = 2,
    this.viewportFraction = 0.49,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // When data is loading and no images are available
    if (isBannersInitial && bannersImagesList.isEmpty) {
      return const LoadingImageBannerWidget();
    }

    // When banner images are available
    else if (bannersImagesList.isNotEmpty) {
      if (bannersImagesList.length == 1) {
        return DynamicSizeImageBanner(
          urlToOpen: bannersImagesList.first.url,
          photo: bannersImagesList.first.photo,
        );
      }
      final bool canScroll = bannersImagesList.length > 2;

     return Center(
  child: CarouselSlider.builder(
    itemCount: bannersImagesList.length,
    itemBuilder: (context, index, realIdx) {
      return AnimatedBuilder(
        animation: PageController(
          viewportFraction: 0.9,
          initialPage: 0,
        ),
        builder: (context, child) {
          return child!;
        },
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AppDimensions.radiusNormal),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xff000000).withOpacity(0.05),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius:
                    BorderRadius.circular(AppDimensions.radiusNormal),
                child: InkWell(
                  onTap: () => NavigationService.handleUrls(
                      bannersImagesList[index].url,
                      context: context),
                  child: AIZImage.radiusImage(
                      bannersImagesList[index].photo, 6),
                ),
              ),
            );
          },
        ),
      );
    },
    options: CarouselOptions(
      aspectRatio: aspectRatio,
      viewportFraction: 0.7,
      enlargeCenterPage: true,
      enlargeStrategy: CenterPageEnlargeStrategy.zoom,
      padEnds: true,
      enableInfiniteScroll: canScroll,
      autoPlay: canScroll,
    ),
  ),
);
    } else {
      return const SizedBox();
    }
  }
}
