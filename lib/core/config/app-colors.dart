import 'package:flutter/material.dart';

class AppConfig {

  static const Color backgroundColor = Color(0xff18203B);
  static const Color white = Colors.white;
  static const Color white70 = Colors.white70;
  static const Color contentColorGreen = Color(0xFF3BFF49);

  static const Color topOrderColor = Color(0xFF8d99ae);

  static const Color piChartSection1 = Color(0xFF273F4F);
  static const Color piChartSection2 = Color(0xFF447D9B);
  static const Color piChartSection3 = Color(0xFFBDBDBD);
  static const Color piChartSection4 = Color(0xFFFE7743);
  static const Color piChartSection5 = Color(0xFFE9A17B);

  static const Color secondaryColor = Color(0xFF303F59);

  static const Color firstLinearColor = Color(0xFFE9A17B);
  static const Color secondLinearColor = Color(0xFF447D9B);

  static const Color borderColor = Color(0xFFBDBDBD);
  static const Color progressBarColor = Color(0xFFE9A17B);


  static double calWidth(BuildContext context, double widthPercent) {
    double screenWidth = MediaQuery.of(context).size.width;
    return screenWidth * (widthPercent / 100);
  }

  static double calHeight(BuildContext context, double heightPercent) {
    double screenHeight = MediaQuery.of(context).size.height;
    return screenHeight * (heightPercent / 100);
  }
  static double calFontSize(BuildContext context, double fontPercent) {
    double screenWidth = MediaQuery.of(context).size.width;
    return screenWidth * (fontPercent / 100);
  }

  static double calTitleFontSize (BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return screenWidth * (4 / 100);
  }

  static double calBorderRadiusSize (BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return screenWidth * (2 / 100);
  }

}