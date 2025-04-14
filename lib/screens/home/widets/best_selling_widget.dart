import 'package:active_ecommerce_cms_demo_app/custom/lang_text.dart';
import 'package:active_ecommerce_cms_demo_app/presenter/home_presenter.dart';
import 'package:flutter/material.dart';
import 'package:active_ecommerce_cms_demo_app/data_model/product_mini_response.dart';
import '../../product/product_details.dart';

class BestSellingProductsWidget extends StatelessWidget {
  final bool isVertical;
  final List<Product>? products;


  const BestSellingProductsWidget({
    super.key,
    required this.isVertical,
     this.products,
  });

  @override
  Widget build(BuildContext context) {
    // if (isLoading==null) {
    //   return SizedBox(
    //     height: 250,
    //     child: Center(child: CircularProgressIndicator()),
    //   );
    // }

    if (products == null || products!.isEmpty) {
      return Center(
        child: Text(
          LangText(context).local.no_best_selling_products_available,
        ),
      );
    }

    // العرض العمودي
    if (isVertical) {
      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: products!.length,
        itemBuilder: (context, index) {
          final product = products![index];
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
            child: GestureDetector(
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
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      product.thumbnail_image ?? '',
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.name ?? '',
                          maxLines: 2,
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
                ],
              ),
            ),
          );
        },
      );
    }

    // العرض الأفقي
    return SizedBox(
      height: 250,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: products!.length,
        itemBuilder: (context, index) {
          final product = products![index];
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
              margin: const EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AspectRatio(
                    aspectRatio: 1,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
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
    );
  }
}
