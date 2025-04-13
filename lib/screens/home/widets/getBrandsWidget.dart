import 'package:active_ecommerce_cms_demo_app/presenter/home_presenter.dart';
import 'package:active_ecommerce_cms_demo_app/screens/brand_products.dart';
import 'package:flutter/material.dart';


class BrandListWidget extends StatelessWidget {
  final HomePresenter homePresenter;

  const BrandListWidget({super.key, required this.homePresenter});


  @override
  Widget build(BuildContext context) {
    if (homePresenter.brandsList.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }


    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: homePresenter.brandsList.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 0.8,
      ),
      itemBuilder: (context, index) {
        final brand = homePresenter.brandsList[index];
        return GestureDetector(
          onTap: (){ Navigator.push(context, MaterialPageRoute(builder: (context) {
   return       BrandProducts(slug: brand.slug ?? '',);
                                }));},
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  brand.logo ?? '',
                  height: 60,
                  width: 60,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => const Icon(Icons.image),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                brand.name ?? '',
                style: const TextStyle(fontSize: 12),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        );
      },
    );
  }
}
