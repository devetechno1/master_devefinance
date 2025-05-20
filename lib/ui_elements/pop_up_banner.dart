import 'dart:math';

import 'package:flutter/material.dart';
import 'package:one_context/one_context.dart';

import 'package:go_router/go_router.dart';
import '../helpers/color_helper.dart';
import '../repositories/pop_up_repositry.dart';
import '../services/navigation_service.dart';

class PopupBanner extends StatelessWidget {
  final String title;
  final String message;
  final String imageUrl;
  final VoidCallback onClose;
  final VoidCallback? onAction;
  final String? actionText;
  final Color? btnBackgroundColor;

  const PopupBanner({
    super.key,
    required this.title,
    required this.message,
    required this.imageUrl,
    required this.onClose,
    required this.onAction,
    required this.actionText,
    required this.btnBackgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            children: [
              Image.network(
                imageUrl,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              Positioned(
                top: 1,
                right: 1,
                child: Container(
                  width: 35,
                  height: 35,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    icon: const Icon(Icons.close, size: 18),
                    onPressed: onClose,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              title,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          const SizedBox(height: 16),
          if (onAction != null && actionText != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: ElevatedButton(
                onPressed: onAction,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 33),
                  backgroundColor: btnBackgroundColor,
                  shape: const RoundedRectangleBorder(),
                ),
                child: Text(
                  actionText!,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

void showPopupBanner(BuildContext context) {
  fetchBannerpopupData().then((data) {
    if (data.isNotEmpty && data['data'] != null && data['data'].length > 0) {
      final banners = data['data'];
      final random = Random();
      final randomIndex = random.nextInt(banners.length);
      final bannerData = banners[randomIndex];
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => PopupBanner(
          btnBackgroundColor:
              ColorHelper.stringToColor(bannerData['btn_background_color']) ??
                  Colors.black,
          title: bannerData['title'] ?? '',
          message: bannerData['summary'] ?? '',
          imageUrl: bannerData['image'] ?? '',
          actionText: bannerData['btn_text'] ?? '',
          onAction: () {
            final url = bannerData['btn_link'] ?? '';
            if (url.isNotEmpty) {
              NavigationService.handleUrls(url);
              Navigator.pop(context);
            }
          },
          onClose: () => Navigator.pop(context),
        ),
      );
    }
  });
}

void handleBannerNavigation(BuildContext context, String url) {
  try {
    final uri = Uri.parse(url);
    final path = uri.path;
    if (path.isNotEmpty) {
      final router = GoRouter.of(OneContext().key.currentContext!);
      router.go(path);
    } else {
      print("Invalid path in URL: $url");
    }
  } catch (e) {
    print("Error parsing URL: $e");
  }
}
