import 'package:active_ecommerce_cms_demo_app/app_config.dart';
import 'package:animated_text_lerp/animated_text_lerp.dart';
import 'package:flutter/material.dart';

import '../helpers/system_config.dart';
import '../my_theme.dart';
import '../presenter/cart_provider.dart';
import '../screens/home/home.dart';
import '../ui_elements/product_card.dart';
import 'box_decorations.dart';
import 'device_info.dart';
import 'home_all_products.dart';

class CartSellerItemCardWidget extends StatelessWidget {
  final int sellerIndex;
  final int itemIndex;
  final CartProvider cartProvider;
  final int index;

  const CartSellerItemCardWidget(
      {Key? key,
      required this.cartProvider,
      required this.sellerIndex,
      required this.itemIndex,
      required this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppDimensions.radiusHalfSmall)),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
                width: DeviceInfo(context).width! / 4,
                height: 120,
                child: ClipRRect(
                    borderRadius: const BorderRadius.horizontal(
                        left: Radius.circular(AppDimensions.radiusHalfSmall),
                        right: Radius.zero),
                    child: FadeInImage.assetNetwork(
                      placeholder: AppImages.placeholder,
                      image: cartProvider.shopList[sellerIndex]
                          .cartItems![itemIndex].productThumbnailImage!,
                      fit: BoxFit.contain,
                    ))),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      cartProvider.shopList[sellerIndex].cartItems![itemIndex]
                          .productName!,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: const TextStyle(
                          color: MyTheme.font_grey,
                          fontSize: 12,
                          fontWeight: FontWeight.w400),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: AppDimensions.paddingLarge),
                      child: Row(
                        children: [
                          Text(
                            cartProvider.shopList[sellerIndex]
                                .cartItems![itemIndex].price!,
                            // cartProvider.shopList[sellerIndex]
                            //     .cartItems![itemIndex].price!,
                            textAlign: TextAlign.left,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          AnimatedNumberText<double>(
                            double.tryParse(
                                  cartProvider.shopList[sellerIndex]
                                      .cartItems![itemIndex].price!
                                      .replaceAll(RegExp('[^0-9.]'), ''),
                                ) ??
                                0.0,
                            duration: const Duration(milliseconds: 500),
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                            formatter: (value) => '${value.toStringAsFixed(2)}',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Column(
              children: [
                 Visibility(
                  visible: cartProvider
                      .shopList[sellerIndex].cartItems![index].isLoading,
                  child: const Padding(
                    padding: const EdgeInsets.all(AppDimensions.paddingSmall),
                    child: SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        
                      ),
                    ),
                  ),
                ),
            
                const Spacer(),
                ////////////////////////////////////////////////
                GestureDetector(
                  onTap: () async {
                    cartProvider.onPressDelete(
                        context,
                        cartProvider
                            .shopList[sellerIndex].cartItems![itemIndex].id
                            .toString(),
                        sellerIndex,
                        itemIndex);
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(
                        bottom: AppDimensions.paddingNormal),
                    child: Image.asset(
                      AppImages.trash,
                      height: 16,
                      color: Colors.red,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(AppDimensions.paddingDefault),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () {
                      if (cartProvider.shopList[sellerIndex]
                              .cartItems![itemIndex].auctionProduct ==
                          0) {
                        cartProvider.onQuantityIncrease(
                            context, sellerIndex, itemIndex);
                      }
                      return;
                    },
                    child: Container(
                      width: 24,
                      height: 24,
                      decoration:
                          BoxDecorations.buildCartCircularButtonDecoration(),
                      child: Icon(
                        Icons.add,
                        color: cartProvider.shopList[sellerIndex]
                                    .cartItems![itemIndex].auctionProduct ==
                                0
                            ? Theme.of(context).primaryColor
                            : MyTheme.grey_153,
                        size: 12,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: AppDimensions.paddingSmall,
                        bottom: AppDimensions.paddingSmall),
                    child: Text(
                      cartProvider
                          .shopList[sellerIndex].cartItems![itemIndex].quantity
                          .toString(),
                      style: TextStyle(
                          color: Theme.of(context).primaryColor, fontSize: 16),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      if (cartProvider.shopList[sellerIndex]
                              .cartItems![itemIndex].auctionProduct ==
                          0) {
                        cartProvider.onQuantityDecrease(
                            context, sellerIndex, itemIndex);
                      }
                      return;
                    },
                    child: Container(
                      width: 24,
                      height: 24,
                      decoration:
                          BoxDecorations.buildCartCircularButtonDecoration(),
                      child: Icon(
                        Icons.remove,
                        color: cartProvider.shopList[sellerIndex]
                                    .cartItems![itemIndex].auctionProduct ==
                                0
                            ? Theme.of(context).primaryColor
                            : MyTheme.grey_153,
                        size: 12,
                      ),
                    ),
                  ),
                ],
              ),
            )
          ]),
    );
  }
}
