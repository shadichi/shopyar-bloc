import 'package:flutter/material.dart';
import 'package:shapyar_bloc/features/feature_orders/domain/entities/orders_entity.dart';
import 'package:shapyar_bloc/features/feature_orders/presentation/bloc/orders_status.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:auto_size_text/auto_size_text.dart';

import '../../../../core/colors/test3.dart';
import '../screens/order_detail_screen.dart';

class Order extends StatelessWidget {
  OrdersEntity ordersLoadedStatus;
  int item;

  Order({
    required this.ordersLoadedStatus,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Container(
      width: 50,
      margin: EdgeInsets.all(width * 0.01),
      child: Card(
        color: Colors.white,
        elevation: 8,
        child: Container(
          /*color: Colors.red,*/
          child: Column(
            children: [
              Container(
                  decoration: BoxDecoration(
                    color: AppColors.section4,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(10.0),
                      // Set top-right corner radius
                      topLeft:
                          Radius.circular(10.0), // Set top-right corner radius
                    ),
                  ),

                  height: height * 0.075,
                  width: width * 0.97,
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: Row(
                      children: [
                        Container(
                            width: width * 0.4,
                            /*color: Colors.red,*/
                            alignment: Alignment.center,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  ordersLoadedStatus.dateCreated!
                                      ==  Jalali.now()
                                      ? "امروز"
                                      :
                                  "${ordersLoadedStatus.dateCreated!.year}/${ordersLoadedStatus.dateCreated!.month}/${ordersLoadedStatus.dateCreated!.day}",
                                  style: TextStyle(color: Colors.white),
                                ),
                                IconButton(
                                    onPressed: () {},
                                    icon: Icon(
                                      Icons.date_range,
                                      size: 16,
                                      color: Colors.white,
                                    )),
                              ],
                            )),
                        Container(
                            width: width * 0.3,
                        /*    color: Colors.green,*/
                            alignment: Alignment.center,

                            child: AutoSizeText(
                              "${ordersLoadedStatus.billing!.firstName} ${ordersLoadedStatus.billing!.lastName}",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: width*0.04, color: Colors.white),
                              maxLines: 1,
                              minFontSize: 9,
                              overflow: TextOverflow.ellipsis,

                            ),),
                        Container(
                            width: width * 0.2,
                            /*color: Colors.red,*/
                            alignment: Alignment.centerLeft,
                            child: Text(
                                "سفارش ${ordersLoadedStatus.id.toString()}",
                                style: TextStyle(color: Colors.white))),
                      ],
                    ),
                  )),
              Container(
                 color: Colors.white10,
                height: height * 0.15,
                width: width * 0.9,
                alignment: Alignment.center,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 8.0,top: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("جمع"),
                          Text(ordersLoadedStatus.total
                              .toString()),
                        ],
                      ),
                    ),
                    Divider(),
                    Row(
                      children: [
                        Container(
                          width: width * 0.7,
                          height: height * 0.085,
                          /*   color: Colors.red,*/
                          child: ListView.builder(
                              itemCount: ordersLoadedStatus.lineItems!.length,
                              itemBuilder: (context, index) {
                                return Row(
                                  children: [
                                    Container(
                                        //  color: Colors.green,
                                        width: width * 0.06,
                                        alignment: Alignment.center,
                                        child: Text(ordersLoadedStatus.lineItems![index]
                                            .quantity
                                            .toString())),
                                    Container(
                                        child: Text("×"),
                                        alignment: Alignment.center,
                                        //  color: Colors.pink,
                                        width: width * 0.04),
                                    FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: SingleChildScrollView(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Container(
                                              child: AutoSizeText(
                                                ordersLoadedStatus.lineItems![index].name.toString(),
                                                textAlign: TextAlign.center,
                                                style: TextStyle(fontSize: width*0.04),
                                                maxLines: 1,
                                                minFontSize: 9,
                                                overflow: TextOverflow.ellipsis,

                                              ),
                                              width: width*0.6,
                                              alignment: Alignment.centerRight,
                                            ),
                                          ],
                                        ),
                                      )

                                    ),
                                  ],
                                );
                              }),
                        ),
                        Container(
                          /*color: Colors.grey,*/
                          width: width * 0.19,
                          height: height * 0.085,
                          padding: EdgeInsets.symmetric(vertical: width * 0.03),
                          child: ElevatedButton(
                            onPressed: () {
                              /*Navigator.pushNamed(context, OrderDetailScreen.routeName,
                                arguments: orderData(ordersLoadedStatus: ordersLoadedStatus, item: item),);*/
                              Navigator.push(context, MaterialPageRoute(builder: (context){
                                return OrderDetailScreen(ordersLoadedStatus, item);
                              }));
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.background,
                            ),
                            child: Text(
                              "مشاهده",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: width * 0.02),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
class orderData {
  final OrdersLoadedStatus ordersLoadedStatus;
  final int item;

  orderData({required this.ordersLoadedStatus, required this.item});
}

