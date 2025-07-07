import 'dart:ui';

import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'data_model/business_settings/business_settings.dart';
import 'data_model/business_settings/update_model.dart';
export 'constants/app_dimensions.dart';
export 'constants/app_images.dart';

// final String this_year = DateTime.now().year.toString();

class AppConfig {

  /// To know the device operating system (ios, huawei or any android device)
  static StoreType storeType = StoreType.unknown;


  /// To make force update to app
  static String version = '1.0.0';

  /// Internal development version shown on the splash screen.
  /// Used to verify the app build matches the master app.
  static const String deveVersion = '9.8.1';

  //configure this
  // static String copyright_text =
  //     "@ Deve Finance " + this_year; //this shows in the splash screen
  static const String app_name_ar = "متجر ديفي";
  static const String app_name_en = "Devefinance Store";

  /// This get the name of the application in deviceLocale
  static String appNameOnDeviceLang =
      PlatformDispatcher.instance.locale.languageCode == 'ar'
          ? app_name_ar
          : app_name_en;

  static bool isDebugMode = kDebugMode;
  static bool turnDevicePreviewOn = isDebugMode;

  /// This get the name of the application in appLocal
  static String appNameOnAppLang(BuildContext context) =>
      Localizations.localeOf(context).languageCode == 'ar'
          ? app_name_ar
          : app_name_en;

  static String search_bar_text(BuildContext context) =>
      AppLocalizations.of(context)!
          .search_in_active_ecommerce_cms; //this will show in app Search bar.
  static String purchase_code =
      "a"; //enter your purchase code for the app from codecanyon
  static String system_key =
      r"a"; //enter your purchase code for the app from codecanyon

  //Default language config
  static String default_language = "en";
  static String mobile_app_code = "en";
  static bool app_language_rtl = false;

  //Default country config
  static String default_country = "EG";

  //configure this
  static const bool HTTPS =
      true; //if you are using localhost , set this to false
  static const DOMAIN_PATH =
      "devefinance.com"; //use only domain name without http:// or https://

  //do not configure these below
  static const String API_ENDPATH = "api/v2";
  static const String PROTOCOL = HTTPS ? "https://" : "http://";
  static const String RAW_BASE_URL = "$PROTOCOL$DOMAIN_PATH";
  static const String BASE_URL = "$RAW_BASE_URL/$API_ENDPATH";

  static const LatLng initPlace = LatLng(30.723003387451172, 31.02609634399414);

  // static HomePageType selectedHomePageType = HomePageType.home;
  static BusinessSettingsData businessSettingsData =
      const BusinessSettingsData();
}
