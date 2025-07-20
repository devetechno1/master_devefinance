import 'package:flutter/material.dart';
import 'package:one_context/one_context.dart';

import 'app_ar.dart';
import 'app_en.dart';

class CustomLocalization {
  final Locale locale;
  const CustomLocalization(this.locale);

  static List<Locale> get supportedLocales => [
        const Locale('en'),
        const Locale('ar'),
      ];

  static bool isSupported(Locale locale) {
    for (Locale supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }

  static CustomLocalization? of(BuildContext context) {
    return Localizations.of<CustomLocalization>(context, CustomLocalization);
  }

  static const Map<String, Map<String, String>> _localizedValues = {
    'en': enLangs,
    'ar': arLangs,
  };

  String translate(String key) {
    return _localizedValues[locale.languageCode]?[key] ?? key;
  }
}

class CustomLocalizationDelegate
    extends LocalizationsDelegate<CustomLocalization> {
  const CustomLocalizationDelegate();

  @override
  bool isSupported(Locale locale) => CustomLocalization.isSupported(locale);

  @override
  Future<CustomLocalization> load(Locale locale) async {
    return CustomLocalization(locale);
  }

  @override
  bool shouldReload(CustomLocalizationDelegate old) => false;
}

extension StringTr on String {
  String tr({BuildContext? context, Map<String, String>? args}) {
    String translated = CustomLocalization.of(context ?? OneContext().context!)!
        .translate(this);
    if (args != null) {
      for (String key in args.keys) {
        translated = translated.replaceAll(key, args[key] ?? key);
      }
    }
    return translated;
  }
}
