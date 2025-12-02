import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shopyar/core/utils/static_values.dart';
import 'package:shopyar/extension/persian_digits.dart';
import 'package:shopyar/features/feature_orders/domain/entities/orders_entity.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:jdate/jdate.dart';
import '../../../../core/config/app-colors.dart';
import 'package:intl/intl.dart';
import '../widgets/order_options.dart';

class OrderDetailScreen extends StatelessWidget {
  static const routeName = "/orders_detail_screen";
  final OrdersEntity ordersLoadedStatus;
  final int item;

  OrderDetailScreen(this.ordersLoadedStatus, this.item);

  String selectedStatus = '';
  String chosenProductUrl = '';

  String formatFaThousands(dynamic value) {
    final n = (value is num) ? value : num.tryParse(value.toString()) ?? 0;
    return NumberFormat.decimalPattern('fa').format(n);
  }
  final ScrollController _scrollController = ScrollController();

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
      appBar: AppBar(
        title: Text(
            'سفارش ${ordersData.id.toString().stringToPersianDigits()}',
          style: TextStyle(fontSize: AppConfig.calTitleFontSize(context),color: AppConfig.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.menu,color: AppConfig.white),
          onPressed: () {
            OrderOptions(context, ordersData, item, ordersLoadedStatus);
          },
        ),
        actions: [

            IconButton(
                  icon: Icon( Icons.arrow_forward ,color: AppConfig.white),
                  onPressed: () {
                    Navigator.pop(context);
               //     Navigator.pushNamed(context,OrdersScreen.routeName);
                  }, //productsLoadedStatus.productsDataState![0].name.toString()
                ),
        ], // Remove shadow for a seamless look
      ),
      body: Container(
        color: AppConfig.backgroundColor,
        child: Stack(
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
                  borderRadius: BorderRadius.all(Radius.circular(8),),
                  color:AppConfig.secondaryColor,
                ),
                child: Text(
                  "${formatFaThousands(ordersData.total).toString().stringToPersianDigits()} ریال",
                  style: TextStyle(color: Colors.white, fontSize: AppConfig.calFontSize(context, 6)),
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
                                style: TextStyle(color: AppConfig.white70,fontSize: AppConfig.calFontSize(context, 4)),
                              ),
                              Text(
                                dateCreated.toString().stringToPersianDigits(),
                                style: TextStyle(color: AppConfig.white,fontSize: AppConfig.calFontSize(context, 4)),
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
                            style: TextStyle(color: AppConfig.contentColorGreen,fontSize: AppConfig.calFontSize(context, 4)),
                          ),
                          /*    color: Colors.pink,*/
                        ),
                      ],
                    ),
                    SizedBox(
                      height: width * 0.02,
                    ),

                Container(
                    margin: EdgeInsets.all(AppConfig.calWidth(context, 2)),
                  width: width*1,
                  height: 1,
                    decoration: BoxDecoration(
                        gradient:LinearGradient(
                          colors: [AppConfig.firstLinearColor, AppConfig.secondLinearColor],)
                    )
                ),
                    SizedBox(
                      height: width * 0.02,
                    ),
                    Container(
                      height: ordersData.lineItems!.length == 1
                          ? height * 0.12
                          : ordersData.lineItems!.length == 2
                              ? height * 0.25
                              : height * 0.38,
                      child: Scrollbar(
                        thumbVisibility: true,
                        thickness: 4.0,
                        controller: _scrollController,
                        radius: Radius.circular(3.0),
                        child: ListView.builder(
                          controller: _scrollController,
                            itemCount: ordersData.lineItems!.length,
                            itemBuilder: (context, index) {
                              final imageMap = ordersData.lineItems![index].image;

                              final imageUrl = (imageMap != null && imageMap["full"] != null)
                                  ? imageMap["full"].toString()
                                  : "";
                              return Container(
                                width: width * 0.5,
                                height: height * 0.1,
                                margin: EdgeInsets.all(width * 0.013),
                                child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.all(Radius.circular(10)),
                                        border: Border.all(color: AppConfig.white),
                                      ),
                                      width: width * 0.2,
                                      height: height * 0.2,
                                      padding: EdgeInsets.all(width * 0.013),
                                      child: imageUrl.isNotEmpty
                                          ? Image.network(
                                        imageUrl,
                                        errorBuilder: (context, error, stackTrace) =>
                                        const SizedBox.shrink(),
                                      )
                                          : const SizedBox.shrink(),
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
                                                fontSize:  AppConfig.calFontSize(context, 3.6),
                                                color:  AppConfig.white),
                                            maxLines: 1,
                                            minFontSize: (AppConfig.calFontSize(context, 2.5).round()).toDouble(),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        Container(
                                          alignment: Alignment.centerRight,
                                                color: Colors.white24,
                                          width: width * 0.6,
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Container(

                                                width: width*0.4,


                                                child: AutoSizeText(

                                                  " قیمت: ${formatFaThousands(ordersData
                                                      .lineItems![index].total).toString().stringToPersianDigits()} ریال",
                                                  textAlign: TextAlign.right,
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.bold,color: AppConfig.white70,fontSize: AppConfig.calFontSize(context, 4.1)),

                                                  maxLines: 1,
                                                  minFontSize: width*0.01.toInt(),
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),

                                              Container(
                                                height: width * 0.05,
                                                width: width * 0.002,
                                                color: AppConfig.white,
                                              ),

                                              Text(
                                                "تعداد: ${ordersData
                                                        .lineItems![index].quantity.toString().stringToPersianDigits()}",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,color: AppConfig.white70,fontSize: AppConfig.calFontSize(context, 3.6)),
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
                      ),
                      /*color: Colors.yellow,*/
                    ),
                    SizedBox(
                      height: width * 0.02,
                    ),
                    Container(
                      margin: EdgeInsets.all(AppConfig.calWidth(context, 2)),
                        width: width*1,
                        height: 1,
                        decoration: BoxDecoration(
                            gradient:LinearGradient(
                              colors: [AppConfig.firstLinearColor, AppConfig.secondLinearColor],)
                        )
                    ),
                    SizedBox(
                      height: width * 0.02,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          alignment: Alignment.centerRight,
                         // color: Colors.red,
                          width: width * 0.4,
                          height: height * 0.22,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            spacing:  AppConfig.calHeight(context, 0.7),
                            children: [
                              Text(
                                "مشخصات صورتحساب: ",
                                style: TextStyle(color: AppConfig.white70,fontSize: AppConfig.calFontSize(context, 4)),
                              ),
                              AutoSizeText(
                                '${ordersData.shipping!.lastName} ${ordersData.shipping!.firstName}',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: AppConfig.calFontSize(context, 3.7),color: AppConfig.white),
                                maxLines: 1,
                                minFontSize: 9,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                ordersData.shipping!.phone.stringToPersianDigits(),
                                style: TextStyle(color: AppConfig.white,fontSize: AppConfig.calFontSize(context, 3.7)),
                              ),
                              Text(
                                ordersData.shipping!.state,
                                style: TextStyle(color: AppConfig.white,fontSize: AppConfig.calFontSize(context, 3.7)),
                              ),
                              AutoSizeText(
                                ordersData.shipping!.address1,
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: AppConfig.calFontSize(context, 3.7),color: AppConfig.white),
                                maxLines: 2,
                                minFontSize: 9,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          alignment: Alignment.centerRight,
                            //    color: Colors.green,
                          width: width * 0.4,
                          height: height * 0.24,
                          child: Column(
                            spacing:  AppConfig.calHeight(context, 0.7),
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(
                                "روش پرداخت: ",
                                style: TextStyle(color: AppConfig.white70,fontSize: AppConfig.calFontSize(context, 4)),
                              ),
                              Text(
                                ordersData.paymentMethodTitle.toString(),
                                style: TextStyle(color: AppConfig.white,fontSize: AppConfig.calFontSize(context, 3.7)),
                              ),
                              Text(
                                "روش حمل و نقل: ",
                                style: TextStyle(color: AppConfig.white70,fontSize: AppConfig.calFontSize(context, 4)),
                              ),
                              Text(
                                ordersData.shippingLines!.isEmpty?'':  ordersData.shippingLines![0].methodTitle
                                    .toString(),
                                style: TextStyle(color: AppConfig.white,fontSize: AppConfig.calFontSize(context, 3.7)),
                              ),
                              Text(
                                "هزینه حمل و نقل: ",
                                style: TextStyle(color: AppConfig.white70,fontSize: AppConfig.calFontSize(context, 4)),
                              ),
                              Text(
                                formatFaThousands(ordersData.shippingPrice.toString().stringToPersianDigits()),
                                style: TextStyle(color:AppConfig.white,fontSize: AppConfig.calFontSize(context, 3.7)),
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
      ),
    );
  }
} /*
class OrderDetailScreenData{
  final OrdersEntity ordersEntity;
  final List<LineItem>? lineItem;

   OrderDetailScreenData({required this.ordersEntity,required this.lineItem});
}*/
