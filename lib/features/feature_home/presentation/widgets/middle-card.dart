import 'package:flutter/material.dart';

import '../../../../core/colors/test3.dart';
import '../../../../core/params/middle_card_data.dart';

class MiddleCard extends StatelessWidget {
  final MiddleCardData middleCardData;
  const MiddleCard({super.key, required this.middleCardData});

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return  Container(
      height: height * 0.17,
      width: width * 0.9,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: AppColors.secondaryColor),
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
                    Text('1000 فروش',style: TextStyle(color: Colors.white,fontSize: width*0.03),),
                    Text('${middleCardData.dailySales} سفارش کامل',style: TextStyle(color: Colors.white,fontSize: width*0.03),),
                    Text('${middleCardData.dailyCancelled} سفارش برگشتی',style: TextStyle(color: Colors.white,fontSize: width*0.03),),
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
                    Text('1000 فروش',style: TextStyle(color: Colors.white,fontSize: width*0.03),),
                    Text('${middleCardData.monthlySales} سفارش کامل',style: TextStyle(color: Colors.white,fontSize: width*0.03),),
                    Text('${middleCardData.monthlyCancelled} سفارش برگشتی',style: TextStyle(color: Colors.white,fontSize: width*0.03),),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}
