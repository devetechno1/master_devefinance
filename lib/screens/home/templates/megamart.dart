// import statements
import 'package:active_ecommerce_cms_demo_app/app_config.dart';
import 'package:active_ecommerce_cms_demo_app/custom/flash%20deals%20banner/flash_deal_banner.dart';
import 'package:active_ecommerce_cms_demo_app/custom/lang_text.dart';
import 'package:active_ecommerce_cms_demo_app/helpers/shared_value_helper.dart';
import 'package:active_ecommerce_cms_demo_app/my_theme.dart';
import 'package:active_ecommerce_cms_demo_app/presenter/home_presenter.dart';
import 'package:active_ecommerce_cms_demo_app/screens/filter.dart';
import 'package:active_ecommerce_cms_demo_app/screens/flash_deal/flash_deal_list.dart';
import 'package:active_ecommerce_cms_demo_app/screens/home/widgets/all_products.dart';
import 'package:active_ecommerce_cms_demo_app/screens/home/widgets/auction_products.dart';
import 'package:active_ecommerce_cms_demo_app/screens/home/widgets/best_selling_section_sliver.dart';
import 'package:active_ecommerce_cms_demo_app/screens/home/widgets/brand_list.dart';
import 'package:active_ecommerce_cms_demo_app/screens/home/widgets/feautured_category.dart';
import 'package:active_ecommerce_cms_demo_app/screens/home/widgets/new_products_list_sliver.dart';
import 'package:active_ecommerce_cms_demo_app/screens/home/widgets/today_deal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../custom/home_banners_list.dart';
import '../../../custom/home_carousel_slider.dart';
import '../../../custom/home_search_box.dart';
import '../../../custom/pirated_widget.dart';
import '../../../other_config.dart';
import '../../../services/push_notification_service.dart';
import '../home.dart';
import '../widgets/featured_products_list_sliver.dart';

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

class _MegamartScreenState extends State<MegamartScreen> with TickerProviderStateMixin {
  @override
  void initState() {
    Future.delayed(Duration.zero).then((value) {
      if (OtherConfig.USE_PUSH_NOTIFICATION) PushNotificationService.updateDeviceToken();
      change();
    });
    super.initState();
  }

  void change() {
    homeData.onRefresh();
    homeData.mainScrollListener(context);
    homeData.initPiratedAnimation(this);
  }

  @override
  void dispose() {
    homeData.pirated_logo_controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return widget.go_back;
      },
      child: Directionality(
        textDirection: app_language_rtl.$! ? TextDirection.rtl : TextDirection.ltr,
        child: SafeArea(
          child: Scaffold(
            appBar: buildAppBar(34, context),
            backgroundColor: Colors.white,
            body: ListenableBuilder(
              listenable: homeData,
              builder: (context, child) {
                return Stack(
                  children: [
                    RefreshIndicator(
                      color: MyTheme.accent_color,
                      backgroundColor: Colors.white,
                      onRefresh: homeData.onRefresh,
                      displacement: 0,
                      child: CustomScrollView(
                        controller: homeData.mainScrollController,
                        physics: const BouncingScrollPhysics(
                          parent: AlwaysScrollableScrollPhysics(),
                        ),
                        
                        slivers: <Widget>[
                          //Featured category-----------------------
                            const CategoryList(),
                          SliverList(
                            delegate: SliverChildListDelegate([
                              AppConfig.purchase_code == "" ? PiratedWidget(homeData: homeData) : const SizedBox(),
                              const SizedBox(height: 10),
                              //featured

                              // Header Banner
                             HomeCarouselSlider(homeData: homeData, context: context),
                              const SizedBox(height: 16),

                              // Flash Sale Section
                              if(homeData.flashDeal != null)
                              ...[

                              GestureDetector(
                                onTap: (){ Navigator.push(context, MaterialPageRoute(builder: (context) {
                                  return FlashDealList();
                                }));},
                                child: ColoredBox(
                                  color: Colors.transparent,
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsetsDirectional.fromSTEB(25, 10, 10, 10),
                                        child: Text(AppLocalizations.of(context)!.flash_sale, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                                      ),
                                       Image.asset("assets/flash_deal.png", height: 20, color: MyTheme.golden),
                                    ],
                                  ),
                                ),
                              ),

                              Container(
                                width: 300,
                                margin: const EdgeInsets.symmetric(horizontal: 25),
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 5,
                                      blurRadius: 7,
                                      offset: const Offset(0, 3), // changes position of shadow
                                )],
                                  color:  const Color.fromARGB(255, 249, 248, 248),
                                  borderRadius: BorderRadius.circular(8.0),
                              
                                ),
                                child: Column(
                                  children: [
                                    buildTimerRow(homeData.flashDealRemainingTime),
                                  //FlashBanner SpecialOffer
                                    SizedBox(
                                      height: 300,
                                      child: LayoutBuilder(
                                        builder: (context,constrainedBox) {
                                          return FlashBannerWidget(
                                            size: constrainedBox.maxWidth,
                                            
                                            bannerLink: homeData.flashDeal?.banner, 
                                            slug: homeData.flashDeal!.slug,
                                          );
                                        }
                                      ),
                                    ),
                                                              
                                      
                                  ],
                                )),
                              const SizedBox(height: 30),

                              ],
                            ]),
                          ),                      
                            //move banner 
                          SliverList(
                            delegate: SliverChildListDelegate(
                              [
                                // Image.network("https://devefinance.com/public/uploads/all/Ryto4mRZFjxR8INkhLs1DFyX6eoamXKIxXEDFBZM.png"),
                                TodaysDealProductsWidget(homePresenter: homeData,),
                              ]
                            ),
                          ),


//featuredProducts-----------------------------   
                          const FeaturedProductsListSliver(),
//BannerList---------------------                            
                            SliverToBoxAdapter(
                              child: HomeBannersList(
                                bannersImagesList: homeData.bannerTwoImageList,
                                isBannersInitial: homeData.isBannerTwoInitial,
                              ),
                            ),

//Best Selling-------------------
                           // if(homeData.isFeaturedProductInitial || homeData.featuredProductList.isNotEmpty)
                            const BestSellingSectionSliver(),
//newProducts-----------------------------                            
                            const NewProductsListSliver(),

//Brand List ---------------------------
                          if(homeData.isBrandsInitial || homeData.brandsList.isNotEmpty)
                        BrandListSectionSliver(homeData: homeData,showViewAllButton: false),
//auctionProducts------------ 
                                AuctionProductsSectionSliver(homeData: homeData,),                   
//all products --------------------------
                          AllProducts(homeData: homeData,),
                          ///
                        ],
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: buildProductLoadingContainer(homeData),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }



  AppBar buildAppBar(double statusBarHeight, BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.white,
      scrolledUnderElevation: 0.0,
      centerTitle: false,
      elevation: 0,
      flexibleSpace: Padding(
        padding: const EdgeInsets.only(top: 10.0, bottom: 10, left: 18, right: 18),
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => const Filter()));
          },
          child: HomeSearchBox(context: context),
        ),
      ),
    );
  }

  Container buildProductLoadingContainer(HomePresenter homeData) {
    return Container(
      height: homeData.showAllLoadingContainer ? 36 : 0,
      width: double.infinity,
      color: Colors.white,
      child: Center(
        child: Text(
          homeData.totalAllProductData == homeData.allProductList.length
              ? AppLocalizations.of(context)!.no_more_products_ucf
              : AppLocalizations.of(context)!.loading_more_products_ucf,
        ),
      ),
    );
  }

  Widget timerCircularContainer(String timeText) {
    return Text(
      timeText,
      style: const TextStyle(
        color:Colors.white,
        fontSize: 14.0,
        fontWeight: FontWeight.w600,
      ),
    );
  }
  

Widget buildTimerRow(CurrentRemainingTime time) {
  return Container(
    height: 35,
    margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 12),
    decoration: BoxDecoration(
      color: const Color(0xFF215ABC), //TODO## color
      borderRadius: BorderRadius.circular(5)
    ),
    child: SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      
      child: Row(
        children: [
          const SizedBox(width: 10),
          // RichText(
          //   text: TextSpan(
          //     style: TextStyle(
          //       color:Colors.white,
          //       fontSize: 14.0,
          //       fontWeight: FontWeight.w600,
          //     ),
          //     children: [
          //       TextSpan(text: timeText((time.days).toString(), default_length: 3)),
          //       WidgetSpan(
          //         alignment: PlaceholderAlignment.top,
          //         baseline: TextBaseline.ideographic,
          //         child: Text(LangText(context).local.days, style: const TextStyle(color: Colors.white, fontSize: 9))
          //       )
          //     ],
          //   ),
          // ),
          Row(
            children: [
              
              timerCircularContainer(timeText((time.days).toString(), default_length: 3,)),
              const SizedBox(width: 4),
              Text(LangText(context).local.days, style: const TextStyle(color: Colors.white, fontSize: 9)),
            ],
          ),
          const SizedBox(width: 10),
          Row(
            children: [
              const Padding(
                padding: EdgeInsets.only(right: 10),
                child: Text(':',style: TextStyle(color: Colors.white),),
              ),
              timerCircularContainer(timeText((time.hours).toString(), default_length: 2)),
              const SizedBox(width: 4),
              Text(LangText(context).local.hours, style: const TextStyle(color: Colors.white, fontSize: 9)),
            ],
          ),
          const SizedBox(width: 10),
          Row(
            children: [
                    const Padding(
                padding: EdgeInsets.only(right: 10),
                child: Text(':',style: TextStyle(color: Colors.white),),
              ),                timerCircularContainer(timeText((time.min).toString(), default_length: 2)),
              const SizedBox(width: 4),
              Text(LangText(context).local.minutes, style: const TextStyle(color: Colors.white, fontSize: 9)),
            ],
          ),
          const SizedBox(width: 10),
          Row(
            children: [
                 const Padding(
                padding: EdgeInsets.only(right: 10),
                child: Text(':',style: TextStyle(color: Colors.white),),
              ),                timerCircularContainer(timeText((time.sec).toString(), default_length: 2)),
              const SizedBox(width: 4),
              Text(LangText(context).local.seconds, style: const TextStyle(color: Colors.white, fontSize: 9)),
            ],
          ),
          const SizedBox(width: 10),
          // Row(
          //   children: [
          //     Text(LangText(context).local.shop_more_ucf, style: const TextStyle(fontSize: 10, color: Colors.white)),
          //     const SizedBox(width: 3),
          //     const Icon(Icons.arrow_forward_outlined, size: 10, color: Colors.white),
          //   ],
          // ),
          const SizedBox(width: 10),
        ],
      ),
    ),
  );
}
  String timeText(String val, {int default_length = 2}) {
    return val.padLeft(default_length, '0');
  }
}



