import 'package:active_ecommerce_cms_demo_app/locale/custom_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../app_config.dart';
import '../../../custom/flash deals banner/flash_deal_banner.dart';
import '../../../data_model/flash_deal_response.dart';
import '../../../my_theme.dart';
import '../../../presenter/home_provider.dart';
import '../../flash_deal/flash_deal_list.dart';

class FlashDealHomeWidget extends StatelessWidget {
  const FlashDealHomeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final FlashDealResponseDatum? flashDeal =
        context.select<HomeProvider, FlashDealResponseDatum?>(
            (provider) => provider.flashDeal);
    if (flashDeal == null) return emptyWidget;
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return FlashDealList();
            }));
          },
          child: ColoredBox(
            color: Colors.transparent,
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(22, 10, 10, 10),
                  child: Text('flash_deal_ucf'.tr(context: context),
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18)),
                ),
                Image.asset(
                  AppImages.flashDeal,
                  height: 20,
                  color: MyTheme.golden,
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Container(
              width: 300,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withValues(alpha: 0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(0, 3), // changes position of shadow
                  )
                ],
                color: const Color.fromARGB(255, 249, 248, 248),
                borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
              ),
              child: Padding(
                padding: const EdgeInsets.all(AppDimensions.paddingSmallExtra),
                child: Column(
                  children: [
                    //  buildTimerRow(homeData.flashDealRemainingTime),
                    //FlashBanner SpecialOffer
                    FlashBannerWidget(
                      bannerLink: flashDeal.banner,
                      slug: flashDeal.slug,
                    ),
                  ],
                ),
              )),
        ),
      ],
    );
  }
}