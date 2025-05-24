import 'package:active_ecommerce_cms_demo_app/app_config.dart';
import 'package:active_ecommerce_cms_demo_app/custom/lang_text.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../data_model/business_settings/update_model.dart';
import '../services/navigation_service.dart';

class UpdateScreen extends StatelessWidget {
  const UpdateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final UpdateDataModel updateData =
        AppConfig.businessSettingsData.updateData!;
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.paddingMaxLarge),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(flex: 2),
              Image.asset(
                AppImages.applogo,
                width: 90,
                height: 90,
                //  color: Theme.of(context).primaryColor,
              ),
              // Icon(Icons.system_update,
              //     size: 100, color: Theme.of(context).primaryColor),
              const SizedBox(height: AppDimensions.paddingMaxLarge),
              Text(
                LangText(context).local.avaliable_update,
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: AppDimensions.paddingDefault),

              Text(
                LangText(context).local.please_update_to_continue,
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: AppDimensions.paddingExtraLarge),
              const Icon(Icons.system_update, size: 30, color: Colors.black),
              const SizedBox(height: AppDimensions.paddingExtraLarge),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  OutlinedButton(
                    onPressed: () => NavigationService.handleUrls(
                      updateData.storeLink,
                      context,
                    ),
                    child: Text(LangText(context).local.update_now_ucf),
                  ),
                  if (!updateData.mustUpdate)
                    OutlinedButton(
                      onPressed: (){
                        final GoRouter goRouter = GoRouter.of(context);
                        final String newPath = goRouter.state?.uri.queryParameters['url'] ?? '/';
                        goRouter.go(newPath , extra: true);
                      },

                      child: Text(LangText(context).local.skip_ucf),
                    ),
                ],
              ),

              const Spacer(),
              GestureDetector(
                onTap: () => NavigationService.handleUrls(
                  updateData.storeLink,
                  context,
                ),
                child: Image.asset(
                  _getDeviceImage(),
                  height: 140,
                  width: 140,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

String _getDeviceImage() {
  switch (AppConfig.storeType) {
    case StoreType.appleStore:
      return AppImages.applestore;
    case StoreType.playStore:
      return AppImages.googleplay;
    case StoreType.appGallery:
      return AppImages.huawei;
    default:
      return AppImages.placeholder;
  }
}
