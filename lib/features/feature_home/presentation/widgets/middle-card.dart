import 'package:flutter/material.dart';

import '../../../../core/colors/test3.dart';

class MiddleCard extends StatelessWidget {
  const MiddleCard({super.key});

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
                    Text('5 سفارش کامل',style: TextStyle(color: Colors.white,fontSize: width*0.03),),
                    Text('1 سفارش برگشتی',style: TextStyle(color: Colors.white,fontSize: width*0.03),),
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
                    Text('5 سفارش کامل',style: TextStyle(color: Colors.white,fontSize: width*0.03),),
                    Text('1 سفارش برگشتی',style: TextStyle(color: Colors.white,fontSize: width*0.03),),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}
