// import statements
import 'package:active_ecommerce_cms_demo_app/my_theme.dart';
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
import '../../../app_config.dart';
import '../../../custom/home_banners/home_banners_one.dart';
import '../../../custom/home_carousel_slider.dart';
import '../../../custom/pirated_widget.dart';
import '../../../other_config.dart';
import '../../../presenter/home_provider.dart';
import '../../../services/push_notification_service.dart';
import '../widgets/featured_products_list_sliver.dart';
import '../widgets/whatsapp_floating_widget.dart';

class MegamartScreen extends StatefulWidget {
  const MegamartScreen({
    Key? key,
    this.title,
    this.show_back_button = false,
    this.go_back = true,
  }) : super(key: key);

  final String? title;
  final bool show_back_button;
  final bool go_back;

  @override
  _MegamartScreenState createState() => _MegamartScreenState();
}

class _MegamartScreenState extends State<MegamartScreen>
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
          appBar: BuildAppBar(context: context),
          floatingActionButton: whatsappFloatingButtonWidget,
          backgroundColor: Colors.white,
          body: Stack(
            children: [
              RefreshIndicator(
                color: MyTheme.primaryColor,
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
                      //Featured category-----------------------
                      const CategoryList(),
                      SliverList(
                        delegate: SliverChildListDelegate([
                          AppConfig.purchase_code == ""
                              ? const PiratedWidget()
                              : emptyWidget,
                          const SizedBox(height: 10),
                          // Header Banner
                          const HomeCarouselSlider(),
                          const SizedBox(height: 10),

                          // Flash Sale Section
                          const FlashSale(isCircle: false),
                        ]),
                      ),
                      //move banner
                      const TodaysDealProductsWidget(),

                      //featuredProducts-----------------------------
                      const FeaturedProductsListSliver(),
                      //BannerList---------------------
                      const SliverToBoxAdapter(child: HomeBannersOne()),

                      //Best Selling-------------------
                      // if(homeData.isFeaturedProductInitial || homeData.featuredProductList.isNotEmpty)
                      const BestSellingSectionSliver(),
                      //newProducts-----------------------------
                      const NewProductsListSliver(),

                      //Brand List ---------------------------
                      const BrandListSectionSliver(showViewAllButton: false),
                      //auctionProducts------------
                      const AuctionProductsSectionSliver(),
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
