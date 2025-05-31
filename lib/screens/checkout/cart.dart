import 'package:active_ecommerce_cms_demo_app/custom/btn.dart';
import 'package:active_ecommerce_cms_demo_app/custom/text_styles.dart';
import 'package:active_ecommerce_cms_demo_app/custom/useful_elements.dart';
import 'package:active_ecommerce_cms_demo_app/helpers/shared_value_helper.dart';
import 'package:active_ecommerce_cms_demo_app/helpers/shimmer_helper.dart';
import 'package:active_ecommerce_cms_demo_app/helpers/system_config.dart';
import 'package:active_ecommerce_cms_demo_app/my_theme.dart';
import 'package:active_ecommerce_cms_demo_app/presenter/cart_counter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../../app_config.dart';
import '../../custom/cart_seller_item_list_widget.dart';
import '../../custom/lang_text.dart';
import '../../presenter/cart_provider.dart';

class Cart extends StatelessWidget {
  const Cart(
      {Key? key,
      this.has_bottomnav,
      this.from_navigation = false,
      this.counter})
      : super(key: key);
  final bool? has_bottomnav;
  final bool from_navigation;
  final CartCounter? counter;

  @override
  Widget build(BuildContext context) {
    return _Cart(
      counter: counter,
      from_navigation: from_navigation,
      has_bottomnav: has_bottomnav,
    );
  }
}

class _Cart extends StatefulWidget {
  const _Cart(
      {Key? key,
      this.has_bottomnav,
      this.from_navigation = false,
      this.counter})
      : super(key: key);
  final bool? has_bottomnav;
  final bool from_navigation;
  final CartCounter? counter;

  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<_Cart> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CartProvider>(context, listen: false).initState(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(builder: (context, cartProvider, _) {
      final double progress = (cartProvider.cartTotal /
              AppConfig.businessSettingsData.minimumOrderAmount)
          .clamp(0.0, 1.0);
      final int currentQuantity =
          cartProvider.shopList.firstOrNull?.cartItems?.length ?? 0;
      final int minQuantity =
          AppConfig.businessSettingsData.minimumOrderQuantity;
      final double quantityProgress =
          (currentQuantity / minQuantity).clamp(0.0, 1.0);
      return Scaffold(
        key: cartProvider.scaffoldKey,
        backgroundColor: MyTheme.mainColor,
        appBar: buildAppBar(context),
        body: Stack(
          children: [
            RefreshIndicator(
              color: Theme.of(context).primaryColor,
              backgroundColor: Colors.white,
              onRefresh: () => cartProvider.onRefresh(context),
              displacement: 0,
              child: CustomScrollView(
                controller: cartProvider.mainScrollController,
                physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics()),
                slivers: [
                  SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        // AnimatedContainer(
                        //   duration: const Duration(milliseconds: 300),
                        //   height:
                        //       cartProvider.isMinOrderQuantityNotEnough ? 25 : 0,
                        //   width: double.maxFinite,
                        //   padding: const EdgeInsets.symmetric(
                        //       horizontal: 20, vertical: 3),
                        //   color: Theme.of(context).primaryColor,
                        //   child: FittedBox(
                        //     fit: BoxFit.scaleDown,
                        //     child: RichText(
                        //       text: TextSpan(
                        //           style: const TextStyle(color: Colors.white),
                        //           children: [
                        //             TextSpan(
                        //                 text:
                        //                     '${LangText(context).local.minimum_order_qty_is} ${AppConfig.businessSettingsData.minimumOrderQuantity} , '),
                        //             TextSpan(
                        //                 text:
                        //                     LangText(context).local.remaining),
                        //             TextSpan(
                        //                 text:
                        //                     ' ${AppConfig.businessSettingsData.minimumOrderQuantity - (cartProvider.shopList.firstOrNull?.cartItems?.length ?? 0)} '),
                        //           ]),
                        //     ),
                        //   ),
                        // ),
                        // AnimatedContainer(
                        //   duration: const Duration(milliseconds: 300),
                        //   height:
                        //       cartProvider.isMinOrderAmountNotEnough ? 25 : 0,
                        //   width: double.maxFinite,
                        //   padding: const EdgeInsets.symmetric(
                        //       horizontal: 20, vertical: 3),
                        //   color: Theme.of(context).primaryColor,
                        //   child: FittedBox(
                        //     fit: BoxFit.scaleDown,
                        //     child: RichText(
                        //       text: TextSpan(
                        //           style: const TextStyle(color: Colors.white),
                        //           children: [
                        //             TextSpan(
                        //                 text:
                        //                     '${LangText(context).local.minimum_order_amount_is} ${AppConfig.businessSettingsData.minimumOrderAmount} , '),
                        //             TextSpan(
                        //                 text:
                        //                     LangText(context).local.remaining),
                        //             TextSpan(
                        //                 text:
                        //                     ' ${AppConfig.businessSettingsData.minimumOrderAmount - cartProvider.cartTotal} '),
                        //           ]),
                        //     ),
                        //   ),
                        // ),
                        // const SizedBox(height: 30),
                        Visibility(
                          visible: !cartProvider.isInitial && progress < 1.0,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: AppDimensions.paddingLarge),
                            child: Column(
                              children: [
                                Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    LinearProgressIndicator(
                                        value: (cartProvider.cartTotal /
                                                AppConfig.businessSettingsData
                                                    .minimumOrderAmount)
                                            .clamp(0.0, 1.0),
                                        minHeight: 20,
                                        backgroundColor: Colors.grey[300],
                                        color: Theme.of(context).primaryColor),
                                    Text(
                                      '${((cartProvider.cartTotal / AppConfig.businessSettingsData.minimumOrderAmount) * 100).clamp(0, 100).toStringAsFixed(0)}%',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                RichText(
                                  text: TextSpan(
                                      style:
                                          const TextStyle(color: Colors.black),
                                      children: [
                                        TextSpan(
                                            text:
                                                '${LangText(context).local.minimum_order_amount_is} ${AppConfig.businessSettingsData.minimumOrderAmount} , '),
                                        TextSpan(
                                            text: LangText(context)
                                                .local
                                                .remaining),
                                        TextSpan(
                                            text:
                                                ' ${AppConfig.businessSettingsData.minimumOrderAmount - cartProvider.cartTotal} '),
                                      ]),
                                )
                              ],
                            ),
                          ),
                        ),
                        if (!cartProvider.isInitial && quantityProgress < 1.0) ...[
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                LinearProgressIndicator(
                                  value: quantityProgress,
                                  minHeight: 20,
                                  backgroundColor: Colors.grey[300],
                                  color: Theme.of(context).primaryColor,
                                ),
                                Text(
                                  '${(quantityProgress * 100).toStringAsFixed(0)}%',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: AppDimensions.paddingVeryExtraLarge,
                                vertical: AppDimensions.paddingSmall),
                            child: FittedBox(
                              child: RichText(
                                text: TextSpan(
                                  style: const TextStyle(color: Colors.black),
                                  children: [
                                    TextSpan(
                                        text:
                                            '${LangText(context).local.minimum_order_qty_is} ${AppConfig.businessSettingsData.minimumOrderQuantity} , '),
                                    TextSpan(
                                        text:
                                            LangText(context).local.remaining),
                                    TextSpan(
                                        text:
                                            ' ${AppConfig.businessSettingsData.minimumOrderQuantity - currentQuantity} '),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                          child: buildCartSellerList(cartProvider, context),
                        ),
                        SizedBox(height: widget.has_bottomnav! ? 140 : 100),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: buildBottomContainer(cartProvider),
            )
          ],
        ),
      );
    });
  }

  Container buildBottomContainer(CartProvider cartProvider) {
    return Container(
      decoration: const BoxDecoration(
        color: MyTheme.mainColor,
      ),

      height: widget.has_bottomnav! ? 200 : 120,
      //color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 4),
        child: Column(
          children: [
            Container(
              height: 40,
              width: double.infinity,
              decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.circular(AppDimensions.radiusHalfSmall),
                  color: MyTheme.soft_accent_color),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text(
                      AppLocalizations.of(context)!.total_amount_ucf,
                      style: TextStyle(
                          color: MyTheme.dark_font_grey,
                          fontSize: 13,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(cartProvider.cartTotalString,
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w600)),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.only(top: AppDimensions.paddingSmall),
                  child: Container(
                    height: 58,
                    width: (MediaQuery.of(context).size.width - 48),
                    // width: (MediaQuery.of(context).size.width - 48) * (2 / 3),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                          color: Theme.of(context).primaryColor, width: 1),
                      borderRadius: app_language_rtl.$!
                          ? const BorderRadius.only(
                              topLeft: Radius.circular(
                                  AppDimensions.radiusHalfSmall),
                              bottomLeft: Radius.circular(
                                  AppDimensions.radiusHalfSmall),
                              topRight: Radius.circular(
                                  AppDimensions.radiusHalfSmall),
                              bottomRight: Radius.circular(
                                  AppDimensions.radiusHalfSmall),
                            )
                          : const BorderRadius.only(
                              topLeft: Radius.circular(
                                  AppDimensions.radiusHalfSmall),
                              bottomLeft: Radius.circular(
                                  AppDimensions.radiusHalfSmall),
                              topRight: Radius.circular(
                                  AppDimensions.radiusHalfSmall),
                              bottomRight: Radius.circular(
                                  AppDimensions.radiusHalfSmall),
                            ),
                    ),
                    child: Btn.basic(
                      minWidth: MediaQuery.of(context).size.width,
                      color: Theme.of(context).primaryColor,
                      shape: app_language_rtl.$!
                          ? const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(
                                    AppDimensions.radiusHalfSmall),
                                bottomLeft: Radius.circular(
                                    AppDimensions.radiusHalfSmall),
                                topRight: Radius.circular(0.0),
                                bottomRight: Radius.circular(0.0),
                              ),
                            )
                          : const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(0.0),
                                bottomLeft: Radius.circular(0.0),
                                topRight: Radius.circular(
                                    AppDimensions.radiusHalfSmall),
                                bottomRight: Radius.circular(
                                    AppDimensions.radiusHalfSmall),
                              ),
                            ),
                      child: Text(
                        AppLocalizations.of(context)!.proceed_to_shipping_ucf,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w700),
                      ),
                      onPressed: () {
                        cartProvider.onPressProceedToShipping(context);
                      },
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: MyTheme.mainColor,
      leading: Builder(
        builder: (context) => widget.from_navigation
            ? UsefulElements.backToMain(go_back: false)
            : UsefulElements.backButton(),
      ),
      centerTitle: widget.from_navigation,
      title: Text(
        AppLocalizations.of(context)!.shopping_cart_ucf,
        style: TextStyles.buildAppBarTexStyle(),
      ),
      elevation: 0.0,
      titleSpacing: 0,
      scrolledUnderElevation: 0.0,
    );
  }

  Widget? buildCartSellerList(cartProvider, context) {
    if (cartProvider.isInitial && cartProvider.shopList.length == 0) {
      return SingleChildScrollView(
          child: ShimmerHelper()
              .buildListShimmer(item_count: 5, item_height: 100.0));
    } else if (cartProvider.shopList.length > 0) {
      return SingleChildScrollView(
        child: ListView.separated(
          separatorBuilder: (context, index) => const SizedBox(
            height: 26,
          ),
          itemCount: cartProvider.shopList.length,
          scrollDirection: Axis.vertical,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      bottom: AppDimensions.paddingNormal),
                  child: Row(
                    children: [
                      Text(
                        cartProvider.shopList[index].name,
                        style: TextStyle(
                            color: MyTheme.dark_font_grey,
                            fontWeight: FontWeight.bold,
                            fontSize: 12),
                      ),
                      const Spacer(),
                      Text(
                        cartProvider.shopList[index].subTotal.replaceAll(
                                SystemConfig.systemCurrency!.code,
                                SystemConfig.systemCurrency!.symbol) ??
                            '',
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 12),
                      ),
                    ],
                  ),
                ),
                CartSellerItemListWidget(
                  sellerIndex: index,
                  cartProvider: cartProvider,
                  context: context,
                ),
              ],
            );
          },
        ),
      );
    } else if (!cartProvider.isInitial && cartProvider.shopList.length == 0) {
      return Container(
          height: 100,
          child: Center(
              child: Text(
            AppLocalizations.of(context)!.cart_is_empty,
            style: const TextStyle(color: MyTheme.font_grey),
          )));
    }
    return null;
  }
}
