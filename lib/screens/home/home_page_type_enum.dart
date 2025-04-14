import 'package:flutter/material.dart';

import 'home.dart';
import 'templates/metro.dart';

// * To change any page screen change widget of the type that you want
// * Or if you want to add .. add value with it's parameters


/// We use [HomePageType] to know home screen selected type by its values, 
/// that we get from '/api/v2/business-settings' endpoint, 
/// when admin change page you have to hot restart app.
enum HomePageType {
  classic('classic'),
  metro('metro', widget: const MetroScreen()),
  minima('minima'),
  megaMart('megamart'),
  reClassic('re-classic'),
  home('home', widget: const Home());

  final String typeString;
  final Widget widget;

  const HomePageType(this.typeString, {this.widget = const Home()});

  factory HomePageType.fromString(String? pageType) {
    for (HomePageType type in values) {
      if (type.typeString == pageType) {
        return type;
      }
    }
    return HomePageType.home;
  }
}
