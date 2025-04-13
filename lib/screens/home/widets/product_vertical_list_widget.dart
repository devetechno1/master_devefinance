import 'package:active_ecommerce_cms_demo_app/helpers/shimmer_helper.dart';
import 'package:active_ecommerce_cms_demo_app/my_theme.dart';
import 'package:active_ecommerce_cms_demo_app/presenter/home_presenter.dart';
import 'package:active_ecommerce_cms_demo_app/ui_elements/mini_product_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class FeaturedProductVerticalListWidget extends StatelessWidget {
  final HomePresenter homeData;
  const FeaturedProductVerticalListWidget({Key? key, required this.homeData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (homeData.isFeaturedProductInitial == true &&
        homeData.featuredProductList.isEmpty) {
      return Padding(
        padding: const EdgeInsets.only(right: 20, left: 20, top: 15),
        child: Column(
          children: [
          
            SizedBox(
              height: 120,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: ShimmerHelper().buildBasicShimmer(
                  height: 120.0,
                  width: (MediaQuery.of(context).size.width - 64) / 3,
                ),
              ),
            ),
            SizedBox(
              height: 120,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: ShimmerHelper().buildBasicShimmer(
                  height: 120.0,
                  width: (MediaQuery.of(context).size.width - 64) / 3,
                ),
              ),
            ),
            SizedBox(
              height: 120,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: ShimmerHelper().buildBasicShimmer(
                  height: 120.0,
                  width: (MediaQuery.of(context).size.width - 160) / 3,
                ),
              ),
            ),
          ],
        ),
      );
    } else if (homeData.featuredProductList.isNotEmpty) {
      return Container(
        alignment: Alignment.center,
        child: NotificationListener<ScrollNotification>(
          onNotification: (ScrollNotification scrollInfo) {
            if (scrollInfo.metrics.pixels ==
                scrollInfo.metrics.maxScrollExtent) {
              homeData.fetchFeaturedProducts();
            }
            return true;
          },
          child: ListView.separated(
            padding: const EdgeInsets.only(right: 20, left: 20, top: 5, bottom: 20),
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemCount: homeData.totalFeaturedProductData! >
                    homeData.featuredProductList.length
                ? homeData.featuredProductList.length + 1
                : homeData.featuredProductList.length,
            scrollDirection: Axis.vertical,
            physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics()),
            itemBuilder: (context, index) {
              if (index == homeData.featuredProductList.length) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  child: SpinKitFadingFour(
                    color: Colors.grey,
                    size: 30.0,
                  ),
                );
              }
              final product = homeData.featuredProductList[index];
              return MiniProductCard(
                id: product.id,
                slug: product.slug,
                image: product.thumbnail_image,
                name: product.name,
                main_price: product.main_price,
                stroked_price: product.stroked_price,
                has_discount: product.has_discount,
                is_wholesale: product.isWholesale,
                discount: product.discount,
              );
            },
          ),
        ),
      );
    } else {
      return SizedBox(
        height: 100,
        child: Center(
          child: Text(
            AppLocalizations.of(context)!.no_related_product,
            style: TextStyle(color: MyTheme.font_grey),
          ),
        ),
      );
    }
  }
}
