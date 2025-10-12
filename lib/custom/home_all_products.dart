import 'dart:collection';

import 'package:active_ecommerce_cms_demo_app/constants/app_dimensions.dart';
import 'package:active_ecommerce_cms_demo_app/locale/custom_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data_model/product_mini_response.dart';
import '../helpers/shimmer_helper.dart';
import '../presenter/home_provider.dart';
import '../ui_elements/product_card.dart';

class HomeAllProducts extends StatelessWidget {
  const HomeAllProducts({super.key});

  @override
  Widget build(BuildContext context) {
    final ({
      UnmodifiableListView<Product> allProductList,
      bool isAllProductInitial,
      int totalAllProductData
    }) p = context.select<
        HomeProvider,
        ({
          bool isAllProductInitial,
          UnmodifiableListView<Product> allProductList,
          int totalAllProductData
        })>(
      (provider) => (
        allProductList: UnmodifiableListView(provider.allProductList),
        isAllProductInitial: provider.isAllProductInitial,
        totalAllProductData: provider.totalAllProductData
      ),
    );
    if (p.isAllProductInitial && p.allProductList.isEmpty) {
      return SingleChildScrollView(
        child: ShimmerHelper().buildProductGridShimmer(),
      );
    } else if (p.allProductList.isNotEmpty) {
      //snapshot.hasData

      return GridView.builder(
        // 2
        //addAutomaticKeepAlives: true,
        itemCount: p.allProductList.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 0.618),
        padding: const EdgeInsets.all(AppDimensions.paddingDefault),
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (context, index) {
          // 3
          return ProductCard(
            id: p.allProductList[index].id,
            slug: p.allProductList[index].slug ?? '',
            image: p.allProductList[index].thumbnail_image,
            name: p.allProductList[index].name,
            main_price: p.allProductList[index].main_price,
            stroked_price: p.allProductList[index].stroked_price,
            has_discount: p.allProductList[index].has_discount == true,
            discount: p.allProductList[index].discount,
            isWholesale: null,
          );
        },
      );
    } else if (p.totalAllProductData == 0) {
      return Center(
          child: Text('no_product_is_available'.tr(context: context)));
    } else {
      return Container(); // should never be happening
    }
  }
}
