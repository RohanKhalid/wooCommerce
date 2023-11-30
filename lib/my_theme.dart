// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';

class MyTheme {
  /*configurable colors stars*/
  static Color primary_color = const Color.fromRGBO(90, 191, 209, 1);
  static Color accent_color = const Color.fromRGBO(157, 203, 68, 1);
  static Color background_color = const Color.fromRGBO(247, 245, 242, 1);
  static Color accent_color_shadow =
      const Color.fromRGBO(229, 65, 28, .40); // this color is a dropshadow of
  static Color soft_accent_color = const Color.fromRGBO(254, 234, 209, 1);
  static Color splash_screen_color = const Color.fromRGBO(
      60, 171, 65, 1); // if not sure , use the same color as accent color
  /*configurable colors ends*/
  /*If you are not a developer, do not change the bottom colors*/
  static Color white = const Color.fromRGBO(255, 255, 255, 1);
  static Color noColor = const Color.fromRGBO(255, 255, 255, 0);
  static Color light_grey = const Color.fromRGBO(239, 239, 239, 1);
  static Color dark_grey = const Color.fromRGBO(107, 115, 119, 1);
  static Color medium_grey = const Color.fromRGBO(167, 175, 179, 1);
  static Color blue_grey = const Color.fromRGBO(168, 175, 179, 1);
  static Color medium_grey_50 = const Color.fromRGBO(167, 175, 179, .5);
  static Color grey_153 = const Color.fromRGBO(153, 153, 153, 1);
  static Color dark_font_grey = const Color.fromRGBO(62, 68, 71, 1);
  static Color font_grey = const Color.fromRGBO(107, 115, 119, 1);
  static Color textfield_grey = const Color.fromRGBO(209, 209, 209, 1);
  static Color golden = const Color.fromRGBO(255, 168, 0, 1);
  static Color amber = const Color.fromRGBO(254, 234, 209, 1);
  static Color amber_medium = const Color.fromRGBO(254, 240, 215, 1);
  static Color golden_shadow = const Color.fromRGBO(255, 168, 0, .4);
  static Color green = Colors.green;
  static Color? green_light = Colors.green[200];
  static Color shimmer_base = Colors.grey.shade50;
  static Color shimmer_highlighted = Colors.grey.shade200;
  //testing shimmer
  /*static Color shimmer_base = Colors.redAccent;
  static Color shimmer_highlighted = Colors.yellow;*/
}
