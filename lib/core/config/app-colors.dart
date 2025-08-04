import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class AppConfig {
  static const Color primary = contentColorCyan;
  static const Color menuBackground = Color(0xFF090912);
  static const Color itemsBackground = Color(0xFF1B2339);
  static const Color pageBackground = Color(0xFF282E45);
  static const Color mainTextColor1 = Colors.white;
  static const Color mainTextColor2 = Colors.white70;
  static const Color mainTextColor3 = Colors.white38;
  static const Color mainGridLineColor = Colors.white10;
  static const Color borderColor = Colors.white54;
  static const Color gridLinesColor = Color(0x11FFFFFF);

  /*static const Color section1 = Color(0xff4B5563);
  static const Color section2 = Color(0xff9CA3AF);
  static const Color section3 = Color(0xffD1D5DB);
  static const Color section4 = Color(0xffF3F4F6);*/

  static const Color section1 = Color(0xff780000);
  static const Color section2 = Color(0xffC1121F);
  static const Color section3 = Color(0xff669BBC);
  static const Color section4 = Color(0xFF8d99ae);

  //static const Color background = Color(0xff5C7787);

  static const Color background = Color(0xff18203B);//
  static const Color cardBackground = Color(0xffFFFFFF);
  static const Color primaryColor = Color(0xff4F46E5);
  static const Color accentColor = Color(0xff3B82F6);
  static const Color textColor = Color(0xff1F2937);
  static const Color secondaryAccent = Color(0xff10B981);
  static const Color buttonHover = Color(0xff6366F1);
  static const Color white = Colors.white;
  static const Color white70 = Colors.white70;

  static const Color contentColorBlack = Colors.black;
  static const Color contentColorWhite = Colors.white;
  static const Color contentColorBlue = Color(0xFF2196F3);
  static const Color contentColorYellow = Color(0xFFFFC300);
  static const Color contentColorOrange = Color(0xFFFF683B);
  static const Color contentColorGreen = Color(0xFF3BFF49);
  static const Color contentColorPurple = Color(0xFF6E1BFF);
  static const Color contentColorPink = Color(0xFFFF3AF2);
  static const Color contentColorRed = Color(0xFFE80054);
  static const Color contentColorCyan = Color(0xFF50E4FF);

  static const Color piChartSection1 = Color(0xFF2EBBE5);//
  static const Color piChartSection2 = Color(0xFFE9A17B);//
  static const Color piChartSection3 = Color(0xFF8D89E3);//
  static const Color piChartSection4 = Color(0xFF4679F2);//
  static const Color piChartSection5 = Color(0xFFCA498C);//

  static const Color secondaryColor = Color(0xFF485874);//

  static const Color orderCardColor = Color(0xFF303F59);//

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


}