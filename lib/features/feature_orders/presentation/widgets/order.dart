import 'package:flutter/material.dart';
import 'package:shapyar_bloc/extension/persian_digits.dart';
import 'package:shapyar_bloc/features/feature_orders/domain/entities/orders_entity.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:auto_size_text/auto_size_text.dart';
import '../../../../core/config/app-colors.dart';
import '../screens/order_detail_screen.dart';
import 'package:intl/intl.dart';

class Order extends StatelessWidget {
  OrdersEntity ordersLoadedStatus;
  int item;

  Order({
    required this.ordersLoadedStatus,
    required this.item,
  });

  String formatFaThousands(dynamic value) {
    final n = (value is num) ? value : num.tryParse(value.toString()) ?? 0;
    return NumberFormat.decimalPattern('fa').format(n);
  }

  final ScrollController _scrollController = ScrollController();


  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return OrderDetailScreen(ordersLoadedStatus, item);
        }));
      },
      child: Container(
        margin: EdgeInsets.all(width * 0.01),
        child: Card(
          color: AppConfig.secondaryColor,
          elevation: 8,
          child: Container(
            child: Column(
              children: [
                Container(
                    decoration: BoxDecoration(
                      color: AppConfig.topOrderColor,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(10.0),
                        // Set top-right corner radius
                        topLeft: Radius.circular(
                            10.0), // Set top-right corner radius
                      ),
                    ),
                    height: AppConfig.calHeight(context, 8),
                    width: width * 0.97,
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: Row(
                        children: [
                          Container(
                              width: width * 0.4,
                              alignment: Alignment.center,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    ordersLoadedStatus.dateCreated! ==
                                            Jalali.now()
                                        ? "امروز"
                                        : "${(ordersLoadedStatus.dateCreated!.year.toString()).stringToPersianDigits()}/${(ordersLoadedStatus.dateCreated!.month).toString().stringToPersianDigits()}/${(ordersLoadedStatus.dateCreated!.day).toString().stringToPersianDigits()}",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: width * 0.03),
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
                              "${ordersLoadedStatus.billing!.lastName} ${ordersLoadedStatus.billing!.firstName} ",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: width * 0.03, color: Colors.white),
                              maxLines: 1,
                              minFontSize: 9,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Container(
                              width: width * 0.2,
                              /*color: Colors.red,*/
                              alignment: Alignment.centerLeft,
                              child: Text(
                                  "سفارش ${(ordersLoadedStatus.id.toString()).toString().stringToPersianDigits()}",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: width * 0.03,
                                  ))),
                        ],
                      ),
                    )),
                Container(
                  height: height * 0.15,
                  width: width * 0.9,
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 8.0, right: 8.0, top: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "جمع",
                              style: TextStyle(
                                  fontSize: width * 0.03, color: Colors.white),
                            ),
                            Text( formatFaThousands(ordersLoadedStatus.total).toString().stringToPersianDigits(),
                                style: TextStyle(
                                    fontSize: width * 0.03,
                                    color: Colors.white)),
                          ],
                        ),
                      ),
                      Container(
                        width: width * 1,
                        height: 1,
                        child: Container(
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                          colors: [
                            AppConfig.firstLinearColor,
                            AppConfig.secondLinearColor,
                          ],
                        ))),
                      ),
                      Row(
                        children: [
                          Container(
                            width: width * 0.9,
                            height: height * 0.06,
                            child: Scrollbar(
                              thumbVisibility: true,
                              thickness: 4.0, // Adjust width

                              controller: _scrollController,
                              radius: Radius.circular(3.0),
                              child: ListView.builder(
                                  controller: _scrollController,

                                  itemCount: ordersLoadedStatus.lineItems!.length,
                                  itemBuilder: (context, index) {
                                    return Row(
                                      children: [
                                        Container(
                                            width: width * 0.02,
                                            alignment: Alignment.center,
                                            child: Text(
                                                formatFaThousands( ordersLoadedStatus
                                                    .lineItems![index].quantity.toString()).toString().stringToPersianDigits(),
                                                style: TextStyle(
                                                    fontSize: width * 0.03,
                                                    color: Colors.white))),
                                        Container(
                                            alignment: Alignment.center,
                                            //  color: Colors.pink,
                                            width: width * 0.05,
                                            child: Text("×",
                                                style: TextStyle(
                                                    fontSize: width * 0.03,
                                                    color: Colors.white))),
                                        FittedBox(
                                            fit: BoxFit.scaleDown,
                                            child: SingleChildScrollView(
                                              child: Container(
                                                width: width * 0.8,
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Container(
                                                      width: width * 0.8,
                                                      alignment:
                                                          Alignment.centerRight,
                                                      child: AutoSizeText(
                                                        ordersLoadedStatus
                                                            .lineItems![index]
                                                            .name
                                                            .toString(),
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                            fontSize:
                                                                width * 0.03,
                                                            color: Colors.white),
                                                        maxLines: 1,
                                                        minFontSize: 9,
                                                        overflow:
                                                            TextOverflow.ellipsis,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            )),
                                      ],
                                    );
                                  }),
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
      ),
    );
  }
}

class orderData {
  final OrdersEntity ordersLoadedStatus;
  final int item;

  orderData({required this.ordersLoadedStatus, required this.item});
}
