import 'package:flutter/material.dart';

class Responsive {
  double? _width;
  double? _height;

  Responsive(BuildContext context) {
    _width = MediaQuery.of(context).size.width;
    _height = MediaQuery.of(context).size.height;
  }

  double? get width => _width;
  double? get height => _height;

  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < 640;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width < 1100 &&
      MediaQuery.of(context).size.width >= 640;

  static bool isPortrait(BuildContext context) {
    return MediaQuery.of(context).size.width <
        MediaQuery.of(context).size.height;
  }

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= 1100;

  sizeFromWidth(double size) {
    return _width! / (_width! / size);
  }

  sizeFromHeight(double size) {
    return _height! / (_height! / size);
  }
}
