import 'package:active_ecommerce_cms_demo_app/app_config.dart';
import 'package:active_ecommerce_cms_demo_app/custom/home_search_box.dart';
import 'package:active_ecommerce_cms_demo_app/locale/custom_localization.dart';
import 'package:active_ecommerce_cms_demo_app/screens/filter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../data_model/address_response.dart';
import '../../../presenter/home_provider.dart';

class BuildAppBar extends StatelessWidget implements PreferredSizeWidget {
  const BuildAppBar({
    super.key,
    required this.context,
    required this.showAddress,
  });

  final BuildContext context;
  final bool showAddress;

  @override
  Widget build(BuildContext context) => appBar;

  @override
  Size get preferredSize => appBar.preferredSize;

  AppBar get appBar => AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0.0,
        centerTitle: false,
        elevation: 0,
        bottom: showAddress
            ? const PreferredSize(
                preferredSize: Size.fromHeight(30),
                child: AddressAppBarWidget(),
              )
            : null,
        flexibleSpace: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: AppDimensions.paddingSupSmall,
            horizontal: AppDimensions.paddingMedium,
          ),
          child: GestureDetector(
            onTap: () => Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => const Filter())),
            child: HomeSearchBox(context: context),
          ),
        ),
      );
}

class AddressAppBarWidget extends StatelessWidget {
  const AddressAppBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.read<HomeProvider>().handleAddressNavigation(false),
      child: Container(
        height: 40,
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingDefault,
        ),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Colors.grey.withValues(alpha: 0.1),
            ),
          ),
        ),
        child: Row(
          spacing: AppDimensions.paddingSmall,
          children: [
            Icon(
              Icons.location_on_outlined,
              color: Theme.of(context).primaryColor,
            ),
            Expanded(
              child: Selector<HomeProvider,
                  ({bool isLoadingAddress, Address? defaultAddress})>(
                selector: (_, p) => (
                  defaultAddress: p.defaultAddress,
                  isLoadingAddress: p.isLoadingAddress
                ),
                builder: (context, p, child) {
                  return Text(
                    p.isLoadingAddress
                        ? "is_loading".tr(context: context)
                        : p.defaultAddress == null
                            ? "add_default_address".tr(context: context)
                            : "${p.defaultAddress?.city_name}, ${p.defaultAddress?.state_name}, ${p.defaultAddress?.country_name}",
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
