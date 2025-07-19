
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:shapyar_bloc/core/colors/test3.dart';

class HomeScreenPieChart extends StatefulWidget {
  const HomeScreenPieChart({super.key});

  @override
  State<StatefulWidget> createState() => HomeScreenPieChartState();
}

class HomeScreenPieChartState extends State {
  int touchedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.4,
      child: AspectRatio(
        aspectRatio: 0.5,
        child: Stack(
          children: [
          Center(
            child: Container(
            height: 200,
            width: 220,
            decoration: BoxDecoration(
              color: AppColors.background, // Shadow color
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 10,
                  spreadRadius: 2,
                  offset: Offset(4, 4), // Adjust shadow position
                ),
              ],
            ),
                    ),
          ),
            PieChart(
              PieChartData(
                pieTouchData: PieTouchData(
                  touchCallback: (FlTouchEvent event, pieTouchResponse) {
                    setState(() {
                      if (!event.isInterestedForInteractions ||
                          pieTouchResponse == null ||
                          pieTouchResponse.touchedSection == null) {
                        touchedIndex = -1;
                        return;
                      }
                      touchedIndex =
                          pieTouchResponse.touchedSection!.touchedSectionIndex;
                    });
                  },
                ),

                sectionsSpace: 5,
                centerSpaceRadius: 0.1,
                sections: showingSections(),centerSpaceColor: Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<PieChartSectionData> showingSections() {
    return List.generate(5, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 20.0 : 16.0;
      final radius = isTouched ? 110.0 : 100.0;
      final widgetSize = isTouched ? 55.0 : 40.0;
      const shadows = [Shadow(color: Colors.black, blurRadius: 2)];

      switch (i) {
        case 0:
          return PieChartSectionData(
            color: AppColors.piChartSection1,
            value: 40,
            title: '40%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: const Color(0xffffffff),
              shadows: shadows,
            ),
            badgeWidget: Text('در صف بررسی',style: TextStyle(color: Colors.white,fontSize: 8),),
            badgePositionPercentageOffset: 1.2
          );
        case 1:
          return PieChartSectionData(
            color: AppColors.piChartSection2,
            value: 30,
            title: '30%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: const Color(0xffffffff),
              shadows: shadows,
            ),
            badgeWidget: Text('پرداخت شده',style: TextStyle(color: Colors.white,fontSize: 8),),
            badgePositionPercentageOffset:1.4,
          );
        case 2:
          return PieChartSectionData(
            color: AppColors.piChartSection3,
            value: 16,
            title: '16%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: const Color(0xffffffff),
              shadows: shadows,
            ),
            badgeWidget: Text('در حال پردازش',style: TextStyle(color: Colors.white,fontSize: 8),),
            badgePositionPercentageOffset: 1.2,
          );
        case 3:
          return PieChartSectionData(
            color: AppColors.piChartSection4,
            value: 15,
            title: '15%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: const Color(0xffffffff),
              shadows: shadows,
            ),
            badgeWidget: Text('در انتظار پرداخت', style: TextStyle(color: Colors.white,fontSize: 8),),
            badgePositionPercentageOffset: 1.5,
          );
        case 4:
          return PieChartSectionData(
            color: AppColors.piChartSection5,
            value: 15,
            title: '10%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: const Color(0xffffffff),
              shadows: shadows,
            ),
            badgeWidget: Text('در انتظار پرداخت', style: TextStyle(color: Colors.white,fontSize: 8),),
            badgePositionPercentageOffset: 1.4,
          );
        default:
          throw Exception('Oh no');
      }
    });
  }
}
