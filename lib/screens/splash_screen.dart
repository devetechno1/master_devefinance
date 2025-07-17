import 'dart:async';
import 'package:active_ecommerce_cms_demo_app/app_config.dart';
import 'package:active_ecommerce_cms_demo_app/custom/device_info.dart';
import 'package:active_ecommerce_cms_demo_app/my_theme.dart';
import 'package:active_ecommerce_cms_demo_app/constants/app_dimensions.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _scaleAnimation = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _controller.forward();

    Timer(const Duration(seconds: 3), () {
      // Navigate to next screen if needed
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: DeviceInfo(context).width,
        height: DeviceInfo(context).height,
        color: Theme.of(context).primaryColor,
        child: InkWell(
          child: Stack(
            children: <Widget>[
              CircleAvatar(
                backgroundColor: Colors.transparent,
                child: Hero(
                  tag: "backgroundImageInSplash",
                  child: Image.asset(
                    AppImages.splash_loginRegistrationBackgroundImage,
                  ),
                ),
                radius: 140.0,
              ),
              Positioned.fill(
                top: DeviceInfo(context).height! / 2 - 72,
                child: AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return Opacity(
                      opacity: _opacityAnimation.value,
                      child: Transform.scale(
                        scale: _scaleAnimation.value,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                bottom: AppDimensions.paddingSupSmall,
                              ),
                              child: Hero(
                                tag: "splashscreenImage",
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
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  bottom: AppDimensions.paddingSmallExtra),
                              child: Text(
                                AppConfig.appNameOnAppLang(context),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14.0,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
             const Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding:  EdgeInsets.all(8.0),
                  child:  Text(
                    "vw ${AppConfig.deveVersion}",
                    style: TextStyle(
                     // fontWeight: FontWeight.bold,
                      fontSize: 10.0,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding:  EdgeInsets.all(8.0),
                  child:  Text(
                    "vm ${AppConfig.VersionMobile}",
                    style: TextStyle(
                     // fontWeight: FontWeight.bold,
                      fontSize: 10.0,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
