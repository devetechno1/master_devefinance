import 'package:active_ecommerce_cms_demo_app/presenter/home_presenter.dart';
import 'package:flutter/material.dart';
import 'package:active_ecommerce_cms_demo_app/locale/custom_localization.dart';

class ProductLoadingcontainer extends StatelessWidget {
  const ProductLoadingcontainer({
    super.key,
    required this.context,
    required this.homeData,
  });

  final BuildContext context;
  final HomePresenter homeData;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: homeData.showAllLoadingContainer ? 36 : 0,
      width: double.infinity,
      color: Colors.white,
      child: Center(
        child: Text(
          homeData.totalAllProductData == homeData.allProductList.length
              ? 'no_more_products_ucf'.tr(context: context)
              : 'loading_more_products_ucf'.tr(context: context),
        ),
      ),
    );
  }
}
