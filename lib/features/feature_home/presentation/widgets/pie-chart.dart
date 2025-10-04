import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:shopyar/extension/persian_digits.dart';
import '../../../../core/config/app-colors.dart';

class HomeScreenPieChart extends StatefulWidget {
  final List<int> items; // [paying, queue, refunded, pending, completed]
  const HomeScreenPieChart({super.key, required this.items});

  @override
  State<HomeScreenPieChart> createState() => _HomeScreenPieChartState();
}

class _HomeScreenPieChartState extends State<HomeScreenPieChart> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    print('widget.items[0]');
    print(widget.items[0]);
    print(widget.items[1]);
    print(widget.items[2]);
    print(widget.items[3]);
    print(widget.items[4]);
    // تعریف لیبل و رنگ هر وضعیت
    final labels = <String>[
      'تکمیل شده',
      'در انتظار بررسی',
      'در انتظار پرداخت',
      'در انتظار پردازش',
      'لغو شده',
    ];
    final colors = <Color>[
      AppConfig.piChartSection3, // match case 0
      AppConfig.piChartSection2, // case 1
      AppConfig.piChartSection5, // case 2
      AppConfig.piChartSection4, // case 3
      AppConfig.piChartSection1, // case 4
    ];

    // ساخت لیست اسلایس‌ها (فقط > 0)
    final slices = <_Slice>[];
    for (var i = 0; i < widget.items.length && i < labels.length; i++) {
      final v = widget.items[i];
      if (v > 0) {
        slices.add(_Slice(label: labels[i], value: v, color: colors[i]));
      }
    }

    // جمع کل برای محاسبه درصد
    final sum = slices.fold<int>(0, (acc, s) => acc + s.value);

    // اگر همه صفر بودن، یک سکشن «بدون داده» نشون بده
    final hasData = sum > 0 && slices.isNotEmpty;
    final sections = hasData
        ? _buildSections(context, slices, sum)
        : _buildEmptySection(context);

    // اگر طول سکشن‌ها تغییر کرد، لمس‌شده رو ریست کن
    if (touchedIndex >= sections.length) {
      touchedIndex = -1;
    }

    return AspectRatio(
      aspectRatio: 1.7,
      child: AspectRatio(
        aspectRatio: 0.5,
        child: Stack(
          children: [
            Center(
              child: Container(

                height: AppConfig.calHeight(context, 31),
                width: AppConfig.calHeight(context, 31),
                decoration: BoxDecoration(
                  color: AppConfig.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue,
                      blurRadius: 30,
                      spreadRadius: 2,
                      offset: const Offset(0, 0),
                    ),
                  ],
                ),
              ),
            ),
            PieChart(
              PieChartData(
                borderData: FlBorderData(show: true, border: Border.all(color: Colors.white, width: 1)),
                pieTouchData: PieTouchData(
                  touchCallback: (event, pieTouchResponse) {
                    setState(() {
                      if (!event.isInterestedForInteractions ||
                          pieTouchResponse == null ||
                          pieTouchResponse.touchedSection == null) {
                        touchedIndex = -1;
                        return;
                      }
                      touchedIndex = pieTouchResponse
                          .touchedSection!.touchedSectionIndex;
                    });
                  },
                ),
                sectionsSpace: 1,
                centerSpaceRadius: 0.1,
                sections: sections,
                centerSpaceColor: Colors.transparent,
              ),
            )
          ],
        ),
      ),
    );
  }

  List<PieChartSectionData> _buildSections(
      BuildContext context, List<_Slice> slices, int sum) {
    return List<PieChartSectionData>.generate(slices.length, (i) {
      final s = slices[i];
      final isTouched = i == touchedIndex;
      final fontSize =
      isTouched ? AppConfig.calWidth(context, 7) : AppConfig.calWidth(context, 6);
      final radius = isTouched
          ? AppConfig.calWidth(context, 30)
          : AppConfig.calWidth(context, 28);
      const shadows = [Shadow(color: Colors.black, blurRadius: 2)];

      final percent = (s.value * 100) / sum;
      final titleText = '${percent.round().toString().stringToPersianDigits()}%';
      final isSmall = percent.round() < 7?true:false;

      return PieChartSectionData(
        color: s.color,
        value: percent, // fl_chart بر اساس value نسبت‌ها رو می‌کشه
        title: titleText,
        radius: radius,
        titleStyle: TextStyle(
          fontSize: isSmall?fontSize/1.6:fontSize,
          fontWeight: FontWeight.bold,
          color: const Color(0xffffffff),
          shadows: shadows,
        ),
        badgeWidget: _badge(s.label),
        badgePositionPercentageOffset: 1.3,
      );
    });
  }

  List<PieChartSectionData> _buildEmptySection(BuildContext context) {
    final radius = AppConfig.calWidth(context, 28);
    const shadows = [Shadow(color: Colors.black, blurRadius: 2)];
    return [
      PieChartSectionData(
        color: Colors.grey.shade400,
        value: 100,
        title: 'بدون داده',
        radius: radius,
        titleStyle: TextStyle(
          fontSize: AppConfig.calWidth(context, 3),
          fontWeight: FontWeight.bold,
          color: Colors.white,
          shadows: shadows,
        ),
        badgeWidget: _badge('بدون داده'),
        badgePositionPercentageOffset: 1.2,
      ),
    ];
  }

  Widget _badge(String text) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppConfig.calWidth(context, 2),
        vertical: AppConfig.calWidth(context, 1),
      ),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.35),
        borderRadius: BorderRadius.circular(AppConfig.calWidth(context, 2)),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white,
          fontSize: AppConfig.calWidth(context, 3.2),
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _Slice {
  final String label;
  final int value;
  final Color color;
  _Slice({required this.label, required this.value, required this.color});
}
