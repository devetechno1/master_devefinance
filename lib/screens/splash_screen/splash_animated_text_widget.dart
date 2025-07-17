import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';

import '../../app_config.dart';
import '../../constants/app_dimensions.dart';
import '../../constants/app_images.dart';
import '../../custom/lang_text.dart';
import '../../my_theme.dart';

class AnimatedTextWidget extends StatelessWidget {
  const AnimatedTextWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(
            bottom: AppDimensions.paddingSupSmall,
          ),
          child: Container(
            height: 100,
            width: 100,
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: MyTheme.white,
              borderRadius: BorderRadius.circular(
                AppDimensions.radiusSmall,
              ),
            ),
            child: Image.asset(
              AppImages.splashScreenLogo,
              filterQuality: FilterQuality.low,
            ),
          ),
        ),
        Padding(
          padding:
              const EdgeInsets.only(bottom: AppDimensions.paddingSmallExtra),
          child: AnimatedTextKit(
            isRepeatingAnimation: false,
            animatedTexts: [
              TyperAnimatedText(
                LangText(context).local.app_name,
                textStyle: const TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                speed: const Duration(milliseconds: 100),
              ),
            ],
          ),
        )
      ],
    );
  }
}
