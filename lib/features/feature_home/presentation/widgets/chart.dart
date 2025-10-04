
import 'dart:math' as math;
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shopyar/core/utils/static_values.dart';
import 'package:shopyar/features/feature_home/data/models/home_data_model.dart';
import 'package:shopyar/features/feature_home/domain/entities/home_data_entity.dart';
import '../../../../core/config/app-colors.dart';
import 'package:shamsi_date/shamsi_date.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:shopyar/extension/persian_digits.dart';


class Chart extends StatefulWidget {
  HomeDataEntity? homeDataModel;
  Chart(this.homeDataModel);

  final Color dark = Color(0xff2EBBE5);
  final Color normal = Color(0xffE9A17B);
  final Color light = Color(0xff8D89E3);


  @override
  State<StatefulWidget> createState() => BarChartSample4State();
}

class BarChartSample4State extends State<Chart> {

  List<String> lastWeekOrders = [];

  Map<String, String> persianDatesWithWeekday = {};

  List<double> result = [];

  final double kZeroBarHeight = 0.08;

  double _niceStep(double maxY) {
    if (maxY <= 5) return 1;
    final exp = (math.log(maxY) / math.ln10).floor();
    for (final base in [1, 2, 5]) {
      final step = base * math.pow(10, exp - 1);
      if (maxY / step <= 8) return step.toDouble();
    }
    return math.pow(10, exp - 1).toDouble();
  }

  final _faFmt = NumberFormat.decimalPattern('fa');


  List<String> getLastSevenDays() {
    final today = DateTime.now();
    return List.generate(7, (i) {
      final date = today.subtract(Duration(days: 6 - i));
      return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    });
  }

  List<double> getWeeklyCountsList(Map<String, int> counts) {
    // ترتیب روزهای هفته از شنبه تا جمعه
    final weekdays = [
      'شنبه',
      '1شنبه',
      '2شنبه',
      '3‌شنبه',
      '4شنبه',
      '5شنبه',
      'جمعه'
    ];

    Map<String, double> weekdayCounts = {for (var day in weekdays) day: 0.08};

    counts.forEach((dateString, count) {
      List<String> parts = dateString.split('-');
      DateTime gDate = DateTime(
        int.parse(parts[0]),
        int.parse(parts[1]),
        int.parse(parts[2]),
      );

      String weekdayName = _persianWeekdayName(gDate.weekday);
      weekdayCounts[weekdayName] = count.toDouble();
    });

    return weekdays.map((day) => weekdayCounts[day] ?? 0.08).toList();
  }

  String _persianWeekdayName(int weekday) {
    switch (weekday) {
      case DateTime.saturday:
        return 'شنبه';
      case DateTime.sunday:
        return '1کشنبه';
      case DateTime.monday:
        return '2شنبه';
      case DateTime.tuesday:
        return '3‌شنبه';
      case DateTime.wednesday:
        return '4شنبه';
      case DateTime.thursday:
        return '5‌شنبه';
      case DateTime.friday:
        return 'جمعه';
      default:
        return '';
    }
  }

  void test() {
    final counts = StaticValues.staticHomeDataEntity!.weeklyCounts;

     result = getWeeklyCountsList(counts!);
    print(result);
  }


  List<String> getLastWeekPersianDates(List<DateTime> dateTime) {

    final now = DateTime.now();
    final dates = <String>[];

    for (int i = dateTime.length; i >= 0; i--) {
      final gregorianDate = dateTime[i].subtract(Duration(days: i));
      final jalaliDate = Jalali.fromDateTime(gregorianDate);
      dates.add('${jalaliDate.year}/${jalaliDate.month.toString().padLeft(2, '0')}/${jalaliDate.day.toString().padLeft(2, '0')}');
    }

    return dates;
  }

  Widget bottomTitles(double value, TitleMeta meta) {
    print(value);
    TextStyle style = TextStyle(fontSize: AppConfig.calFontSize(context, 3.2), color: Colors.white);
    String text;
    switch (value.toInt()) {
      case 0:
        text = 'شنبه'.toString().stringToPersianDigits();
        break;
      case 1:
        text = '1شنبه'.toString().stringToPersianDigits();
        break;
      case 2:
        text = '2شنبه'.toString().stringToPersianDigits();
        break;
      case 3:
        text = '3شنبه'.toString().stringToPersianDigits();
        break;
      case 4:
        text = '4شنبه'.toString().stringToPersianDigits();
        break;
      case 5:
        text = '5شنبه'.toString().stringToPersianDigits();
        break;
      case 6:
        text = 'جمعه'.toString().stringToPersianDigits();
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
    AppConfig.piChartSection2,
    AppConfig.piChartSection5,
    AppConfig.piChartSection3,
    AppConfig.piChartSection2,
    AppConfig.piChartSection5,
    AppConfig.piChartSection3,
    AppConfig.piChartSection2
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
    final text = _faFmt.format(value.toInt());

    return SideTitleWidget(
      child: Text(text, style:  TextStyle(fontSize: AppConfig.calFontSize(context, 4.2), color: Colors.white)),
      meta: meta,
    );
  }
@override
  void initState() {
    // TODO: implement initState
    super.initState();
    test();
  }
  @override
  Widget build(BuildContext context) {
    // result = لیست واقعی شمارش‌ها (صفرها واقعا 0.0 باشن)
    final rawMax = result.isEmpty ? 0.0 : result.reduce(math.max);
    final allZero = rawMax == 0.0;

    // اگه همه صفرن: یه ماکس رندوم ثابت روزانه بساز (برای ثبات در رندرها)
    final int daySeed = DateTime.now().difference(DateTime(1970,1,1)).inDays;
    final double fallbackMaxY = 5 + math.Random(daySeed).nextInt(8).toDouble(); // 5..12

    // محور Y و فاصله تیک‌ها
    final double axisMaxY = allZero
        ? fallbackMaxY
        : (rawMax * 1.2).ceilToDouble(); // کمی حاشیه بالای بیشینه واقعی

    final double interval = allZero
        ? (fallbackMaxY / 5).ceilToDouble().clamp(1, double.infinity)
        : _niceStep(rawMax);

    return AspectRatio(
      aspectRatio: 1.66,
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
                    interval: interval,
                    getTitlesWidget: (v, m) {
                      // اگر همه صفرن، فقط 0 و چند تیک تمیز نشون بده
                      if (allZero && v < 0) return const SizedBox.shrink();
                      return leftTitles(v, m);
                    },
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
                checkToShowHorizontalLine: (v) => v % interval == 0,
                getDrawingHorizontalLine: (v) => FlLine(
                  color: allZero ? Colors.white12 : Colors.white24,
                  strokeWidth: 0.5,
                ),
                drawVerticalLine: false,
              ),
              borderData: FlBorderData(
                show: false,
              ),
              groupsSpace: barsSpace,
              barGroups: List.generate(7, (i) {
                final yRaw = (i < result.length) ? result[i] : 0.0;
                final yVisual = (yRaw == 0.0) ? kZeroBarHeight : yRaw;

                return BarChartGroupData(
                  x: i,
                  barsSpace: barsSpace,
                  barRods: [
                    BarChartRodData(
                      toY: yVisual,
                      width: barsWidth,
                      color: yRaw == 0.0
                          ? AppConfig.piChartSection3.withOpacity(0.55) // رنگ نرم‌تر برای صفرها
                          : color[i],
                      borderRadius: BorderRadius.zero,
                      // اختیاری: بک‌گراند برای زیبایی
                      backDrawRodData: BackgroundBarChartRodData(
                        show: !allZero, // وقتی همه صفرن، شاید نخواهی پس‌زمینه باشه
                        toY: axisMaxY,
                        color: Colors.white10,
                      ),
                    ),
                  ],
                );
              }),
            ),
          );
        },
      ),
    );
  }

}
