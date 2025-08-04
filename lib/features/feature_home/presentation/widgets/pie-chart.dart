
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:shapyar_bloc/core/colors/app-colors.dart';

import '../../../../core/config/app-colors.dart';

class HomeScreenPieChart extends StatefulWidget {
 final List<int> items;
   HomeScreenPieChart({super.key,required this.items});

  @override
  State<HomeScreenPieChart> createState() => _HomeScreenPieChartState();
}

class _HomeScreenPieChartState extends State<HomeScreenPieChart> {
  int touchedIndex = 0;
  List<String> percentages = [];

  @override
  Widget build(BuildContext context) {

    int sum = widget.items.reduce((a, b) => a + b);
    for(var item in widget.items){
      print("widget.test");
      print(widget.items);
      double item2 = ((item*100)/sum);
      print(item2);

      percentages.add(item2.toStringAsFixed(2));
    }

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
                  color: AppConfig.background, // Shadow color
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color:AppConfig.section3,
                      blurRadius: 20,
                      spreadRadius: 5,
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
      final fontSize = isTouched ? 20.0 :10.0;
      final radius = isTouched ? 110.0 : 100.0;
      final widgetSize = isTouched ? 55.0 : 40.0;
      const shadows = [Shadow(color: Colors.black, blurRadius: 2)];

      switch (i) {
        case 0:
          return PieChartSectionData(
              color: AppConfig.piChartSection1,
              value: double.parse(percentages[i]),
              title: '${double.parse(percentages[i])}%',
              radius: radius,
              titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xffffffff),
                shadows: shadows,
              ),
              badgeWidget: Text('تکمیل شده',style: TextStyle(color: Colors.white,fontSize: 8),),
              badgePositionPercentageOffset: 1.2
          );
        case 1:
          return PieChartSectionData(
            color: AppConfig.piChartSection2,
            value: double.parse(percentages[i]),
            title: '${double.parse(percentages[i])}%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: const Color(0xffffffff),
              shadows: shadows,
            ),
            badgeWidget: Text('در صف بررسی',style: TextStyle(color: Colors.white,fontSize: 8),),
            badgePositionPercentageOffset:1.2,
          );
        case 2:
          return PieChartSectionData(
            color: AppConfig.piChartSection3,
            value: double.parse(percentages[i]),
            title: '${double.parse(percentages[i])}%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: const Color(0xffffffff),
              shadows: shadows,
            ),
            badgeWidget: Text('در حال پرداخت',style: TextStyle(color: Colors.white,fontSize: 8),),
            badgePositionPercentageOffset: 1.3,
          );
        case 3:
          return PieChartSectionData(
            color: AppConfig.piChartSection4,
            value: double.parse(percentages[i]),
            title: '${double.parse(percentages[i])}%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: const Color(0xffffffff),
              shadows: shadows,
            ),
            badgeWidget: Text('در انتظار پردازش', style: TextStyle(color: Colors.white,fontSize: 8),),
            badgePositionPercentageOffset: 1.5,
          );
        case 4:
          return PieChartSectionData(
            color: AppConfig.piChartSection5,
            value: double.parse(percentages[i]),
            title: '${double.parse(percentages[i])}%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: const Color(0xffffffff),
              shadows: shadows,
            ),
            badgeWidget: Text('برگشت داده شده', style: TextStyle(color: Colors.white,fontSize: 8),),
            badgePositionPercentageOffset: 1.4,
          );
        default:
          throw Exception('Oh no');
      }
    });
  }
}


 

