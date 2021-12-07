import 'package:flutter/material.dart';

class FFNavigationBarTheme {
  final Color barBackgroundColor;
  final Color selectedItemBackgroundColor;
  final Color selectedItemIconColor;
  final Color selectedItemBorderColor;
  final Color unselectedItemBackgroundColor;
  final Color unselectedItemIconColor;
  final TextStyle selectedItemTextStyle;
  final TextStyle unselectedItemTextStyle;
  final double barHeight;
  final double itemWidth;

  final bool showSelectedItemShadow;

  static const kDefaultItemWidth = 48.0;

  static const kDefaultSelectedItemTextStyle = TextStyle(
    fontSize: 13.0,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );

  static const kDefaultUnselectedTextStyle = TextStyle(
    fontSize: 12.0,
    fontWeight: FontWeight.normal,
    color: Colors.grey,
  );

  FFNavigationBarTheme({
    this.barBackgroundColor = Colors.white,
    this.selectedItemBackgroundColor = Colors.blueAccent,
    this.selectedItemIconColor = Colors.white,
    this.selectedItemBorderColor = Colors.white,
    this.unselectedItemBackgroundColor = Colors.transparent,
    this.unselectedItemIconColor = Colors.grey,
    this.selectedItemTextStyle = kDefaultSelectedItemTextStyle,
    this.unselectedItemTextStyle = kDefaultUnselectedTextStyle,
    this.itemWidth = kDefaultItemWidth,
    this.barHeight = 64,
    this.showSelectedItemShadow = true,
  });
}
