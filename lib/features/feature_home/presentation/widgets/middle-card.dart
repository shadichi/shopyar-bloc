import 'package:flutter/material.dart';
import 'package:shapyar_bloc/extension/persian_digits.dart';
import 'package:shapyar_bloc/features/feature_home/domain/entities/home_data_entity.dart';

import '../../../../core/colors/app-colors.dart';
import '../../../../core/config/app-colors.dart';
import '../../../../core/params/middle_card_data.dart';
import '../../data/models/home_data_model.dart';

class MiddleCard extends StatelessWidget {
  final HomeDataEntity? statusCounts;

  const MiddleCard({super.key, required this.statusCounts});

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Container(
     // height: height * 0.17,
      width: width,
      decoration: BoxDecoration(
          border: Border.all(color: AppConfig.borderColor, width: 0.4),
          borderRadius: BorderRadius.circular(10),
          color: AppConfig.secondaryColor),
      child: Row(
        children: [
          Expanded(
              child: Container(
            padding: EdgeInsets.all(width * 0.02),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //  spacing: AppConfig.calWidth(context, 0.5),
              children: [
                Text(
                  'امروز',
                  style: TextStyle(color: Colors.white, fontSize: width * 0.05),
                ),
                Padding(
                  padding: EdgeInsets.only(left: width * 0.1),
                  child: Container(
                      margin: EdgeInsets.all(AppConfig.calWidth(context, 2)),
                      width: AppConfig.calWidth(context, 40),
                      height: 0.5,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                        colors: [
                          AppConfig.firstLinearColor,
                          AppConfig.secondLinearColor
                        ],
                      ))),
                ),
                Text(
                  '${statusCounts!.dailyCounts!.toString().stringToPersianDigits()} فروش',
                  style: TextStyle(color: Colors.white, fontSize: width * 0.04),
                ),
                Text(
                  '${statusCounts!.dailySales!.qty.toString().stringToPersianDigits()} سفارش کامل',
                  style: TextStyle(color: Colors.white, fontSize: width * 0.04),
                ),
                Text(
                  '${statusCounts!.dailyCancelled!.qty.toString().stringToPersianDigits()} سفارش برگشتی',
                  style: TextStyle(color: Colors.white, fontSize: width * 0.04),
                ),
              ],
            ),
          )),
          Expanded(
              child: Container(
            padding: EdgeInsets.all(width * 0.02),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
             // spacing: AppConfig.calWidth(context, 0.5),
              children: [
                Text(
                  'ماهانه',
                  style: TextStyle(color: Colors.white, fontSize: width * 0.05),
                ),
                Padding(
                  padding: EdgeInsets.only(left: width * 0.1),
                  child: Container(
                      margin: EdgeInsets.all(AppConfig.calWidth(context, 2)),
                      width: AppConfig.calWidth(context, 40),
                      height: 0.5,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                        colors: [
                          AppConfig.firstLinearColor,
                          AppConfig.secondLinearColor
                        ],
                      ))),
                ),
                Text(
                  '${statusCounts!.monthlyCounts.toString().stringToPersianDigits()} فروش',
                  style: TextStyle(color: Colors.white, fontSize: width * 0.04),
                ),
                Text(
                  '${statusCounts!.monthlySales!.qty.toString().stringToPersianDigits()} سفارش کامل',
                  style: TextStyle(color: Colors.white, fontSize: width * 0.04),
                ),
                Text(
                  '${statusCounts!.monthlyCancelled!.qty.toString().stringToPersianDigits()} سفارش برگشتی',
                  style: TextStyle(color: Colors.white, fontSize: width * 0.04),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }
}
