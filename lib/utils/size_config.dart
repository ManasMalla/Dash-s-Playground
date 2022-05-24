import 'package:flutter/material.dart';

class SizeConfig {
  static late double heightRatio;
  static late double widthRatio;
  init(context) {
    var mediaQueryData = MediaQuery.of(context);
    var size = mediaQueryData.size;
    heightRatio = size.height / 694;
    widthRatio = size.width / 1251;
  }
}

double getProportionateHeight(double height) {
  return height * SizeConfig.heightRatio;
}

double getProportionateWidth(double width) {
  return width * SizeConfig.widthRatio;
}
