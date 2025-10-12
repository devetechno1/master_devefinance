// import statements
import 'package:active_ecommerce_cms_demo_app/app_config.dart';
import 'package:active_ecommerce_cms_demo_app/locale/custom_localization.dart';
import 'package:active_ecommerce_cms_demo_app/screens/home/widgets/all_products.dart';
import 'package:active_ecommerce_cms_demo_app/screens/home/widgets/auction_products.dart';
import 'package:active_ecommerce_cms_demo_app/screens/home/widgets/best_selling_section_sliver.dart';
import 'package:active_ecommerce_cms_demo_app/screens/home/widgets/brand_list.dart';
import 'package:active_ecommerce_cms_demo_app/screens/home/widgets/build_app_bar.dart';
import 'package:active_ecommerce_cms_demo_app/screens/home/widgets/featured_category/feautured_category_horizontal.dart';
import 'package:active_ecommerce_cms_demo_app/screens/home/widgets/flash_sale.dart';
import 'package:active_ecommerce_cms_demo_app/screens/home/widgets/new_products_list_sliver.dart';
import 'package:active_ecommerce_cms_demo_app/screens/home/widgets/product_loading_container.dart';
import 'package:active_ecommerce_cms_demo_app/screens/home/widgets/today_deal.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../custom/home_banners/home_banners_one.dart';
import '../../../custom/home_banners/home_banners_three.dart';
import '../../../custom/home_banners/home_banners_two.dart';
import '../../../custom/home_carousel_slider.dart';
import '../../../custom/pirated_widget.dart';
import '../../../other_config.dart';
import '../../../presenter/home_provider.dart';
import '../../../services/push_notification_service.dart';
import '../widgets/featured_products_list_sliver.dart';
import '../widgets/whatsapp_floating_widget.dart';

class ReClassicScreen extends StatefulWidget {
  const ReClassicScreen({
    Key? key,
    this.title,
    this.show_back_button = false,
    this.go_back = true,
  }) : super(key: key);

  final String? title;
  final bool show_back_button;
  final bool go_back;

  @override
  _ReClassicScreenState createState() => _ReClassicScreenState();
}

class _ReClassicScreenState extends State<ReClassicScreen>
    with SingleTickerProviderStateMixin {
  late final HomeProvider provider = context.read<HomeProvider>();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        if (OtherConfig.USE_PUSH_NOTIFICATION)
          PushNotificationService.updateDeviceToken();
        provider.onRefresh();
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: widget.go_back,
      child: SafeArea(
        child: Scaffold(
          floatingActionButton: whatsappFloatingButtonWidget,
          appBar: BuildAppBar(context: context),
          backgroundColor: Colors.white,
          body: Stack(
            children: [
              RefreshIndicator(
                color: Theme.of(context).primaryColor,
                backgroundColor: Colors.white,
                onRefresh: provider.onRefresh,
                displacement: 0,
                child: NotificationListener<ScrollUpdateNotification>(
                  onNotification: (notification) {
                    provider.paginationListener(notification.metrics);
                    return false;
                  },
                  child: CustomScrollView(
                    physics: const BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics(),
                    ),
                    slivers: <Widget>[
                      SliverList(
                          delegate: SliverChildListDelegate([
                        const HomeCarouselSlider(),
                      ])),
                      const CategoryList(),

                      SliverList(
                          delegate: SliverChildListDelegate([
                        Padding(
                          padding: const EdgeInsets.only(
                              left: AppDimensions.paddingLarge, bottom: 10),
                          child: Text('todays_deal_ucf'.tr(context: context),
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18)),
                        ),
                      ])),
                      const TodaysDealProductsSliverWidget(),

                      //BannerList---------------------
                      const SliverToBoxAdapter(child: HomeBannersOne()),

                      SliverList(
                        delegate: SliverChildListDelegate([
                          AppConfig.purchase_code == ""
                              ? const PiratedWidget()
                              : emptyWidget,
                          const SizedBox(height: 10),
                          //featured

                          // Header Banner

                          const SizedBox(height: 16),

                          // Flash Sale Section
                          FlashSale(
                            isCircle: false,
                            defaultTextColor: Theme.of(context).primaryColor,
                          )
                        ]),
                      ),
                      //featuredProducts-----------------------------
                      const FeaturedProductsListSliver(),

                      //BannerList---------------------
                      const SliverToBoxAdapter(child: HomeBannersTwo()),

                      //Best Selling-------------------
                      const BestSellingSectionSliver(),
                      //newProducts-----------------------------
                      const NewProductsListSliver(),
                      //BannerList---------------------
                      const SliverToBoxAdapter(child: HomeBannersThree()),
                      //auctionProducts------------
                      const AuctionProductsSectionSliver(),

                      //Brand List ---------------------------

                      const BrandListSectionSliver(),

                      //all products --------------------------
                      ...allProductsSliver,

                      ///
                    ],
                  ),
                ),
              ),
              const Align(
                alignment: Alignment.center,
                child: ProductLoadingContainer(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
