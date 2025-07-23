import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/colors/test3.dart';

class Chart extends StatefulWidget {
  Chart({super.key});

  final Color dark = Color(0xff2EBBE5);
  final Color normal = Color(0xffE9A17B);
  final Color light = Color(0xff8D89E3);


  @override
  State<StatefulWidget> createState() => BarChartSample4State();
}

class BarChartSample4State extends State<Chart> {


  Widget bottomTitles(double value, TitleMeta meta) {
    print(value);
    const style = TextStyle(fontSize: 10, color: Colors.white);
    String text;
    switch (value.toInt()) {
      case 0:
        text = 'شنبه';
        break;
      case 1:
        text = 'یکشنبه';
        break;
      case 2:
        text = 'دوشنبه';
        break;
      case 3:
        text = 'سه شنبه';
        break;
      case 4:
        text = 'چهارشنبه';
        break;
      case 5:
        text = 'پنجشنبه';
        break;
      case 6:
        text = 'جمعه';
        break;
      default:
        text = '';
        break;
    }
    return SideTitleWidget(
      meta: TitleMeta(
        min: 0,
        // مقدار حداقل محور
        max: 100,
        // مقدار حداکثر محور
        parentAxisSize: 50,
        // اندازه محور والد
        axisPosition: 10,
        // موقعیت محور
        appliedInterval: 10,
        // فاصله بین عناوین محور
        sideTitles: SideTitles(showTitles: true),
        // تنظیمات نمایش عناوین
        formattedValue: text,
        // مقدار فرمت‌شده برای نمایش
        axisSide: AxisSide.left,
        // جهت نمایش عنوان روی محور (چپ/راست)
        rotationQuarterTurns: 0, // میزان چرخش عنوان (0 یعنی بدون چرخش)
      ),
      child: Text(text, style: style),
    );
  }


  List<double> toY = [32, 65, 70, 11, 50, 32, 40];
  List<Color> color = [
    AppColors.piChartSection1,
    AppColors.piChartSection2,
    AppColors.piChartSection3,
    AppColors.piChartSection1,
    AppColors.piChartSection2,
    AppColors.piChartSection3,
    AppColors.piChartSection1
  ];

  List<BarChartGroupData> getData(
      double barsWidth, double barsSpace, List<double> toY, List<Color> color) {
    return List.generate(7, ((index) {
      return BarChartGroupData(
        x: index,
        barsSpace: barsSpace,
        barRods: [
          BarChartRodData(
            toY: toY[index],
            color: color[index],
            borderRadius: BorderRadius.zero,
            width: barsWidth,
          ),
        ],
      );
    }));
  }

  Widget leftTitles(double value, TitleMeta meta) {
    final formatter = NumberFormat(
        '#,##'); // Use '#' for any digit, ',' for thousands separators
    final text = formatter.format(value.toInt());
    return SideTitleWidget(
      child: Text(text, style: TextStyle(fontSize: 10, color: Colors.white)),
      meta: TitleMeta(
        min: 0,
        // مقدار حداقل محور
        max: 100,
        // مقدار حداکثر محور
        parentAxisSize: 50,
        // اندازه محور والد
        axisPosition: 10,
        // موقعیت محور
        appliedInterval: 10,
        // فاصله بین عناوین محور
        sideTitles: SideTitles(showTitles: true),
        // تنظیمات نمایش عناوین
        formattedValue: text,
        // مقدار فرمت‌شده برای نمایش
        axisSide: AxisSide.left,
        // جهت نمایش عنوان روی محور (چپ/راست)
        rotationQuarterTurns: 0, // میزان چرخش عنوان (0 یعنی بدون چرخش)
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.66,
      child: Padding(
        padding: const EdgeInsets.only(top: 16),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final barsSpace = 30.0 * constraints.maxWidth / 400;
            final barsWidth = 20.0 * constraints.maxWidth / 400;
            return BarChart(
              BarChartData(
                alignment: BarChartAlignment.center,
                barTouchData: BarTouchData(
                  enabled: false,
                ),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 28,
                      getTitlesWidget: bottomTitles,
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: leftTitles,
                    ),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                gridData: FlGridData(
                  show: true,
                  checkToShowHorizontalLine: (value) => value % 10 == 0,
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: Colors.white,
                    strokeWidth: 0.25,
                  ),
                  drawVerticalLine: false,
                ),
                borderData: FlBorderData(
                  show: false,
                ),
                groupsSpace: barsSpace,
                barGroups: getData(barsWidth, barsSpace, toY, color),
              ),
            );
          },
        ),
      ),
    );
  }

}
