
  import 'package:active_ecommerce_cms_demo_app/custom/feature_categories_widget.dart';
import 'package:active_ecommerce_cms_demo_app/screens/home/home.dart';
import 'package:flutter/material.dart';
class CategoryList extends StatelessWidget {
  const CategoryList({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: SizedBox(
        height: 175,
        child: ListenableBuilder(
            listenable: homeData,
            builder: (context, child) {
              if (!homeData.isFeaturedProductInitial && homeData.featuredProductList.isEmpty) return const SizedBox();
              return FeaturedCategoriesWidget(homeData: homeData,
              
             
              //  nameTextStyle: ,
              //pricesTextStyle:
              );
            }),
      ),
    );
  }
}