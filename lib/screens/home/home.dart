// ignore_for_file: non_constant_identifier_names

import 'package:active_ecommerce_cms_demo_app/app_config.dart';
import 'package:active_ecommerce_cms_demo_app/custom/flash%20deals%20banner/flash_deal_banner.dart';
import 'package:active_ecommerce_cms_demo_app/custom/home_banners/home_banners_one.dart';
import 'package:active_ecommerce_cms_demo_app/custom/home_banners/home_banners_three.dart';
import 'package:active_ecommerce_cms_demo_app/custom/home_banners/home_banners_two.dart';
import 'package:active_ecommerce_cms_demo_app/presenter/home_provider.dart';
import 'package:active_ecommerce_cms_demo_app/screens/home/widgets/build_app_bar.dart';
import 'package:active_ecommerce_cms_demo_app/screens/home/widgets/featured_products_list_sliver.dart';
import 'package:active_ecommerce_cms_demo_app/screens/home/widgets/featured_category/feautured_category_horizontal.dart';
import 'package:active_ecommerce_cms_demo_app/screens/home/widgets/menu_item_list.dart';

import 'package:flutter/material.dart';
import 'package:active_ecommerce_cms_demo_app/locale/custom_localization.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../custom/home_all_products_2.dart';
import '../../custom/home_carousel_slider.dart';
import '../../custom/pirated_widget.dart';
import '../../other_config.dart';
import '../../services/push_notification_service.dart';

class Home extends StatefulWidget {
  const Home({
    Key? key,
    this.title,
    this.show_back_button = false,
    this.go_back = true,
  }) : super(key: key);

  final String? title;
  final bool show_back_button;
  final bool go_back;

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  late final HomeProvider homeProvider = context.read<HomeProvider>();
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        if (OtherConfig.USE_PUSH_NOTIFICATION)
          PushNotificationService.updateDeviceToken();
        homeProvider.onRefresh();
      },
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return PopScope(
      canPop: widget.go_back,
      child: SafeArea(
        child: Scaffold(
          appBar: BuildAppBar(context: context),
          backgroundColor: Colors.white,
          body: Stack(
            children: [
              RefreshIndicator(
                color: Theme.of(context).primaryColor,
                backgroundColor: Colors.white,
                onRefresh: homeProvider.onRefresh,
                displacement: 0,
                child: NotificationListener<ScrollUpdateNotification>(
                  onNotification: (notification) {
                    homeProvider.paginationListener(notification.metrics);
                    return false;
                  },
                  child: CustomScrollView(
                    physics: const BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics(),
                    ),
                    slivers: <Widget>[
                      SliverList(
                        delegate: SliverChildListDelegate([
                          if (AppConfig.purchase_code == "")
                            const PiratedWidget(),

                          const SizedBox(height: 10),

                          //Header Search
                          // Padding(
                          //   padding:
                          //       const EdgeInsets.symmetric(horizontal: 20),
                          //   child: HomeSearchBox(),
                          // ),
                          // SizedBox(height: 8),
                          //Header Banner
                          const HomeCarouselSlider(),
                          const SizedBox(height: 16),

                          Padding(
                            padding: const EdgeInsets.only(
                                bottom: AppDimensions.paddingDefault),
                            child: MenuItemList(),
                          ),
                          // SizedBox(height: 16),

                          //Home slider one
                          const HomeBannersOne(),
                        ]),
                      ),

                      //Featured Categories
                      const CategoryList(),
                      const SliverToBoxAdapter(child: HomeBannersTwo()),
                      // const  CategoryListVertical(crossAxisCount: 5,),

                      if (homeProvider.isFlashDeal)
                        SliverList(
                            delegate: SliverChildListDelegate([
                          InkWell(
                            onTap: () =>
                                GoRouter.of(context).go('/flash-deals'),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              child: Text(
                                'flash_deals_ucf'.tr(context: context),
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w700),
                              ),
                            ),
                          ),
                          const FlashDealBanner(),
                        ])),

                      // SliverList(
                      //     delegate: SliverChildListDelegate([
                      //   FlashDealBanner(
                      //     context: context,
                      //     homeData: homeData,
                      //   ),
                      // ])),

                      //Featured Products
                      const FeaturedProductsListSliver(),
                      //Home Banner Slider Two
                      const SliverToBoxAdapter(child: HomeBannersThree()),
                      SliverPadding(
                        padding: const EdgeInsets.fromLTRB(18.0, 20, 20.0, 0.0),
                        sliver: SliverToBoxAdapter(
                          child: Text(
                            'all_products_ucf'.tr(context: context),
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),

                      //Home All Product
                      const HomeAllProductsSliver(),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Selector<HomeProvider, HomeProvider>(
                    selector: (context, a) => a,
                    builder: (context, s, child) {
                      return Container(
                        height: s.showAllLoadingContainer ? 36 : 0,
                        width: double.infinity,
                        color: Colors.white,
                        child: Center(
                          child: Text(
                            s.totalAllProductData == s.allProductList.length
                                ? 'no_more_products_ucf'.tr(context: context)
                                : 'loading_more_products_ucf'
                                    .tr(context: context),
                          ),
                        ),
                      );
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
