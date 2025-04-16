import 'package:active_ecommerce_cms_demo_app/screens/home/templates/minima.dart';
import 'package:flutter/material.dart';

import 'home.dart';
import 'templates/metro.dart';

// * To change any page screen change widget of the type that you want
// * Or if you want to add .. add value with it's parameters


/// We use [HomePageType] to know home screen selected type by its values, 
/// that we get from '/api/v2/business-settings' endpoint with key 'homepage_select', 
/// when admin change page you have to hot restart app.
enum HomePageType {
  classic('classic', screen: Home()),
  metro('metro', screen:  MetroScreen()),
  minima('minima', screen: MinimaScreen()),
  megaMart('megamart', screen: Home()),
  reClassic('re-classic', screen: Home()),
  home('home', screen: const Home());

  final String typeString;
  final Widget screen;

  const HomePageType(this.typeString, {required this.screen});

  factory HomePageType.fromString(String? pageType) {
    for (HomePageType type in values) {
      if (type.typeString == pageType) {
        return type;
      }
    }
    return HomePageType.home;
  }
}
