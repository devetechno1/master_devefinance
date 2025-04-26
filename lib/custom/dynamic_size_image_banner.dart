import 'package:flutter/material.dart';

import '../helpers/shimmer_helper.dart';
import '../services/navigation_service.dart';
import 'aiz_image.dart';

class DynamicSizeImageBanner extends StatefulWidget {
  final String? urlToOpen;
  final String? photo;

  const DynamicSizeImageBanner({
    Key? key,
    required this.urlToOpen,
    required this.photo,
  }) : super(key: key);

  @override
  State<DynamicSizeImageBanner> createState() => _DynamicSizeImageBannerState();
}

class _DynamicSizeImageBannerState extends State<DynamicSizeImageBanner> {
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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: InkWell(
        onTap: () => NavigationService.handleUrls(widget.urlToOpen, context),
        child: _aspectRatio == null
            ? const LoadingImageBannerWidget()
            : AspectRatio(
                aspectRatio: _aspectRatio!,
                child: AIZImage.radiusImage(widget.photo, 0),
              ),
      ),
    );
  }
}

class LoadingImageBannerWidget extends StatelessWidget {
  const LoadingImageBannerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 18.0, right: 18, top: 10, bottom: 20),
      child: ShimmerHelper().buildBasicShimmer(height: 120),
    );
  }
}