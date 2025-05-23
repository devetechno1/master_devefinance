// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:active_ecommerce_cms_demo_app/helpers/color_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Test color converter', () {
    final Color? color = ColorHelper.stringToColor("050");

    expect(color, const Color(0xFFFFF050));
  });
}
