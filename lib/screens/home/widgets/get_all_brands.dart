import 'package:active_ecommerce_cms_demo_app/presenter/home_presenter.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../data_model/brand_response.dart';

class CustomAllBrandListWidget extends StatefulWidget {
  final HomePresenter homePresenter;

  const CustomAllBrandListWidget({super.key, required this.homePresenter});

  @override
  State<CustomAllBrandListWidget> createState() => _CustomAllBrandListWidgetState();
}

class _CustomAllBrandListWidgetState extends State<CustomAllBrandListWidget> {

  @override
  Widget build(BuildContext context) {
    final List<Brands> brands = widget.homePresenter.brandsList;

    if (brands.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      children: [
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: brands.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 0.8,
          ),
          itemBuilder: (context, index) {
            final Brands brand = brands[index];

          
              return GestureDetector(
                onTap: () {
                  context.pushNamed('Brands');
                },
                child: Column(
                  children: [
                    Stack(
                      children: [
                        Image.network(
                          brand.logo ?? '',
                          height: 60,
                          width: 60,
                          fit: BoxFit.contain,
                          errorBuilder: (_, __, ___) => const Icon(Icons.image),
                        ),
                      ],
                    ),
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
