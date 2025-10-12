import 'dart:collection';

import 'package:active_ecommerce_cms_demo_app/helpers/string_helper.dart';
import 'package:active_ecommerce_cms_demo_app/presenter/home_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../app_config.dart';
import '../../../data_model/product_mini_response.dart';
import '../../product/product_details.dart';

class TodaysDealProductsSliverWidget extends StatelessWidget {
  const TodaysDealProductsSliverWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final todayDealList =
        context.select<HomeProvider, UnmodifiableListView<Product>>(
            (value) => UnmodifiableListView(value.TodayDealList));
    if (todayDealList.isEmpty) {
      return const SliverToBoxAdapter(child: emptyWidget);
    }

    return SliverToBoxAdapter(
      child: SizedBox(
        height: 250,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          itemCount: todayDealList.length,
          itemBuilder: (context, index) {
            final product = todayDealList[index];

            return GestureDetector(
              onTap: product.slug == null
                  ? null
                  : () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ProductDetails(slug: product.slug!),
                        ),
                      );
                    },
              child: Container(
                width: 160,
                margin: const EdgeInsetsDirectional.only(
                  end: AppDimensions.paddingDefault,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    AspectRatio(
                      aspectRatio: 1,
                      child: ClipRRect(
                        borderRadius:
                            BorderRadius.circular(AppDimensions.radiusSmall),
                        child: Image.network(
                          product.thumbnail_image ?? '',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      product.name ?? '',
                      maxLines: 2,
                      textDirection: (product.name ?? '').direction,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      product.main_price ?? '',
                      style: const TextStyle(color: Colors.red),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
