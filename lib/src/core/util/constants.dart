import 'package:flutter/material.dart';

class Breakpoints {
  static const int largeScreenUpper = 1200;
  static const int largeScreenLower = 1025;
  static const int smallScreenUpper = 1024;
  static const int smallScreenLower = 769;
  static const int tabletUpper = 768;
  static const int tabletLower = 481;
  static const int mobileUpper = 480;
  static const int mobileLower = 360;
}

class Constants {
  static const int largeScreenSize = Breakpoints.largeScreenLower;
  static const int smallScreenSize = Breakpoints.smallScreenLower;
  static const int tabletScreenSize = Breakpoints.tabletLower;
  static const int mobileScreenSize = Breakpoints.mobileLower;

  static const double navRailWidth = 48;
  static const double navRailExtendedWidth = 180;
  static const double navRailIconSize = 30;
  static const double iconSize = 24;
  static const double imageGridSize = 168;
  static const defaultPadding = 8.0;
}

class CustomColor {
  static const primaryBackgroundColor = Color(0xff1F1D2B);
  static const bodyPrimaryColor = Color(0xff252836);
  static const primaryButtonColor = Color(0xffEA736D);

  static const orangeBackground = Color(0xffEB966A);
  static const orangeForeground = Color(0xffFFB572);
  static const fillTextField = Color(0xff252836);
  static const backgroundTextField = Color(0xff2D303E);
  static const borderGreyTextField = Color(0xff393C49);
  static const borderTextField = Color(0xffABBBC2);
  static const backgroundDetail = Color(0xff403D54);
  static const backgroundDialog = Color(0xff5C596B);
}
