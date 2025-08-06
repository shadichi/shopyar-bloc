import 'package:flutter/material.dart';
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
    return  Container(
      height: height * 0.17,
      width: width ,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: AppConfig.secondaryColor),
      child: Row(
        children: [
          Expanded(
              child: Container(
                padding: EdgeInsets.all(width*0.03),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('امروز',style: TextStyle(color: Colors.white),),
                    Padding(
                      padding:  EdgeInsets.only(left: width*0.1),
                      child: Divider(),
                    ),
                    Text('${statusCounts!.dailyCounts} فروش',style: TextStyle(color: Colors.white,fontSize: width*0.03),),
                    Text('${statusCounts!.dailySales!.qty.toString()} سفارش کامل',style: TextStyle(color: Colors.white,fontSize: width*0.03),),
                    Text('${statusCounts!.dailyCancelled!.qty.toString()} سفارش برگشتی',style: TextStyle(color: Colors.white,fontSize: width*0.03),),
                  ],
                ),
              )),
          Expanded(
              child: Container(
                padding: EdgeInsets.all(width*0.03),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('ماهانه',style: TextStyle(color: Colors.white),),
                    Padding(
                      padding:  EdgeInsets.only(left: width*0.1),
                      child: Divider(),
                    ),
                    Text('${statusCounts!.monthlyCounts} فروش',style: TextStyle(color: Colors.white,fontSize: width*0.03),),
                    Text('${statusCounts!.monthlySales!.qty.toString()} سفارش کامل',style: TextStyle(color: Colors.white,fontSize: width*0.03),),
                    Text('${statusCounts!.monthlyCancelled!.qty.toString()} سفارش برگشتی',style: TextStyle(color: Colors.white,fontSize: width*0.03),),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}
