import 'dart:ui';
import 'package:shopyarfinal/provider/order-provider.dart';
import 'package:shopyarfinal/ui/utils/storeStatus.dart';
import 'package:shopyarfinal/values/colors.dart';
import 'package:flutter/material.dart';
import 'package:shopyarfinal/connect/wooConnect.dart';
import 'package:shopyarfinal/model/Orders.dart';
import 'package:shopyarfinal/ui/addOrder.dart';
import 'package:shopyarfinal/ui/alertDialog.dart';
import 'package:shopyarfinal/ui/pdfExport.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:jdate/jdate.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../provider/factorSetting-provider.dart';

class order extends StatefulWidget {
  order(List<Orders>? orders, this.index) : this.orders = orders ?? [];
  final List<Orders> orders;
  final int index;
  var edit = false;
  var confirm = false;

  @override
  State<order> createState() => _orderState();
}

class _orderState extends State<order> {
  var isLoad = false;
  final TextEditingController customerFN = TextEditingController();
  final TextEditingController customerLN = TextEditingController();
  final TextEditingController phone = TextEditingController();
  final TextEditingController status = TextEditingController();
  final TextEditingController paymentMethod = TextEditingController();
  final TextEditingController shippingMethod = TextEditingController();
  final TextEditingController city = TextEditingController();
  final TextEditingController state = TextEditingController();
  final TextEditingController addressDetail = TextEditingController();
  List<bool> toggleChioces = []; //content from sharedprefrences
  List<String> selectedOrderSample = [];
  List<String> selectedCustomerInf = [];
  List<String> orderSample = [];
  List<String> customerInf = [];
  int countOfSelectedOrder = 0;
  bool selectedAddressDetail = true;
  String ship = "";
  String shipPr = "";
  String? webService;
  String? consumerKey;
  String? shopName ;
  late Map<String, dynamic> statusData ={} ;


  Future<bool?> getData(BuildContext context) async {



    final prefs = await SharedPreferences.getInstance();
    consumerKey = prefs.getString('consumerKey');
    webService = prefs.getString('webService');
    shopName = prefs.getString('shopName');
    statusData = await getStoredData();

    var datePaid ;
    if (widget.orders![widget.index].datePaid == null) {
      datePaid = "";
    } else {
      Jalali jalaliDtaePaid = DateTime.parse(widget.orders![widget.index].datePaid!).toJalali();
      datePaid = JDate(jalaliDtaePaid.year , jalaliDtaePaid.month, jalaliDtaePaid.day) ;
    }

    var dateCreated ;
    if (widget.orders![widget.index].dateCreated == null) {
      dateCreated = "";
    } else {
      dateCreated = JDate((widget.orders![widget.index].dateCreated!.year) , widget.orders![widget.index].dateCreated!.month, widget.orders![widget.index].dateCreated!.day) ;
    }


    if(widget.orders![widget.index].shippingLines.isNotEmpty){
      ship = widget.orders![widget.index].shippingLines[0].name.toString();
      shipPr = widget.orders![widget.index].shippingLines[0].total.toString();
    }

    orderSample = [
      //content from AI
      widget.orders![widget.index].billing.phone.toString(),
      statusData['wc-${widget.orders![widget.index].status}'],
      widget.orders![widget.index].paymentMethodTitle.toString(),
      ship,
      dateCreated == "" ? "" : dateCreated.echo('d F Y'),
      datePaid == "" ? "" : datePaid.echo('d F Y'),
      widget.orders![widget.index].billing.city != ""
          ? "${widget.orders![widget.index].billing.city}، ${widget.orders![widget.index].billing.state}"
          : ""
    ];
    customerInf = [
      'شماره تماس',
      'وضعیت',
      'روش پرداخت',
      'روش حمل و نقل',
      'تاریخ ثبت سفارش',
      'تاریخ پرداخت',
      'آدرس ارسال',
    ];



    selectedAddressDetail =prefs?.getBool('toggle_choice_7') ?? false;
    selectedOrderSample.clear();
    selectedCustomerInf.clear();
    for (int i = 0; i <customerInf.length; i++) {
      toggleChioces.add(prefs?.getBool('toggle_choice_$i') ?? false);
      if (toggleChioces[i]) {
        selectedOrderSample.add(orderSample[i]);
        selectedCustomerInf.add(customerInf[i]);
        if(customerInf[i].contains("روش حمل و نقل")){
          selectedCustomerInf.add('مبلغ حمل و نقل');
          selectedOrderSample.add(shipPr);
        }

      }
    }
    return prefs?.getBool('toggle_choice_0');
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData(context);
    setState(() {
      isLoad = true;
    });
  }

  final _formKey = GlobalKey<FormState>();
  List<String> finalOrder = [];


  @override
  Widget build(BuildContext context) {

    final double appBarHeight = AppBar().preferredSize.height;
    return SafeArea(
      child: ChangeNotifierProvider(
        create: (_) => factorSettingProvider(),
        child:  FutureBuilder<bool?>(
            future: getData(context),
            builder: (BuildContext context,  AsyncSnapshot<bool?> snapshot){
              if (snapshot.connectionState ==
                  ConnectionState.waiting) {
                // While the future is loading
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                // If an error occurred
                return Text('Error: ${snapshot.error}');
              }else{

                return Sizer(builder: (context, orientation, deviceType) {
                  return Scaffold(
                    floatingActionButton:  FloatingActionButton(backgroundColor: colorVlaue.primaryColor,
                      child:  Consumer<factorSettingProvider>(builder:
                          (context, factorSettingProvider, _) {
                        return IconButton(
                            onPressed: () {

                              pdfExport(
                                  widget.orders,
                                  widget.index,
                                  factorSettingProvider.font,
                                  factorSettingProvider
                                      .textField[0],
                                  factorSettingProvider
                                      .textField[1],
                                  factorSettingProvider
                                      .textField[2],
                                  factorSettingProvider
                                      .textField[3],
                                  factorSettingProvider
                                      .textField[4],shopName);
                              //   Navigator.of(context).push(MaterialPageRoute(builder: (context){return PdfPreviewPage();}));
                            },
                            icon: Icon(
                              Icons.picture_as_pdf,
                              color: Colors.white,
                            ));
                      }),
                      onPressed: (){},
                    ),
                    appBar: PreferredSize(
                      preferredSize: Size.fromHeight(appBarHeight)/1.3,
                      child: AppBar(
                        backgroundColor: colorVlaue.primaryColor,
                        centerTitle: true,
                        leading: IconButton(
                          icon: Icon(Icons.arrow_back_ios,color: Colors.white),
                          onPressed: () {
                            Navigator.of(context).pop(); // Navigate back when the back arrow is pressed
                          },
                        ),
                        title: Text("سفارش شماره " +
                            widget.orders![widget.index].id
                                .toString(),style: TextStyle(fontSize: 3.5.w,color: Colors.white),), // Replace with your desired title
                        actions: [
                          IconButton(
                            icon: Icon(Icons.edit,color: Colors.white,),
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context){
                                return addOrder(orders: widget.orders,index: widget.index,orderId: widget.orders[widget.index].lineItems[0].orderId,);
                              }));
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.change_circle_sharp,color: Colors.white,),
                            onPressed: () {
                              showModalBottomSheet(
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                    BorderRadius.vertical(
                                      top: Radius.circular(2.h),
                                    ),
                                  ),
                                  context: context,
                                  builder: (context) {
                                    // mainpageProvider.checkIsPendingFilter();
                                    return Builder(builder:
                                        (BuildContext context) {
                                      return bottomSheet(orders: widget.orders,index:widget.index,webService: webService,consumerKey: consumerKey,statusData: statusData,);
                                    });
                                  });
                            },
                          ),

                        ],
                      ),
                    ),
                    backgroundColor:colorVlaue.primaryColor,
                    body: Container(
                      alignment: Alignment.center,
                      //   height: 40.h,
                      child: Stack(
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                  padding: EdgeInsets.all(3.w),
                                  margin: EdgeInsets.only(top: 3.w),
                                  decoration: BoxDecoration(
                                      color: colorVlaue.fifthColor,
                                      borderRadius: BorderRadius.circular(10)),
                                  height: 26.h,
                                  width: 85.w,
                                  alignment: Alignment.centerRight,

                                  child: Column(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Container(alignment: Alignment.centerRight,
                                          width: 100.w, //height: 01.h,
                                          child: widget.orders![widget.index]
                                              .billing.firstName +
                                              " " +
                                              widget
                                                  .orders![widget.index]
                                                  .billing
                                                  .lastName !=
                                              ""
                                              ? Text(
                                            "${"خریدار"} : ${widget.orders![widget.index].billing.firstName + " " + widget.orders![widget.index].billing.lastName}",
                                            style: TextStyle(
                                              fontFamily: "IRANSansWeb",
                                              color: Colors.black,
                                              fontSize: 1.3.h,
                                            ),
                                            // textAlign: TextAlign.center,
                                            textDirection:
                                            TextDirection.rtl,
                                          )
                                              : Text(
                                            "${"خریدار"} : درج نشده است!",
                                            style: TextStyle(
                                              fontFamily: "IRANSansWeb",
                                              color: Colors.black,
                                              fontSize: 1.3.h,
                                            ),
                                            textDirection:
                                            TextDirection.rtl,
                                          )),
                                      Expanded(
                                        child: Column(
                                            mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                            children: List.generate(
                                                selectedOrderSample.length ,
                                                    (index) => SizedBox(
                                                    width: 100.w, //height: 01.h,
                                                    child: selectedOrderSample[
                                                    index] !=
                                                        ""
                                                        ? Text(
                                                      "${selectedCustomerInf[index]} : ${selectedOrderSample[index]}",
                                                      style: TextStyle(
                                                        fontFamily:
                                                        "IRANSansWeb",
                                                        color:
                                                        Colors.black,
                                                        fontSize:  1.3.h,
                                                      ),
                                                      // textAlign: TextAlign.center,
                                                      textDirection:
                                                      TextDirection
                                                          .rtl,
                                                    )
                                                        : Text(
                                                      "${selectedCustomerInf[index]} : درج نشده است!",
                                                      style: TextStyle(
                                                        fontFamily:
                                                        "IRANSansWeb",
                                                        color:
                                                        Colors.black,
                                                        fontSize:  1.3.h,
                                                      ),
                                                      textDirection:
                                                      TextDirection
                                                          .rtl,
                                                    )))),
                                      ),
                                    ],
                                  )
                              ),
                              Visibility(
                                visible: selectedAddressDetail,
                                child: Container(
                                  margin: EdgeInsets.all(2.w),
                                  decoration: BoxDecoration(
                                      color: colorVlaue.thirdColor,
                                      borderRadius: BorderRadius.circular(10)),
                                  height: 8.h,
                                  width: 80.w,
                                  alignment: Alignment.centerRight,
                                  child: Column(
                                    children: [
                                      Container(
                                        margin: EdgeInsets.only(top: 2.w, right: 2.w),
                                        alignment: Alignment.centerRight,
                                        child: Text(
                                          ": جزئیات آدرس",
                                          style: TextStyle(
                                            decoration: TextDecoration.none,
                                            fontSize: 1.3.h,
                                            fontFamily: "IRANSansWeb",
                                            color: Colors.black54,
                                          ),
                                        ),
                                      ), Container(padding: EdgeInsets.all(1.h),
                                        height: 4.h,
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: SingleChildScrollView(
                                                child: Text( widget.orders![widget.index]
                                                    .shipping.address1
                                                    .toString() ==
                                                    ""
                                                    ? "جزئیات آدرس درج نشده است!"
                                                    : widget.orders![widget.index]
                                                    .shipping.state + "، " + widget.orders![widget.index]
                                                    .shipping.city + "، " +
                                                    widget.orders![widget.index]
                                                        .shipping.address1
                                                        .toString()
                                                        .toString(),
                                                  style: TextStyle(
                                                    fontSize:  1.3.h,
                                                    fontFamily: "IRANSansWeb",
                                                  ),
                                                  softWrap: true,
                                                  maxLines: 2,
                                                  overflow: TextOverflow.fade,
                                                  textDirection: TextDirection.rtl,
                                                ),
                                              ),

                                            ),
                                          ],
                                        ),
                                      ),

                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                child: MediaQuery.removePadding(
                                  context: context,
                                  removeBottom: true,
                                  removeTop: true,
                                  removeLeft: true,
                                  removeRight: true,
                                  child: Container(
                                    margin: EdgeInsets.only(top: 0.7.w),
                                    alignment: Alignment.center,
                                    //height: 51.5.h,
                                    // width: 100.h,
                                    decoration: BoxDecoration(
                                      color: const Color(0xffefefef),
                                      borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(3.w),
                                        topLeft: Radius.circular(3.w),
                                      ),
                                    ),
                                    child: SizedBox(
                                      // padding: EdgeInsets.only(left: 2.6.w),
                                      // color: Colors.red,
                                      //     height: 50.h,
                                      width: 94.w,
                                      child: ListView.builder(
                                        // scrollDirection: Axis.horizontal,
                                          itemCount: widget
                                              .orders![widget.index].lineItems.length,
                                          itemBuilder: (context, index) {
                                            return Container(
                                              // padding: EdgeInsets.only(top: 2.w),

                                              alignment: Alignment.centerRight,
                                              //   height: 50.h,
                                              width: 80.w,
                                              child: Card(
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                    BorderRadius.circular(2.h)),
                                                elevation: 0.5.h,
                                                child: Container(
                                                  alignment: Alignment.centerRight,
                                                  margin: EdgeInsets.all(2.w),
                                                  //color: Colors.blueAccent,
                                                  height: 10.h,
                                                  width: 90.w,
                                                  child: Column(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment.spaceEvenly,
                                                    children: [
                                                      SizedBox(
                                                        height: 1.h,
                                                      ),
                                                      /* Container(
                                                    child: Image.asset("asset/index.png"),
                                                    height: 20.h,
                                                    width: 40.w,
                                                  ),*/
                                                      makeColumnForEachOrder(
                                                          key1: "محصول",
                                                          value: widget
                                                              .orders[widget.index]
                                                              .lineItems[index]
                                                              .name),
                                                      makeColumnForEachOrder(
                                                          key1: "تعداد خریداری شده",
                                                          value: widget
                                                              .orders[widget.index]
                                                              .lineItems[index]
                                                              .quantity
                                                              .toString()),
                                                      makeColumnForEachOrder(
                                                          key1: "قیمت کل",
                                                          value: widget
                                                              .orders[widget.index]
                                                              .lineItems[index]
                                                              .total
                                                              .toString()),

                                                      //  makeColumn(key1: "روش پرداخت", value: orders![index].paymentMethodTitle.toString()),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            );
                                          }),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Positioned(
                            //alignment: Alignment.bottomCenter,
                            // color: Colors.red,
                            bottom: 3.5.h,
                            right: 25.w, left: 9.w,
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(3.w),
                                  color: Colors.black87),
                              height: 6.h,
                              //     width: 50.w,
                              child: Container(
                                margin: EdgeInsets.all(2.w),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  textDirection: TextDirection.rtl,
                                  children: [
                                    Container(
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                        'مجموع سفارشات',
                                        style: TextStyle(
                                            fontSize: 3.w,
                                            fontFamily: "IRANSansWeb",
                                            color: Colors.white),
                                      ),
                                    ),
                                    Row(
                                      textDirection: TextDirection.rtl,
                                      children: [
                                        Text(formatPrice(int.parse(widget.orders![widget.index].total)),
                                            style: TextStyle(
                                                fontFamily: "IRANSansWeb",
                                                fontSize: 4.w,
                                                color: Colors.white)),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                });}}
        ),
      ),
    );
  }
}

class makeColumn extends StatelessWidget {
  final String key1;
  final String value;
  final bool visible;

  const makeColumn(
      {required this.key1, required this.value, required this.visible});

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: visible,
      child: Container(
        child: SizedBox(
            width: 45.w,
            child: value != ""
                ? Text(
              "$key1 : $value",
              style: TextStyle(
                fontFamily: "IRANSansWeb",
                color: Colors.black,
                fontSize: 1.5.h,
              ),
              // textAlign: TextAlign.center,
              textDirection: TextDirection.rtl,
            )
                : Text(
              "$key1 : درج نشده است!",
              style: TextStyle(
                fontFamily: "IRANSansWeb",
                color: Colors.black,
                fontSize: 1.5.h,
              ),
              textDirection: TextDirection.rtl,
            )),
      ),
    );
  }
}

class makeColumnForEachOrder extends StatelessWidget {
  final String key1;
  final String value;

  const makeColumnForEachOrder({
    required this.key1,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SizedBox(
          width: 75.w,
          child: value != ""
              ? Text(
            "$key1 : $value",
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              decoration: TextDecoration.none,
              fontSize: 2.5.w,
              fontFamily: "IRANSansWeb",
              color: Colors.black54,
            ),
            // textAlign: TextAlign.center,
            textDirection: TextDirection.rtl,
          )
              : Text(
            key1 + " : " + "درج نشده است",
            style: TextStyle(
              decoration: TextDecoration.none,
              fontSize: 2.5.w,
              fontFamily: "IRANSansWeb",
              color: Colors.black54,
            ),
          )),
    );
  }
}

class makeColumnForEditOrder extends StatelessWidget {
  final String key1;
  final String value;
  final bool visible;
  final TextEditingController controller;

  const makeColumnForEditOrder(
      {required this.key1,
        required this.value,
        required this.controller,
        required this.visible});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Visibility(
          visible: visible,
          child: Container(
              child: Icon(
                Icons.edit,
                color: Colors.grey.shade600,
              )),
        ),
        Container(
          alignment: Alignment.centerRight,
          width: 35.w,
          child: Material(
              child: TextField(
                textAlign: TextAlign.center,
                textDirection: TextDirection.rtl,
                controller: controller,
                decoration: InputDecoration(
                    hintText: value == "" || value == "null" || value == " "
                        ? "-"
                        : value,
                    fillColor: colorVlaue.primaryColor,
                    hintStyle: TextStyle(
                      decoration: TextDecoration.none,
                      fontSize: 2.5.w,
                      fontFamily: "IRANSansWeb",
                      color: Colors.black54,
                    )),
              )),
        ),
        Container(
          alignment: Alignment.centerRight,
          width: 20.w,
          child: Text(":" + key1,
              style: TextStyle(
                decoration: TextDecoration.none,
                fontSize: 2.2.w,
                fontFamily: "IRANSansWeb",
                color: Colors.black54,
              ),
              textAlign: TextAlign.start),
        ),
      ],
    );
  }
}


class bottomSheet extends StatefulWidget {
  List<Orders> orders = [];
  int index ;
  String? webService;
  String? consumerKey;
  late Map<String,dynamic> statusData ={};
  bottomSheet({required this.orders,required this.index,required this.webService,required this.consumerKey,required this.statusData});


  @override
  State<bottomSheet> createState() => _bottomSheetState();
}

class _bottomSheetState extends State<bottomSheet> {
  String status = "";

  @override
  Widget build(BuildContext context) {

    var orderprovider = Provider.of<orderProvider>(context);
    return  ChangeNotifierProvider(
      create: (context)=>orderProvider(),
      child: Stack(
        children: [
          SizedBox(
              width: 100.w,
              height: 50.h,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 1.h),
                    width: 20.w,
                    height: 1.h,
                    decoration: BoxDecoration(
                        color: colorVlaue.secondaryHeader,
                        borderRadius: BorderRadius.circular(10.h)),
                  ),
                  Container(
                    margin: EdgeInsets.all(2.h),
                    // width: 20.w,
                    // height: 1.h,,
                    child: Text(":تغییر وضعیت سفارش به",style: TextStyle(fontSize: 3.3.w),),
                  ),
                  Container(height:40.h,
                    child: SingleChildScrollView(
                      child: Column(children: widget.statusData.keys.map<Widget>((key) {
                        final index = widget.statusData.keys.toList().indexOf(key); // Index of the current item
                        final persianValue = widget.statusData[key] ?? '';
                        final isSelected = index == orderprovider.selectedIndex;
                        return GestureDetector(
                          child: Container(
                            margin: EdgeInsets.only(bottom: 1.h),
                            width: 70.w,
                            height: 5.h,
                            decoration: BoxDecoration(
                                color: isSelected? colorVlaue.secondaryHeader:colorVlaue.thirdColor
                                , border: Border.all(color: colorVlaue.secondaryHeader),
                                borderRadius: BorderRadius.circular(2.h)),
                            child: Center(
                              child: Text(
                                persianValue,
                                style: TextStyle(
                                    fontSize: 1.5.h,
                                    color:isSelected?
                                    Colors.white: Colors.black
                                ),
                              ),
                            ),
                          ),
                          onTap: () async {
                            print(key);
                            orderprovider.selectedItem(index);
                            status = key;
                            orderprovider.setShowProgressBar(true);
                            bool res = false;

                            res = await connectToWoo().editStatus(widget.orders[widget.index],status,widget.webService,widget.consumerKey);
                            if(res == true){
                              orderprovider.setShowProgressBar(false);

                              alertDialog(context, "! وضعیت سفارش به ${ persianValue} تغییر کرد", 2, false);
                              //  Navigator.pop(context);


                              orderprovider.resetItem();
                            }else{
                              orderprovider.setShowProgressBar(false);
                              alertDialog(context, "! خطا در تغییر وضعیت سفارش", 2, true);
                              // Navigator.pop(context);
                              orderprovider.resetItem();
                            }

                          },
                        );
                      }).toList()
                      ),
                    ),
                  )

                ],
              )

          ),
          if (orderprovider.showProgressBar)
            Container(
              color: Colors.black.withOpacity(0.5), // Adjust opacity as needed
              width: double.infinity,
              height: double.infinity,
              child: Center(
                child: CircularProgressIndicator(), // Customize your progress indicator here
              ),
            ),
        ],
      ),
    );
  }
}



String formatPrice( price) {
  String formattedPrice = price.toStringAsFixed(0); // Format without decimal places

  String result = '';
  int count = 0;

  for (int i = formattedPrice.length - 1; i >= 0; i--) {
    result = formattedPrice[i] + result;
    count++;
    if (count % 3 == 0 && i > 0) {
      result = ',' + result;
    }
  }

  return result;
}