import 'package:active_ecommerce_cms_demo_app/presenter/home_presenter.dart';
import 'package:active_ecommerce_cms_demo_app/screens/brand_products.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

import '../../../data_model/brand_response.dart';

class CustomBrandListWidget extends StatefulWidget {
  final HomePresenter homePresenter;
    final bool showViewAllButton;


  const CustomBrandListWidget({super.key, required this.homePresenter, required this.showViewAllButton});

  @override
  State<CustomBrandListWidget> createState() => _CustomBrandListWidgetState();
}

class _CustomBrandListWidgetState extends State<CustomBrandListWidget> {

  @override
  Widget build(BuildContext context) {
    final List<Brands> brands = widget.homePresenter.brandsList;

    if (brands.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    final bool showViewAll = widget.showViewAllButton && brands.length > 8;

    return Column(
      children: [
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: showViewAll ? 8 : brands.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 0.8,
          ),
          itemBuilder: (context, index) {
            final Brands brand = brands[index];

            if(showViewAll && index == 7){
              return GestureDetector(
                onTap: () {
                  context.pushNamed('Brands');
                },
                child: Column(
                  children: [
                    ClipOval(
                      child: Stack(
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
                          Positioned.fill(
                            child: ColoredBox(
                              color: Theme.of(context).primaryColor.withValues(alpha: 0.8),
                              child: Icon(Icons.more_horiz_outlined, color: Colors.white),
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      
                      AppLocalizations.of(context)!.view_all_ucf,
                      style: const TextStyle(fontSize: 12,fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              );
            }
            return GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return BrandProducts(slug: brand.slug ?? '');
                }));
              },
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
                    style: const TextStyle(fontSize: 12,),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
