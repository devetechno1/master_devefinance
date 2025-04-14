// import statements
import 'package:active_ecommerce_cms_demo_app/app_config.dart';
import 'package:active_ecommerce_cms_demo_app/custom/flash%20deals%20banner/flash_deal_banner.dart';
import 'package:active_ecommerce_cms_demo_app/custom/lang_text.dart';
import 'package:active_ecommerce_cms_demo_app/helpers/shared_value_helper.dart';
import 'package:active_ecommerce_cms_demo_app/my_theme.dart';
import 'package:active_ecommerce_cms_demo_app/presenter/home_presenter.dart';
import 'package:active_ecommerce_cms_demo_app/screens/filter.dart';
import 'package:active_ecommerce_cms_demo_app/screens/flash_deal/flash_deal_list.dart';
import 'package:active_ecommerce_cms_demo_app/screens/home/widets/bestSellingWidget.dart';
import 'package:active_ecommerce_cms_demo_app/screens/home/widets/get_brands_widget.dart';
import 'package:active_ecommerce_cms_demo_app/screens/home/widets/today_deal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../custom/feature_categories_widget.dart';
import '../../../custom/featured_product_horizontal_list_widget.dart';
import '../../../custom/home_all_products_2.dart';
import '../../../custom/home_carousel_slider.dart';
import '../../../custom/home_search_box.dart';
import '../../../custom/pirated_widget.dart';
import '../../../other_config.dart';
import '../../../services/push_notification_service.dart';
import '../../../single_banner/sincle_banner_page.dart';
import '../widets/autactionProduct.dart';

HomePresenter homeData = HomePresenter();

class MetroScreen extends StatefulWidget {
  const MetroScreen({
    Key? key,
    this.title,
    this.show_back_button = false,
    this.go_back = true,
  }) : super(key: key);

  final String? title;
  final bool show_back_button;
  final bool go_back;

  @override
  _MetroScreenState createState() => _MetroScreenState();
}

class _MetroScreenState extends State<MetroScreen> with TickerProviderStateMixin {
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
                          SliverList(
                            delegate: SliverChildListDelegate([
                              AppConfig.purchase_code == "" ? PiratedWidget(homeData: homeData) : SizedBox(),
                              SizedBox(height: 10),

                              // Header Banner
                              HomeCarouselSlider(homeData: homeData, context: context),
                              SizedBox(height: 16),

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
                                        padding: const EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
                                        child: Text(AppLocalizations.of(context)!.flash_sale, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                                      ),
                                       Image.asset("assets/flash_deal.png", height: 20, color: MyTheme.golden),
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
                                        color: Colors.grey.withOpacity(0.5),
                                        spreadRadius: 5,
                                        blurRadius: 7,
                                        offset: Offset(0, 3), // changes position of shadow
                                  )],
                                    color:  const Color.fromARGB(255, 249, 248, 248),
                                    borderRadius: BorderRadius.circular(8.0),

                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(5),
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
                                    ),
                                  )),
                              ),

                              ],
                            ]),
                          ),
                       
                            //move banner 

//SliverList(delegate: SliverChildListDelegate([InkWell(onTap: (){},child: Container()),HomeBannerOne(homeData: homeData),])),

                          SliverList(
                            delegate: SliverChildListDelegate(
                              [
                                //PhotoWidget('banners-four'),
                                //const PhotoWidget2(),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                  child: Image.network("https://devefinance.com/public/uploads/all/Ryto4mRZFjxR8INkhLs1DFyX6eoamXKIxXEDFBZM.png"),
                                ),
                                 TodaysDealProductsWidget(homePresenter: homeData,),
                              ]
                            ),
                          ),

                          if(homeData.isCategoryInitial || homeData.featuredCategoryList.isNotEmpty)...[
                            SliverList(
                              delegate: SliverChildListDelegate([
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(20.0, 10.0, 18.0, 0.0),
                                  child: Text(
                                    AppLocalizations.of(context)!.featured_categories_ucf,
                                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                                  ),
                                ),
                              ]),
                            ),
                            SliverToBoxAdapter(
                              child: SizedBox(
                                height: 175,
                                child: FeaturedCategoriesWidget(homeData: homeData),
                              ),
                            ),
                          ],

                         

                          const SliverToBoxAdapter(child: PhotoWidget('banners-one')),

                          if(homeData.isFeaturedProductInitial || homeData.featuredProductList.isNotEmpty)
                            SliverList(
                              delegate: SliverChildListDelegate([
                                Container(
                                  height: 305,
                                  margin: EdgeInsets.only(top: 12),
                                  color: MyTheme.accent_color.withOpacity(0.1),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsetsDirectional.only(top: 20, start: 20),
                                        child: GestureDetector(
                                      //    onTap:(){ Navigator.of(context).push(MaterialPageRoute(builder: (context) => Flexible(child: FeaturedProductVerticalListWidget(homeData: homeData))));},
                                          child: Text(
                                            AppLocalizations.of(context)!.featured_products_ucf,
                                            style: TextStyle(
                                              color: Color(0xff000000),
                                              fontSize: 18,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          
                                          ),
                                        ),
                                      ),
                                      Flexible(child: FeaturedProductHorizontalListWidget(homeData: homeData)), //TODO:# FeaturedPoductHorizontalList
                                    ],
                                  ),
                                ),
                              ]),
                            ),
                            //photo
                            const SliverToBoxAdapter(child: PhotoWidget('banners-two')),

                            //Best Selling
                           // if(homeData.isFeaturedProductInitial || homeData.featuredProductList.isNotEmpty)
                            SliverList(
                              delegate: SliverChildListDelegate([
                                Container(
                                  height: 305,
                                  margin: EdgeInsets.only(top: 12),
                                  color: MyTheme.accent_color.withOpacity(0.1),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsetsDirectional.only(top: 20, start: 20,bottom: 10),
                                        child: Text(
                                          AppLocalizations.of(context)!.best_selling,
                                         // AppLocalizations.of(context)!.featured_products_ucf,
                                          style: TextStyle(
                                            color: Color(0xff000000),
                                            fontSize: 18,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                      Flexible(child: BestSellingProductsWidget(
                                                isVertical: false,
                                                products: homeData.bestSellingProductList,
                                                       )       ), //TODO:# bestSellingWidget
                                    ],
                                  ),
                                ),
                              ]),
                            ),
                                                        SliverList(
                              delegate: SliverChildListDelegate([
                                Container(
                                  height: 305,
                                  margin: EdgeInsets.only(top: 12),
                                  color: MyTheme.accent_color.withOpacity(0.1),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsetsDirectional.only(top: 20, start: 20,bottom: 10),
                                        child: Text(
                                          AppLocalizations.of(context)!.new_products,
                                         // AppLocalizations.of(context)!.featured_products_ucf,
                                          style: TextStyle(
                                            color: Color(0xff000000),
                                            fontSize: 18,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                      Flexible(child:FeaturedProductHorizontalListWidget(homeData: homeData)), //TODO:# FeaturedProductHorizontalListWidget
                                    ],
                                  ),
                                ),
                              ]),
                            ),

const SliverToBoxAdapter(child: PhotoWidget('banners-three')),
//auction products
SliverList(
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
                                            padding: const EdgeInsetsDirectional.only( bottom: 10),
                                            child: Container(
                                              child: Container(
                                              //  color: Colors.black,
                                                width:double.infinity ,
                                                child: Text(
                                                  AppLocalizations.of(context)!.auction_product_ucf,
                                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                                                ),
                                              ),
                                            ),
                                          ),
                                      const    PhotoWidget('banners-two'),
                                        ],
                                      ),
                                    ),
                                    AuctionProductsListWidget(products: homeData.auctionProductList,) //TODO:# AuctionProductList
                                  ],
                                ),
                              ),
                            ]),
                          ),
                          if(homeData.isBrandsInitial || homeData.brandsList.isNotEmpty)
                          SliverList(
                            delegate: SliverChildListDelegate([
                              Padding(
                                  padding: const EdgeInsetsDirectional.only(top: 20, start: 20,bottom: 10),
                                  child: GestureDetector(
                                    onTap: (){
                                      Navigator.push(context, MaterialPageRoute(builder: (context) {
                                        return Filter(selected_filter: "brands");
                                      }));
                                    },
                                    child: Text(
                                      AppLocalizations.of(context)!.top_brands_ucf,
                                     // AppLocalizations.of(context)!.featured_products_ucf,
                                      style: TextStyle(
                                        color: Color(0xff000000),
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ),
                            BrandListWidget(homePresenter: homeData,), //TODO:# BrandListWidget
                            ]),
                          ),
//new products ------------
                          SliverList(
                            delegate: SliverChildListDelegate([
                              SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(18.0, 20, 20.0, 0.0),
                                      child: Text(
                                        AppLocalizations.of(context)!.all_products_ucf,
                                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                                      ),
                                    ),
                                    HomeAllProducts2(context: context, homeData: homeData),
                                  ],
                                ),
                              ),
                            ]),
                          ),
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
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => Filter()));
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

  Widget timerCircularContainer(int currentValue, int totalValue, String timeText) {
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: 30,
          height: 30,
          child: CircularProgressIndicator(
            value: currentValue / totalValue,
            backgroundColor: const Color.fromARGB(255, 240, 220, 220),
            valueColor: AlwaysStoppedAnimation<Color>(
                const Color.fromARGB(255, 255, 80, 80)),
            strokeWidth: 4.0,
            strokeCap: StrokeCap.round,
          ),
        ),
        Text(
          timeText,
          style: TextStyle(
            color: const Color.fromARGB(228, 218, 29, 29),
            fontSize: 10.0,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
  

  Widget buildTimerRow(CurrentRemainingTime time) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
      child: Row(
        children: [
          Spacer(),

          Column(
            children: [
              timerCircularContainer(time.days, 365, timeText((time.days).toString(), default_length: 3)),
              SizedBox(height: 5),
              Text(LangText(context).local.days, style: TextStyle(color: Colors.grey, fontSize: 10))
            ],
          ),
          SizedBox(width: 12),
          Column(
            children: [
              timerCircularContainer(time.hours, 24, timeText((time.hours).toString(), default_length: 2)),
              SizedBox(height: 5),
              Text(LangText(context).local.hours, style: TextStyle(color: Colors.grey, fontSize: 10))
            ],
          ),
          SizedBox(width: 10),
          Column(
            children: [
              timerCircularContainer(time.min, 60, timeText((time.min).toString(), default_length: 2)),
              SizedBox(height: 5),
              Text(LangText(context).local.minutes, style: TextStyle(color: Colors.grey, fontSize: 10))
            ],
          ),
          SizedBox(width: 5),
          Column(
            children: [
              timerCircularContainer(time.sec, 60, timeText((time.sec).toString(), default_length: 2)),
              SizedBox(height: 5),
              Text(LangText(context).local.seconds, style: TextStyle(color: Colors.grey, fontSize: 10))
            ],
          ),
          SizedBox(width: 10),
          Column(
            children: [
            ///  Image.asset("assets/flash_deal.png", height: 20, color: MyTheme.golden),
              SizedBox(height: 12),
            ],
          ),
          Row(
            children: [
              Text(LangText(context).local.shop_more_ucf, style: TextStyle(fontSize: 10, color: Color(0xffA8AFB3))),
              SizedBox(width: 3),
              Icon(Icons.arrow_forward_outlined, size: 10, color: MyTheme.grey_153),
              SizedBox(width: 10),
            ],
          )
        ],
      ),
    );
  }

  String timeText(String val, {int default_length = 2}) {
    return val.padLeft(default_length, '0');
  }
}

