import 'dart:async';
import 'package:active_ecommerce_cms_demo_app/custom/lang_text.dart';
import 'package:active_ecommerce_cms_demo_app/custom/toast_component.dart';
import 'package:active_ecommerce_cms_demo_app/data_model/brand_response.dart';
import 'package:active_ecommerce_cms_demo_app/data_model/flash_deal_response.dart';
import 'package:active_ecommerce_cms_demo_app/data_model/product_mini_response.dart' as productMini;
import 'package:active_ecommerce_cms_demo_app/data_model/slider_response.dart';
import 'package:active_ecommerce_cms_demo_app/repositories/auction_products_repository.dart';
import 'package:active_ecommerce_cms_demo_app/repositories/brand_repository.dart';
import 'package:active_ecommerce_cms_demo_app/repositories/category_repository.dart';
import 'package:active_ecommerce_cms_demo_app/repositories/flash_deal_repository.dart';
import 'package:active_ecommerce_cms_demo_app/repositories/product_repository.dart';
import 'package:active_ecommerce_cms_demo_app/repositories/sliders_repository.dart';

import 'package:active_ecommerce_cms_demo_app/single_banner/model.dart';
import 'package:flutter/material.dart';

class HomePresenter extends ChangeNotifier {
  CurrentRemainingTime flashDealRemainingTime =
      CurrentRemainingTime(days: 0, hours: 0, min: 0, sec: 0);
  FlashDealResponseDatum? flashDeal;

  Timer? _flashDealTimer;
  DateTime? _flashDealEndTime;

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  int current_slider = 0;
  ScrollController? allProductScrollController;
  ScrollController? featuredCategoryScrollController;
  ScrollController mainScrollController = ScrollController();

  late AnimationController pirated_logo_controller;
  late Animation pirated_logo_animation;
 


  List<AIZSlider> carouselImageList = [];
  List<AIZSlider> bannerOneImageList = [];
  List<AIZSlider> flashDealBannerImageList = [];
  List<FlashDealResponseDatum> _banners = [];
  List<FlashDealResponseDatum> get banners => [..._banners];
  List<productMini.Product> bestSellingProductList = [];
  List<productMini.Product> auctionProductList = [];
  List<Brands> brandsList = [];
  List<productMini.Product> TodayDealList=[];



  List<SingleBanner> _singleBanner = [];
  List<SingleBanner> get singleBanner => _singleBanner;

  var bannerTwoImageList = [];
  var featuredCategoryList = [];

  bool isCategoryInitial = true;
  bool isCarouselInitial = true;
  bool isBannerOneInitial = true;
  bool isFlashDealInitial = true;
  bool isBannerTwoInitial = true;
  bool isBannerFlashDeal = true;
  bool isBrandsInitial = true;
  bool isTodayDwal=true;


bool isBestSellingProductInitial=true;
int? totalBestSellingProductData;
bool showBestSellingLoadingContainer = false;

bool isauctionProductInitial=true;
int? totalauctionProductData;
int bestauctionroductPage = 1;
bool showauctionLoadingContainer = false;


bool isTodayDealInitial=true;
int? totalatodayDealData;
int todayDealPage = 1;
bool showTodayDealContainer = false;

  var featuredProductList = [];
  bool isFeaturedProductInitial = true;
  int? totalFeaturedProductData = 0;
  int featuredProductPage = 1;
  bool showFeaturedLoadingContainer = false;

  bool isTodayDeal = false;
  bool isFlashDeal = false;

  bool isBrands = false;

  var allProductList = [];
  bool isAllProductInitial = true;
  int? totalAllProductData = 0;
  int allProductPage = 1;
  bool showAllLoadingContainer = false;
  int cartCount = 0;

  fetchAll() {
    fetchCarouselImages();
    fetchBannerOneImages();
    fetchBannerTwoImages();
    fetchFeaturedCategories();
    fetchFeaturedProducts();
    fetchAllProducts();
    fetchTodayDealData();
    fetchFlashDealData();
    fetchBannerFlashDeal();
    fetchFlashDealBannerImages();
    fetchBrands();
    fetchBestSellingProducts();
    fetchAuctionProducts();
    fetchBrandsProducts();
    fetchTodayDealProducts();
  }

  void fetchBrands() {
    BrandRepository().getBrands().then((value) {
      isBrands = !value.noBrandsAvailable;
      notifyListeners();
    },);
  }



  Future<void> fetchBannerFlashDeal() async {
    try {
      final banners = await SlidersRepository().fetchBanners();
      _banners = banners;
      notifyListeners();
    } catch (e) {
      print('Error loading banners: $e');
    }
  }

  fetchTodayDealData() async {
    var deal = await ProductRepository().getTodaysDealProducts();
    // print(deal.products!.length);
    // if (deal.success! && deal.products!.isNotEmpty) {
    //   isTodayDeal = true;
    //   notifyListeners();
    // }
    if (deal.success == true &&
        deal.products != null &&
        deal.products!.isNotEmpty) {
      isTodayDeal = true;
      notifyListeners();
    } else {
      isTodayDeal = false;
    }
  }
  

  fetchFlashDealData() async {
    FlashDealResponse deal = await FlashDealRepository().getFlashDeals();

    if (deal.success == true &&
        deal.flashDeals != null &&
        deal.flashDeals!.isNotEmpty) {
      isFlashDeal = true;
      _banners.clear();
      _banners.addAll(deal.flashDeals!);
      FlashDealResponseDatum? tempFlashDeal;
      for (FlashDealResponseDatum e in deal.flashDeals!) {
        if(e.isFeatured){
          tempFlashDeal = e;
          break;
        }
      }
      flashDeal = tempFlashDeal;

      if (flashDeal?.date != null) {
        DateTime end = DateTime.fromMillisecondsSinceEpoch(flashDeal!.date! * 1000);
        DateTime now = DateTime.now();
        int diff = end.difference(now).inMilliseconds;
        int endTime = diff + now.millisecondsSinceEpoch;
        startFlashDealCountdown(endTime);

      }

      notifyListeners();
    } else {
      isFlashDeal = false;
    }
  }

  void startFlashDealCountdown(int endTime,) {
  _flashDealEndTime = DateTime.fromMillisecondsSinceEpoch(endTime);

    _flashDealTimer?.cancel();
    _flashDealTimer = Timer.periodic(Duration(seconds: 1), (_) {
      final now = DateTime.now();
         final remaining = _flashDealEndTime!.difference(now);

    if (remaining.isNegative) {
      _flashDealTimer?.cancel();
      flashDealRemainingTime = CurrentRemainingTime(days: 0, hours: 0, min: 0, sec: 0);
      isFlashDeal = false;
      notifyListeners();
      return;
    }

    flashDealRemainingTime = CurrentRemainingTime(
      days: remaining.inDays,
      hours: remaining.inHours % 24,
      min: remaining.inMinutes % 60,
      sec: remaining.inSeconds % 60,
    );

    notifyListeners();
  });
      //   // flashDealRemainingTime = CurrentRemainingTime(
      //   //   days: remaining.inDays,
      //   //   hours: remaining.inHours % 24,
      //   //   min: remaining.inMinutes % 60,
      //   //   sec: remaining.inSeconds % 60,
      //   // );
      // }
      notifyListeners();
    
  }
fetchCarouselImages() async {
  SliderResponse carouselResponse = await SlidersRepository().getSliders();
  carouselImageList.clear();
  carouselImageList.addAll(carouselResponse.sliders!);
  isCarouselInitial = false;
  notifyListeners();
}

  fetchBestSellingProducts() async {
    final productMini.ProductMiniResponse bestselling = await ProductRepository().getBestSellingProducts();
    bestSellingProductList.clear();
    bestSellingProductList.addAll(bestselling.products!);
    isBestSellingProductInitial = false;
    notifyListeners();
  }
    fetchAuctionProducts() async {
    final productMini.ProductMiniResponse auction = await AuctionProductsRepository().getAuctionProducts(page:1);
    auctionProductList.clear();
    auctionProductList.addAll(auction.products!);
    isauctionProductInitial = false;
    notifyListeners();
  }
  fetchBrandsProducts() async {
    final BrandResponse brands = await BrandRepository().getBrands();
    brandsList.clear();
    brandsList.addAll(brands.brands!);
    isBrandsInitial = false;
    notifyListeners();
  }
   fetchTodayDealProducts() async {
    try{
    final productMini.ProductMiniResponse deals = await ProductRepository().getTodaysDealProducts();
    TodayDealList.clear();
    TodayDealList.addAll(deals.products!);
    isTodayDealInitial = false;
    notifyListeners();
     } catch (e) {
     

    print("Error details: $e");
    }
  }


  fetchBannerOneImages() async {
    var bannerOneResponse = await SlidersRepository().getBannerOneImages();
    bannerOneImageList.clear();
    bannerOneImageList.addAll(bannerOneResponse.sliders!);
    isBannerOneInitial = false;
    notifyListeners();
  }

  fetchFlashDealBannerImages() async {
    try {
      var flashDealBannerResponse =
          await SlidersRepository().getFlashDealBanner();
      flashDealBannerImageList.clear();
      flashDealBannerImageList.addAll(flashDealBannerResponse.sliders!);
      isFlashDealInitial = false;
      notifyListeners();
    } catch (e) {
      print('Error fetching flash deal banners: $e');
    }
  }

  fetchBannerTwoImages() async {
    var bannerTwoResponse = await SlidersRepository().getBannerTwoImages();
    bannerTwoImageList.addAll(bannerTwoResponse.sliders!);
    isBannerTwoInitial = false;
    notifyListeners();
  }

  fetchFeaturedCategories() async {
    var categoryResponse = await CategoryRepository().getFeturedCategories();
    featuredCategoryList.clear();
    featuredCategoryList.addAll(categoryResponse.categories!);
    isCategoryInitial = false;
    notifyListeners();
  }

  fetchFeaturedProducts() async {
    try {
      var productResponse = await ProductRepository().getFeaturedProducts(
        page: featuredProductPage,
      );

      featuredProductPage++;

      if (productResponse.products != null) {
        featuredProductList.addAll(productResponse.products!);
      }

      isFeaturedProductInitial = false;

      if (productResponse.meta != null) {
        totalFeaturedProductData = productResponse.meta!.total;
      }

      showFeaturedLoadingContainer = false;
      notifyListeners();
    } catch (e) {}
  }

  fetchAllProducts() async {
    var productResponse =
        await ProductRepository().getFilteredProducts(page: allProductPage);
    if (productResponse.products != null) {
      allProductList.addAll(productResponse.products!);
    }
    isAllProductInitial = false;
    if (productResponse.meta != null) {
      totalAllProductData = productResponse.meta!.total;
    }
    showAllLoadingContainer = false;
    notifyListeners();
  }
resetBestSellingProducts() {
  bestSellingProductList.clear();
  isBestSellingProductInitial = true;
  totalBestSellingProductData = 0;
  showBestSellingLoadingContainer = false;
}
resetAuctionProducts() {
  auctionProductList.clear();
  isauctionProductInitial = true;
  bestauctionroductPage = 1;
  totalauctionProductData = 0;
  showauctionLoadingContainer = false;
}
resetTodayDeals() {
  TodayDealList.clear();
  isTodayDealInitial = true;
  todayDealPage = 1;
  totalatodayDealData = 0;
  showTodayDealContainer = false;
}

  reset() {
    carouselImageList.clear();
    bannerOneImageList.clear();
    bannerTwoImageList.clear();
    featuredCategoryList.clear();

    isCarouselInitial = true;
    isBannerOneInitial = true;
    isBannerTwoInitial = true;
    isCategoryInitial = true;
    cartCount = 0;

    resetFeaturedProductList();
    resetAllProductList();
    flashDealBannerImageList.clear();
    resetBestSellingProducts();
    resetAuctionProducts();
    resetTodayDeals();
  }

  Future<void> onRefresh() async {
    reset();
    fetchAll();
  }

  resetFeaturedProductList() {
    featuredProductList.clear();
    isFeaturedProductInitial = true;
    totalFeaturedProductData = 0;
    featuredProductPage = 1;
    showFeaturedLoadingContainer = false;
    notifyListeners();
  }

  resetAllProductList() {
    allProductList.clear();
    isAllProductInitial = true;
    totalAllProductData = 0;
    allProductPage = 1;
    showAllLoadingContainer = false;
    notifyListeners();
  }

  mainScrollListener(BuildContext context) {
    mainScrollController.addListener(() {
      if (mainScrollController.positions.isNotEmpty &&
          mainScrollController.positions.first.pixels ==
              mainScrollController.positions.first.maxScrollExtent) {
        allProductPage++;
        ToastComponent.showDialog(LangText(context).local.loading_more_products_ucf);
        showAllLoadingContainer = true;
        fetchAllProducts();
      }
    });
  }

  initPiratedAnimation(vnc) {
    pirated_logo_controller =
        AnimationController(vsync: vnc, duration: Duration(milliseconds: 2000));
    pirated_logo_animation = Tween(begin: 40.0, end: 60.0).animate(
      CurvedAnimation(
        curve: Curves.bounceOut,
        parent: pirated_logo_controller,
      ),
    );

    pirated_logo_controller.addStatusListener((AnimationStatus status) {
      if (status == AnimationStatus.completed) {
        pirated_logo_controller.repeat();
      }
    });

    pirated_logo_controller.forward();
  }

  incrementCurrentSlider(index) {
    current_slider = index;
    notifyListeners();
  }

  @override
  void dispose() {
    pirated_logo_controller.dispose();
    _flashDealTimer?.cancel();
    super.dispose();
  }
}

class CurrentRemainingTime {
  final int days;
  final int hours;
  final int min;
  final int sec;

  CurrentRemainingTime({
    required this.days,
    required this.hours,
    required this.min,
    required this.sec,
  });
}