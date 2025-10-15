import 'package:active_ecommerce_cms_demo_app/helpers/shared_value_helper.dart';
import 'package:active_ecommerce_cms_demo_app/main.dart';
import 'package:active_ecommerce_cms_demo_app/presenter/bottom_appbar_index.dart';
import 'package:active_ecommerce_cms_demo_app/presenter/cart_counter.dart';
import 'package:active_ecommerce_cms_demo_app/presenter/home_provider.dart';
import 'package:active_ecommerce_cms_demo_app/screens/auth/login.dart';
import 'package:active_ecommerce_cms_demo_app/screens/category_list_n_product/category_list.dart';
import 'package:active_ecommerce_cms_demo_app/screens/checkout/cart.dart';
import 'package:active_ecommerce_cms_demo_app/screens/profile.dart';
import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:active_ecommerce_cms_demo_app/locale/custom_localization.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../app_config.dart';
import '../presenter/cart_provider.dart';
import '../ui_elements/close_app_dialog_widget.dart';
import 'splash_screen/custom_statusbar.dart';

// import 'home/home_page_type_enum.dart';

class Main extends StatefulWidget {
  const Main({Key? key}) : super(key: key);

  @override
  _MainState createState() => _MainState();
}

class _MainState extends State<Main> {
  int _currentIndex = 0;
  List<Widget> _children = [];
  CartCounter counter = CartCounter();
  BottomAppbarIndex bottomAppbarIndex = BottomAppbarIndex();
  late final HomeProvider homeProvider = context.read<HomeProvider>();

  fetchAll() {
    getCartData();
  }

  int setIndexWhenPrescription(int index) {
    if (showPrescription && index > 1) return index - 1;

    return index;
  }

  int getIndexWhenPrescription(int index) {
    if (showPrescription && index > 1) return index + 1;

    return index;
  }

  void onTapped(int i) {
    if (showPrescription && i == 2) {
      onTapPrescription();
      return;
    }
    fetchAll();

    i = setIndexWhenPrescription(i);

    if (AppConfig.businessSettingsData.guestCheckoutStatus && (i == 2)) {
    } else if (!AppConfig.businessSettingsData.guestCheckoutStatus &&
        (i == 2) &&
        !is_logged_in.$) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const Login()));
      return;
    }

    if (i == 3) {
      routes.push("/dashboard").then(
        (value) async {
          fetchAll();
          await homeProvider.onRefresh();
        },
      );
      return;
    }
    setState(() {
      _currentIndex = getIndexWhenPrescription(i);
    });
  }

  void getCartData() {
    Provider.of<CartProvider>(context, listen: false).fetchData(context);
  }

  @override
  void initState() {
    _children = [
      //   HomePageType.home.screen,
      AppConfig.businessSettingsData.selectedHomePage.screen,
      const CategoryList(
        slug: "",
        name: "",
        is_base_category: true,
      ),
      Cart(
        has_bottomnav: true,
        from_navigation: true,
        counter: counter,
      ),
      const Profile()
    ];
    fetchAll();

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom]);
    super.initState();
  }

  bool _dialogShowing = false;

  Future<bool> willPop() async {
    print(_currentIndex);
    if (_currentIndex != 0) {
      fetchAll();
      setState(() {
        _currentIndex = 0;
      });
    } else {
      if (_dialogShowing) {
        return Future.value(false); // Dialog already showing, don't show again
      }
      setState(() {
        _dialogShowing = true;
      });

      final bool shouldPop = await showDialog<bool?>(
            context: context,
            builder: (_) => const CloseAppDialogWidget(),
          ) ??
          false;

      setState(() {
        _dialogShowing = false; // Reset flag after dialog is closed
      });

      return shouldPop;
    }
    return Future.value(false);
  }

  bool get showPrescription => AppConfig.businessSettingsData.showPrescription;

  @override
  Widget build(BuildContext context) {
    homeProvider.showPopupBanner(context);
    return WillPopScope(
      onWillPop: willPop,
      child: Directionality(
        textDirection:
            app_language_rtl.$! ? TextDirection.rtl : TextDirection.ltr,
        child: Scaffold(
          appBar: customStatusBar(SystemUiOverlayStyle.dark),
          extendBody: true,
          extendBodyBehindAppBar: true,
          body: _children[_currentIndex],
          floatingActionButton: showPrescription
              ? Transform.translate(
                  offset: const Offset(0, 8),
                  child: FloatingActionButton(
                    onPressed: onTapPrescription,
                    child: const FaIcon(FontAwesomeIcons.filePrescription),
                  ),
                )
              : null,
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            onTap: onTapped,
            currentIndex: _currentIndex,
            backgroundColor: Colors.white.withValues(alpha: 0.95),
            unselectedItemColor: const Color.fromRGBO(168, 175, 179, 1),
            selectedItemColor: Theme.of(context).primaryColor,
            selectedLabelStyle: TextStyle(
                fontWeight: FontWeight.w700,
                color: Theme.of(context).primaryColor,
                fontSize: 12),
            unselectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.w400,
              color: Color.fromRGBO(168, 175, 179, 1),
              fontSize: 12,
            ),
            items: [
              BottomNavigationBarItem(
                icon: Padding(
                  padding:
                      const EdgeInsets.only(bottom: AppDimensions.paddingSmall),
                  child: Image.asset(
                    AppImages.home,
                    color: _currentIndex == 0
                        ? Theme.of(context).primaryColor
                        : const Color.fromRGBO(153, 153, 153, 1),
                    height: 16,
                  ),
                ),
                label: 'home_ucf'.tr(context: context),
              ),
              BottomNavigationBarItem(
                  icon: Padding(
                    padding: const EdgeInsets.only(
                      bottom: AppDimensions.paddingSmall,
                    ),
                    child: Image.asset(
                      AppImages.categories,
                      color: _currentIndex == 1
                          ? Theme.of(context).primaryColor
                          : const Color.fromRGBO(153, 153, 153, 1),
                      height: 16,
                    ),
                  ),
                  label: 'categories_ucf'.tr(context: context)),
              if (showPrescription)
                BottomNavigationBarItem(
                  icon: const SizedBox(height: 34),
                  label: 'prescription'.tr(context: context),
                ),
              BottomNavigationBarItem(
                  icon: Padding(
                    padding: const EdgeInsets.only(
                        bottom: AppDimensions.paddingSmall),
                    child: badges.Badge(
                      badgeStyle: badges.BadgeStyle(
                        shape: badges.BadgeShape.circle,
                        badgeColor: Theme.of(context).primaryColor,
                        borderRadius:
                            BorderRadius.circular(AppDimensions.radiusNormal),
                        padding: const EdgeInsets.all(5),
                      ),
                      badgeAnimation: const badges.BadgeAnimation.slide(
                        toAnimate: false,
                      ),
                      child: Image.asset(
                        AppImages.cart,
                        color: _currentIndex == 2
                            ? Theme.of(context).primaryColor
                            : const Color.fromRGBO(153, 153, 153, 1),
                        height: 16,
                      ),
                      badgeContent: Consumer<CartCounter>(
                        builder: (context, cart, child) {
                          return Text(
                            "${cart.cartCounter}",
                            style: const TextStyle(
                                fontSize: 10, color: Colors.white),
                          );
                        },
                      ),
                    ),
                  ),
                  label: 'cart_ucf'.tr(context: context)),
              BottomNavigationBarItem(
                icon: Padding(
                  padding:
                      const EdgeInsets.only(bottom: AppDimensions.paddingSmall),
                  child: Image.asset(
                    AppImages.profile,
                    color: _currentIndex == 3
                        ? Theme.of(context).primaryColor
                        : const Color.fromRGBO(153, 153, 153, 1),
                    height: 16,
                  ),
                ),
                label: 'profile_ucf'.tr(context: context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void onTapPrescription() {
    print("Prescription");
  }
}
