import 'package:flutter/material.dart';
import 'package:shapyar_bloc/core/utils/static_values.dart';
import 'package:shapyar_bloc/features/feature_home/presentation/widgets/drawer.dart';
import 'package:shapyar_bloc/features/feature_orders/domain/entities/orders_entity.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:jdate/jdate.dart';
import 'features/feature_home/presentation/screens/home-screen.dart';
import 'features/feature_orders/presentation/widgets/order_options.dart';

class OrderDetailScreen extends StatelessWidget {
  static const routeName = "/orders_detail_screen";
  final OrdersEntity ordersLoadedStatus;
  final int item;

  OrderDetailScreen(this.ordersLoadedStatus, this.item);

  String selectedStatus = '';

  @override
  Widget build(BuildContext context) {
    // final args = ModalRoute.of(context)!.settings.arguments as orderData;
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    var ordersData = ordersLoadedStatus;
    var dateCreated = JDate(ordersData.dateCreated!.year,
        ordersData.dateCreated!.month, ordersData.dateCreated!.day)
        .echo('d F Y') ??
        "";

    return Scaffold(
      backgroundColor: Colors.white,
      /* floatingActionButton: FloatingActionButton(
        onPressed: () {
          //  Navigator.pushNamed(context,AddOrder.routeName);
        },
        backgroundColor: Color(0xff0A369D),
        child: IconButton(
          icon: Icon(
            Icons.picture_as_pdf,
            color: Colors.white,
          ),
          onPressed: () {
            //  Navigator.pushNamed(context,HomeScreen.routeName);
          }, //productsLoadedStatus.productsDataState![0].name.toString()
        ),
      ),*/
      appBar: AppBar(
        title: Text(
          'سفارش ${ordersData.id}',
          style: TextStyle(fontSize: height * 0.03),
        ),
        backgroundColor: Colors.white,
        // Match app bar color with background
        elevation: 0.0,
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            OrderOptions(context, ordersData);
          },
        ),
        actions: [
          /*GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return Container();
              }));
              //   Navigator.pushNamed(context, EditOrder.routeName, arguments: OrderDetailScreenData(ordersEntity: ordersData, lineItem: ordersData.lineItems));
            },
            child: Container(
              alignment: Alignment.center,
              width: width * 0.19,
              height: height * 0.05,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black26),
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: Text(
                "ویرایش",
                style: TextStyle(color: Colors.black, fontSize: width * 0.032),
              ),
            ),
          ),
          SizedBox(
            width: width * 0.03,
          ),
          GestureDetector(
            onTap: () {
              showFilterBottomSheet(context, (value) {
                selectedStatus = value;
              }, ordersData.id, selectedStatus);
            },
            child: Container(
              alignment: Alignment.center,
              width: width * 0.19,
              height: height * 0.05,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black26),
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: Text(
                "تغییر وضعیت",
                style: TextStyle(color: Colors.black, fontSize: width * 0.032),
              ),
            ),
          ),
          SizedBox(
            width: width * 0.03,
          ),*/
          IconButton(
            icon: Icon( Icons.arrow_forward ),
            onPressed: () {
              Navigator.pushNamed(context,HomeScreen.routeName);
            }, //productsLoadedStatus.productsDataState![0].name.toString()
          ),
        ], // Remove shadow for a seamless look
      ),
      body: Stack(
        children: [
          Container(
            width: width,
            height: height,
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: EdgeInsets.only( bottom: width * 0.048),
              alignment: Alignment.center,
              width: width * 0.7,
              height: height * 0.085,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                color: Color(0xff0A369D),
              ),
              child: Text(
                "${ordersData.total} ریال",
                style: TextStyle(color: Colors.white, fontSize: width * 0.055),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(width * 0.04),
            width: width,
            height: height,
            // color: Colors.white30,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        alignment: Alignment.centerRight,
                        child: Row(
                          children: [
                            Text(
                              "تاریخ سفارش: ",
                              style: TextStyle(color: Colors.black54),
                            ),
                            Text(
                              dateCreated,
                              style: TextStyle(color: Colors.black),
                            ),
                          ],
                        ),
                        /*color: Colors.green,*/
                      ),
                      Container(
                        width: width * 0.4,
                        alignment: Alignment.center,
                        child: Text(
                          StaticValues
                              .status['wc-${ordersData.status}']
                              .toString(),
                          style: TextStyle(color: Colors.green),
                        ),
                        /*    color: Colors.pink,*/
                      ),
                    ],
                  ),
                  SizedBox(
                    height: width * 0.02,
                  ),

                  Divider(),
                  SizedBox(
                    height: width * 0.02,
                  ),
                  Container(
                    height: ordersData.lineItems!.length == 1
                        ? height * 0.12
                        : ordersData.lineItems!.length == 2
                        ? height * 0.25
                        : height * 0.38,
                    child: ListView.builder(
                        itemCount: ordersData.lineItems!.length,
                        itemBuilder: (context, index) {
                          return Container(
                            width: width * 0.5,
                            height: height * 0.1,
                            margin: EdgeInsets.all(width * 0.013),
                            child: Row(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                    border: Border.all(color: Colors.black38),
                                  ),
                                  width: width * 0.2,
                                  height: height * 0.2,
                                  padding: EdgeInsets.all(width * 0.013),
                                  child: ordersData.lineItems![index].img
                                      .toString() ==
                                      null
                                      ? Image.network(ordersData
                                      .lineItems![index].img
                                      .toString())
                                      : Image.asset("assets/images/index.png"),
                                ),
                                SizedBox(
                                  width: width * 0.02,
                                ),
                                Column(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Container(
                                      width: width * 0.6,
                                      child: AutoSizeText(
                                        ordersData.lineItems![index].name,
                                        textAlign: TextAlign.right,
                                        style: TextStyle(
                                            fontSize: width * 0.04,
                                            color: Colors.black),
                                        maxLines: 1,
                                        minFontSize: 9,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Container(
                                      alignment: Alignment.centerRight,
                                      /*      color: Colors.white24,*/
                                      width: width * 0.6,
                                      child: Row(
                                        children: [
                                          Text(
                                            " قیمت: ${ordersData
                                                .lineItems![index].total} تومان",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(
                                            width: width * 0.02,
                                          ),
                                          Container(
                                            height: width * 0.05,
                                            width: width * 0.002,
                                            color: Colors.black38,
                                          ),
                                          SizedBox(
                                            width: width * 0.02,
                                          ),
                                          Text(
                                            "تعداد: ${ordersData
                                                .lineItems![index].quantity}",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ), /*  color: Colors.grey,*/
                          );
                        }),
                    /*color: Colors.yellow,*/
                  ),
                  SizedBox(
                    height: width * 0.02,
                  ),
                  Divider(),
                  SizedBox(
                    height: width * 0.02,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        alignment: Alignment.centerRight,
                        /*color: Colors.red,*/
                        width: width * 0.4,
                        height: height * 0.22,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              "مشخصات صورتحساب: ",
                              style: TextStyle(color: Colors.black54),
                            ),
                            AutoSizeText(
                              '${ordersData.shipping!.firstName} ${ordersData.shipping!.lastName}',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: width * 0.04),
                              maxLines: 1,
                              minFontSize: 9,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              ordersData.shipping!.phone,
                              style: TextStyle(color: Colors.black),
                            ),
                            Text(
                              ordersData.shipping!.state,
                              style: TextStyle(color: Colors.black),
                            ),
                            AutoSizeText(
                              ordersData.shipping!.address1,
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: width * 0.04),
                              maxLines: 2,
                              minFontSize: 9,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerRight,
                        /*      color: Colors.yellow,*/
                        width: width * 0.4,
                        height: height * 0.22,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              "روش پرداخت: ",
                              style: TextStyle(color: Colors.black54),
                            ),
                            Text(
                              ordersData.paymentMethodTitle.toString(),
                              style: TextStyle(color: Colors.black),
                            ),
                            Text(
                              "روش حمل و نقل: ",
                              style: TextStyle(color: Colors.black54),
                            ),
                            Text(
                              ordersData.shippingLines![0].methodTitle
                                  .toString(),
                              style: TextStyle(color: Colors.black),
                            ),
                            Text(
                              "هزینه حمل و نقل: ",
                              style: TextStyle(color: Colors.black54),
                            ),
                            Text(
                              "ثبت نشده",
                              style: TextStyle(color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
} /*
class OrderDetailScreenData{
  final OrdersEntity ordersEntity;
  final List<LineItem>? lineItem;

   OrderDetailScreenData({required this.ordersEntity,required this.lineItem});
}*/
