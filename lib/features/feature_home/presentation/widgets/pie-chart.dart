
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
                height: AppConfig.calHeight(context, 31),
                width: AppConfig.calHeight(context, 31),
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
                sections: showingSections(),centerSpaceColor: Colors.green,
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
      final fontSize = isTouched ? AppConfig.calWidth(context, 4) :AppConfig.calWidth(context, 2.5);
      final radius = isTouched ? AppConfig.calWidth(context, 30) : AppConfig.calWidth(context, 28);
      final widgetSize = isTouched ? 55.0 : 40.0;
      const shadows = [Shadow(color: Colors.black, blurRadius: 2)];

      switch (i) {
        case 0:
          return pieChartItem(radius,fontSize,shadows,pieChartText('در حال پرداخت'),i,AppConfig.piChartSection3);
        case 1:
          return pieChartItem(radius,fontSize,shadows,pieChartText('در صف بررسی'),i,AppConfig.piChartSection2);
        case 2:
          return pieChartItem(radius,fontSize,shadows,pieChartText('برگشت داده شده'),i,AppConfig.piChartSection5);
        case 3:
          return pieChartItem(radius,fontSize,shadows,pieChartText('در انتظار پردازش         '),i,AppConfig.piChartSection4);
        case 4:
          return pieChartItem(radius,fontSize,shadows,pieChartText('تکمیل شده'),i,AppConfig.piChartSection1);
        default:
          throw Exception('Error');
      }
    });
  }
  Widget pieChartText(text){
    return Text(text,style: TextStyle(color: Colors.white,fontSize: AppConfig.calWidth(context,3)),);
  }
  PieChartSectionData pieChartItem(radius, fontSize,shadows, badgeWidget,index,color){
    return PieChartSectionData(
      color: color,
      value: double.parse(percentages[index]),
      title: '${double.parse(percentages[index])}%',
      radius: radius,
      titleStyle: TextStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.bold,
        color: const Color(0xffffffff),
        shadows: shadows,
      ),
      badgeWidget: badgeWidget,
      badgePositionPercentageOffset:1.3,
    );
  }
}


 

