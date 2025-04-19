import 'package:active_ecommerce_cms_demo_app/data_model/brand_response.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../helpers/shimmer_helper.dart';
import '../ui_elements/mini_product_card.dart';

import 'package:active_ecommerce_cms_demo_app/data_model/product_mini_response.dart' as productMini;


class ProductHorizontalListWidget extends StatelessWidget {
  final bool isProductInitial;
  final List <productMini.Product> productList;
  final int numberOfTotalProducts;
  final void Function() onArriveTheEndOfList;
  final TextStyle? priceTextStyle;
  final TextStyle? nameTextStyle;
  const ProductHorizontalListWidget({Key? key, required this.isProductInitial, required this.productList, required this.numberOfTotalProducts,required this.onArriveTheEndOfList, this.priceTextStyle, this.nameTextStyle, List<Brands>? brandtList,})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isProductInitial && productList.isEmpty) {
      return Padding(
        padding: EdgeInsets.only(right: 20,left: 20, top: 15),
        child: Row(
          children: [
            Expanded(
              child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ShimmerHelper().buildBasicShimmer(
                      height: 120.0,
                      width: (MediaQuery.of(context).size.width - 64) / 3)),
            ),
            Expanded(
              child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ShimmerHelper().buildBasicShimmer(
                      height: 120.0,
                      width: (MediaQuery.of(context).size.width - 64) / 3)),
            ),
            Expanded(
              child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ShimmerHelper().buildBasicShimmer(
                      height: 120.0,
                      width: (MediaQuery.of(context).size.width - 160) / 3)),
            ),
          ],
        ),
      );
    } else if (productList.length > 0) {
      return Container(
        // height: 230,
        alignment: Alignment.center,
        child: NotificationListener<ScrollNotification>(
          onNotification: (ScrollNotification scrollInfo) {
            if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
              if(numberOfTotalProducts > productList.length) onArriveTheEndOfList();
            }
            return true;
          },
          child: ListView.separated(
            padding: EdgeInsets.only(right: 20,left: 20, top: 15),
            separatorBuilder: (context, index) => SizedBox(
              width: 12,
            ),
            itemCount:numberOfTotalProducts > productList.length
              ? productList.length + 1
              : productList.length,
            scrollDirection: Axis.horizontal,
            //itemExtent: 135,
                
            physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics()),
            itemBuilder: (context, index) {
              return (index == productList.length)
                  ? SpinKitFadingFour(
                      itemBuilder: (BuildContext context, int index) {
                        return DecoratedBox(
                          decoration: BoxDecoration(
                            color: Colors.white,
                          ),
                        );
                      },
                    )
                  : MiniProductCard(
                      id: productList[index].id,
                      slug: productList[index].slug ?? '',
                      image:
                         productList[index].thumbnail_image,
                      name:productList[index].name,
                      main_price:
                        productList[index].main_price,
                      stroked_price:
                          productList[index].stroked_price,
                      has_discount:
                          productList[index].has_discount,
                      is_wholesale:
                         productList[index].isWholesale,
                      priceTextStyle: priceTextStyle,
                      nameTextStyle: nameTextStyle,
                    );
            },
          ),
        ),
      );
    } else {
      return const SizedBox();
    }
  }
}
