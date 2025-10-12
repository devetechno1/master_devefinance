// import statements
import 'package:active_ecommerce_cms_demo_app/app_config.dart';
import 'package:active_ecommerce_cms_demo_app/my_theme.dart';
import 'package:active_ecommerce_cms_demo_app/presenter/home_provider.dart';
import 'package:active_ecommerce_cms_demo_app/screens/home/widgets/all_products.dart';
import 'package:active_ecommerce_cms_demo_app/screens/home/widgets/auction_products.dart';
import 'package:active_ecommerce_cms_demo_app/screens/home/widgets/best_selling_section_sliver.dart';
import 'package:active_ecommerce_cms_demo_app/screens/home/widgets/brand_list.dart';
import 'package:active_ecommerce_cms_demo_app/screens/home/widgets/build_app_bar.dart';
import 'package:active_ecommerce_cms_demo_app/screens/home/widgets/featured_category/feautured_category_horizontal.dart';
import 'package:active_ecommerce_cms_demo_app/screens/home/widgets/product_loading_container.dart';
import 'package:flutter/material.dart';
import 'package:active_ecommerce_cms_demo_app/locale/custom_localization.dart';
import 'package:provider/provider.dart';
import '../../../custom/home_banners/home_banners_one.dart';
import '../../../custom/home_banners/home_banners_three.dart';
import '../../../custom/home_banners/home_banners_two.dart';
import '../../../custom/home_carousel_slider.dart';
import '../../../custom/pirated_widget.dart';
import '../../../other_config.dart';
import '../../../services/push_notification_service.dart';
import '../widgets/featured_products_list_sliver.dart';
import '../widgets/flash_deal_home_widget.dart';
import '../widgets/new_products_list_sliver.dart';
import '../widgets/today_deal.dart';
import '../widgets/whatsapp_floating_widget.dart';

class MinimaScreen extends StatefulWidget {
  const MinimaScreen({
    Key? key,
    this.title,
    this.show_back_button = false,
    this.go_back = true,
  }) : super(key: key);

  final String? title;
  final bool show_back_button;
  final bool go_back;

  @override
  _MinimaScreenState createState() => _MinimaScreenState();
}

class _MinimaScreenState extends State<MinimaScreen>
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
                          AppConfig.purchase_code == ""
                              ? const PiratedWidget()
                              : emptyWidget,
                          const SizedBox(height: 10),

                          // Header Banner
                          const HomeCarouselSlider(),
                          const SizedBox(height: 16),

                          // Flash Sale Section
                          const FlashDealHomeWidget(),
                        ]),
                      ),
                      const TodaysDealProductsSliverWidget(),

                      //new products-----------------------------
                      const NewProductsListSliver(),
                      //feature_categories//

                      const CategoryList(),
                      const SliverToBoxAdapter(child: HomeBannersOne()),
                      const FeaturedProductsListSliver(),
                      const SliverToBoxAdapter(child: HomeBannersTwo()),

                      //Best Selling
                      const BestSellingSectionSliver(),
                      const NewProductsListSliver(),
                      const SliverToBoxAdapter(child: HomeBannersThree()),

                      //auction products
                      const AuctionProductsSectionSliver(),

                      const BrandListSectionSliver(),
                      //all products ------------
                      ...allProductsSliver,
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

  Widget timerCircularContainer(
    int currentValue,
    int totalValue,
    String timeText,
  ) {
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: 30,
          height: 30,
          child: CircularProgressIndicator(
            value: currentValue / totalValue,
            backgroundColor: const Color.fromARGB(255, 240, 220, 220),
            valueColor: const AlwaysStoppedAnimation<Color>(
                Color.fromARGB(255, 255, 80, 80)),
            strokeWidth: 4.0,
            strokeCap: StrokeCap.round,
          ),
        ),
        Text(
          timeText,
          style: const TextStyle(
            color: Color.fromARGB(228, 218, 29, 29),
            fontSize: 10.0,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class BuildTimerRow extends StatelessWidget {
  const BuildTimerRow(this.time, {super.key});

  final CurrentRemainingTime time;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
      child: Row(
        children: [
          const Spacer(),
          Column(
            children: [
              TimerCircularContainer(time.days, 365,
                  timeText((time.days).toString(), default_length: 3)),
              const SizedBox(height: 5),
              Text('days'.tr(context: context),
                  style: const TextStyle(color: Colors.grey, fontSize: 10))
            ],
          ),
          const SizedBox(width: 12),
          Column(
            children: [
              TimerCircularContainer(time.hours, 24,
                  timeText((time.hours).toString(), default_length: 2)),
              const SizedBox(height: 5),
              Text('hours'.tr(context: context),
                  style: const TextStyle(color: Colors.grey, fontSize: 10))
            ],
          ),
          const SizedBox(width: 10),
          Column(
            children: [
              TimerCircularContainer(time.min, 60,
                  timeText((time.min).toString(), default_length: 2)),
              const SizedBox(height: 5),
              Text('minutes'.tr(context: context),
                  style: const TextStyle(color: Colors.grey, fontSize: 10))
            ],
          ),
          const SizedBox(width: 5),
          Column(
            children: [
              TimerCircularContainer(time.sec, 60,
                  timeText((time.sec).toString(), default_length: 2)),
              const SizedBox(height: 5),
              Text('seconds'.tr(context: context),
                  style: const TextStyle(color: Colors.grey, fontSize: 10))
            ],
          ),
          const SizedBox(width: 10),
          const Column(
            children: [
              ///  Image.asset("assets/flash_deal.png", height: 20, color: MyTheme.golden),
              SizedBox(height: 12),
            ],
          ),
          Row(
            children: [
              Text('shop_more_ucf'.tr(context: context),
                  style:
                      const TextStyle(fontSize: 10, color: Color(0xffA8AFB3))),
              const SizedBox(width: 3),
              const Icon(Icons.arrow_forward_outlined,
                  size: 10, color: MyTheme.grey_153),
              const SizedBox(width: 10),
            ],
          )
        ],
      ),
    );
  }
}

String timeText(String val, {int default_length = 2}) {
  return val.padLeft(default_length, '0');
}

class TimerCircularContainer extends StatelessWidget {
  const TimerCircularContainer(
    this.currentValue,
    this.totalValue,
    this.timeText, {
    super.key,
  });
  final int currentValue;
  final int totalValue;
  final String timeText;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: 30,
          height: 30,
          child: CircularProgressIndicator(
            value: currentValue / totalValue,
            backgroundColor: const Color.fromARGB(255, 240, 220, 220),
            valueColor: const AlwaysStoppedAnimation<Color>(
                Color.fromARGB(255, 255, 80, 80)),
            strokeWidth: 4.0,
            strokeCap: StrokeCap.round,
          ),
        ),
        Text(
          timeText,
          style: const TextStyle(
            color: Color.fromARGB(228, 218, 29, 29),
            fontSize: 10.0,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
