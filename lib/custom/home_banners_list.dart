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
      if(bannersImagesList.length == 1){
        return Align(
          child: AspectRatio(
            aspectRatio: 6,
            child: _BannerWidget(
                urlToOpen: bannersImagesList.first.url,
                photo: bannersImagesList.first.photo,
                bannerRadius: 0,
              ),
          ),
        );
      }
      final bool canScroll = bannersImagesList.length > 2;

      return CarouselSlider(
        options: CarouselOptions(
          aspectRatio: aspectRatio,
          viewportFraction: viewportFraction,
          initialPage: 0,  
          padEnds: false,
          enlargeCenterPage: false,
          enableInfiniteScroll: canScroll,
          autoPlay: canScroll,
        ),
        items: bannersImagesList.map((i) {
          print('Image URL: ${i.photo}');
          return Container(
            margin: const EdgeInsetsDirectional.only(start: 12, bottom: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xff000000).withOpacity(0.1),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: _BannerWidget(
                urlToOpen: i.url,
                photo: i.photo,
              ),
            ),
          );
        }).toList(),
      );
    } else {
      return const SizedBox();
    }
  }
}

class _BannerWidget extends StatelessWidget {
  const _BannerWidget({
    required this.urlToOpen, 
    required this.photo,
    this.bannerRadius = 6,
  });
  final String? urlToOpen;
  final String? photo;
  final double bannerRadius;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => NavigationService.handleUrls(urlToOpen, context),
      child: AIZImage.radiusImage(photo, bannerRadius),
    );
  }
}
