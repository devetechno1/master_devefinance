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
      this.viewportFraction = 0.49})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // When data is loading and no images are available
    if (isBannersInitial && bannersImagesList.isEmpty) {
      return Padding(
        padding: const EdgeInsets.only(left: 18.0, right: 18, top: 10, bottom: 20),
        child: ShimmerHelper().buildBasicShimmer(height: 120),
      );
    }

    // When banner images are available
    else if (bannersImagesList.isNotEmpty) {
      if(bannersImagesList.length == 1){
        return _DynamicSizeImageBanner(
          urlToOpen: bannersImagesList.first.url,
          photo: bannersImagesList.first.photo,
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
                  color: const Color(0xff000000).withValues(alpha: 0.1),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
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
      return const SizedBox();
    }
  }
}

class _DynamicSizeImageBanner extends StatefulWidget {
  final String? urlToOpen;
  final String? photo;

  const _DynamicSizeImageBanner({
    Key? key,
    required this.urlToOpen,
    required this.photo,
  }) : super(key: key);

  @override
  State<_DynamicSizeImageBanner> createState() => _DynamicSizeImageBannerState();
}

class _DynamicSizeImageBannerState extends State<_DynamicSizeImageBanner> {
  double? _aspectRatio;

  @override
  void initState() {
    super.initState();
    _getImageSize();
  }

  void _getImageSize() {
    final Image image = Image.network(widget.photo ?? '');
    image.image.resolve(const ImageConfiguration()).addListener(
      ImageStreamListener((ImageInfo info, bool _) {
        setState(() {
          _aspectRatio = info.image.width / info.image.height;
        });
      }),
    );
  }
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => NavigationService.handleUrls(widget.urlToOpen, context),
      child: _aspectRatio == null
          ? const Center(child: CircularProgressIndicator())
          : AspectRatio(
              aspectRatio: _aspectRatio!,
              child: AIZImage.radiusImage(widget.photo, 0),
            ),
    );
  }
}