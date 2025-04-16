 import 'package:active_ecommerce_cms_demo_app/custom/home_banners_list.dart';
import 'package:active_ecommerce_cms_demo_app/presenter/home_presenter.dart';
import 'package:active_ecommerce_cms_demo_app/screens/home/widgets/custom_autaction_product.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AuctionProductsSectionSliver extends StatelessWidget {
  final HomePresenter homeData;

  const AuctionProductsSectionSliver({
    super.key,
    required this.homeData,
  });

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildListDelegate([
        SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(18.0, 20, 20.0, 0.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsetsDirectional.only(bottom: 10),
                      child: SizedBox(
                        width: double.infinity,
                        child: Text(
                          AppLocalizations.of(context)!.auction_product_ucf,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    HomeBannersList(
                      bannersImagesList: homeData.bannerThreeImageList,
                      isBannersInitial: homeData.isBannerThreeInitial,
                    ),
                  ],
                ),
              ),
              CustomAuctionProductsListWidget(
                products: homeData.auctionProductList,
              ),
            ],
          ),
        ),
      ]),
    );
  }
}
