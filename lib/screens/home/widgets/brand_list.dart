 import 'package:active_ecommerce_cms_demo_app/presenter/home_presenter.dart';
import 'package:active_ecommerce_cms_demo_app/screens/filter.dart';
import 'package:active_ecommerce_cms_demo_app/screens/home/widgets/get_brands_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';





class BrandListSectionSliver extends StatelessWidget {
  final HomePresenter homeData;
  final bool showViewAllButton ;

  const BrandListSectionSliver({super.key, required this.homeData, this.showViewAllButton = true});

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildListDelegate([
        Padding(
          padding: const EdgeInsetsDirectional.only(top: 20, start: 20, bottom: 10),
          child: GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return Filter(selected_filter: "brands");
              }));
            },
            child: Text(
              AppLocalizations.of(context)!.top_brands_ucf,
              style: const TextStyle(
                color: Color(0xff000000),
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
        CustomBrandListWidget(homePresenter: homeData,showViewAllButton: showViewAllButton),
      ]),
    );
  }
}
