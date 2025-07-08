import 'package:flutter/material.dart';
import 'package:dropdown_button2/src/dropdown_button2.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shapyar_bloc/core/utils/static_values.dart';
import 'package:shapyar_bloc/features/feature_add_edit_order/data/models/add_order_data_model.dart';
import 'package:shapyar_bloc/features/feature_add_edit_order/presentation/bloc/add_order_bloc.dart';
import 'package:shapyar_bloc/features/feature_orders/domain/entities/orders_entity.dart';


class EditOrderBill extends StatelessWidget {

  final List<Function(String)> onTextChange;
  OrdersEntity ordersEntity;
  EditOrderBill( this.onTextChange, this.ordersEntity);

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController customerFN = TextEditingController();
  TextEditingController customerLN = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController city = TextEditingController();
  TextEditingController postalCode = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController customerFNBill = TextEditingController();
  TextEditingController customerLNBill = TextEditingController();
  TextEditingController addressBill = TextEditingController();
  TextEditingController cityBill = TextEditingController();
  TextEditingController postalCodeBill = TextEditingController();
  TextEditingController emailBill = TextEditingController();
  TextEditingController phoneBill = TextEditingController();
  TextEditingController shipPrice = TextEditingController();

  /*String customerFNString ='';
  String customerLNString = '';
  String addressString = '';
  String cityString = '';
  String postalCodeString = '';
  String emailString = TextEditingController();
  String phoneString = TextEditingController();
  String customerFNBillString = TextEditingController();
  String customerLNBillString = TextEditingController();
  String addressBillString = TextEditingController();
  String cityBillString = TextEditingController();
  String postalCodeBillString = TextEditingController();
  String emailBillString = TextEditingController();
  String phoneBillString = TextEditingController();
  String shipPriceString = TextEditingController();*/

  List<String> provinceList = <String>[
    'آذربایجان شرقی',
    'آذربایجان غربی',
    'اردبیل',
    'اصفهان',
    'البرز',
    'بوشهر',
    'تهران',
    'چهارمحال و بختیاری',
    'خراسان شمالی',
    'خراسان جنوبی',
    'خراسان رضوی',
    'خوزستان',
    'زنجان',
    'سمنان',
    'سیستان و بلوچستان',
    'فارس',
    'قزوین',
    'قم',
    'کردستان',
    'کرمان',
    'کرمانشاه',
    'کهگیلویه و بویراحمد',
    'گلستان',
    'گیلان',
    'لرستان',
    'مازندران',
    'مرکزی',
    'هرمزگان',
    '	همدان',
    'یزد'
  ];

  @override
  Widget build(BuildContext context) {
    print("dd");
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Container(
        width: width,
        height: height * 0.5,
        /*color: Colors.blue,*/
        child: Form(
          key: _formKey,
          child: Container(
            height: height * 0.48,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      makeColumnForEditOrder(
                        key1: "نام خانوادگی خریدار",
                        controller: customerLNBill,
                        heightP: 40,
                        isNes: true,
                        onTextChange: onTextChange[0],
                        content: ordersEntity.billing!.lastName,
                      ),
                      makeColumnForEditOrder(
                        key1: "نام خریدار",
                        controller: customerFNBill,
                        heightP: 40,
                        isNes: true,
                        onTextChange: onTextChange[1],
                        content: ordersEntity.billing!.firstName,
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      makeColumnForEditOrder(
                        key1: "شهر محل زندگی",
                        controller: cityBill,
                        heightP: 40,
                        isNes: false,
                        onTextChange: onTextChange[2],
                        content: ordersEntity.billing!.state,
                      ),
                      /*DropdownMenu(
                        key1: '',
                        selectedValue: '',
                        itemList: provinceList,
                      )*/ ProvinceDropdownMenu(itemList: provinceList,
                        key1: "استان",
                        selectedValue: '',
                        onTextChange:onTextChange[3] ,
                      ),
                    ],
                  ),
                  makeColumnForEditOrder(
                    key1: "آدرس خریدار",
                    controller: addressBill,
                    heightP: 89,
                    isNes: false,
                    onTextChange: onTextChange[4],
                    content: ordersEntity.billing!.address1,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      makeColumnForEditOrder(
                        key1: "کد پستی خریدار",
                        controller: postalCodeBill,
                        heightP: 40,
                        isNes: false,
                        onTextChange: onTextChange[5],
                        content: ordersEntity.billing!.postcode,
                      ),
                      Container(
                        //  color: Colors.red,
                        alignment: Alignment.center,
                        // height: height*0.06,
                        // width: width*0.5,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              //padding: EdgeInsets.all(width*0.2),
                              alignment: Alignment.centerRight,
                              width: width * 0.3,
                              child: Text(":" + "ایمیل خریدار",
                                  style: TextStyle(
                                    decoration: TextDecoration.none,
                                    fontSize: width * 0.025,
                                    fontFamily: "IRANSansWeb",
                                    color: Colors.black54,
                                  ),
                                  textAlign: TextAlign.start),
                            ),
                            Container(
                              alignment: Alignment.centerRight,
                              width: width * 0.3,
                              height: height * 0.06,
                              child: Material(
                                  child: TextFormField(
                                initialValue:   ordersEntity.billing!.email,
                                style: TextStyle(fontSize: height * 0.012),
                                textAlign: TextAlign.center,
                                textDirection: TextDirection.rtl,
                                onChanged: (value) {
                                  onTextChange[6](value);
                                },
                                decoration: InputDecoration(
                                  labelText: "Example@example.com",
                                  labelStyle: TextStyle(fontSize: height * 0.008),
                                  /*errorText: stepModel.isValid
                                          ? null
                                          : stepModel.errorText,*/
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 10.0, horizontal: 10.0),
                                  filled: true,
                                  //<-- SEE HERE
                                  fillColor: const Color(0xffededed),
                                  focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(width: 0.5, color: Colors.red),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(width: 0.5),
                                  ),
                                  errorStyle: TextStyle(
                                      fontSize: width * 0.02, color: Colors.grey),
                                  // hintText: index == -1?"":initialValue
                                ),
                              /*  validator: (String? value) {
                                                    if ((value == null || value.isEmpty) && isNes) {
                                                      return 'لطفا فیلد بالا را تکمیل نمایید';
                                                    }
                                                  },*/
                              )),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  makeColumnForEditOrder(
                    key1: "شماره همراه خریدار",
                    controller: phoneBill,
                    heightP: 89,
                    isNes: true,
                    onTextChange: onTextChange[7],
                    content: ordersEntity.billing!.phone,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ShipmentDropdownMenu(itemList: StaticValues.shippingMethods,
                        key1: "روش حمل و نقل",
                        selectedValue: '',
                        onTextChange: onTextChange[8],
                        content: ordersEntity.shippingLines![0].methodTitle.toString(),
                      ),
                          PaymentDropdownMenu(itemList: StaticValues.paymentMethods,
                            key1: "روش پرداخت",
                            selectedValue: '',
                            onTextChange: onTextChange[9],
                            content: ordersEntity.paymentMethodTitle.toString(),
                      ),
                    ],
                  ),
                  makeColumnForEditOrder(
                    key1: "هزینه حمل و نقل",
                    controller: shipPrice,
                    heightP: 89,
                    isNes: false,
                    onTextChange: onTextChange[10],
                    content: ordersEntity.shippingLines![0].total.toString(),
                  ),
                ],
              ),
            ))
          ),
        );
  }
}

class makeColumnForEditOrder extends StatelessWidget {
  final String key1;
  final double heightP;
  final bool isNes;
  final TextEditingController controller;
  final Function(String) onTextChange;
  final String content;


  const makeColumnForEditOrder({
    required this.key1,
    required this.heightP,
    //required this.value,
    required this.controller,
    required this.isNes,
    required this.onTextChange,
    required this.content
  });

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Container(
      //  color: Colors.red,
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            // padding: EdgeInsets.all(width*0.2),
            alignment: Alignment.centerRight,
            width: heightP * 2.7,
            child: Text(":" + key1,
                style: TextStyle(
                  decoration: TextDecoration.none,
                  fontSize: width * 0.025,
                  fontFamily: "IRANSansWeb",
                  color: Colors.black54,
                ),
                textAlign: TextAlign.start),
          ),
          Container(
            alignment: Alignment.centerRight,
            width: heightP * 2.7,
            height: height * 0.06,
            child: Material(
                child: TextFormField(
              initialValue: content,
                  onChanged: (value) => onTextChange(value!),
                  style: TextStyle(fontSize: width * 0.025),
              textAlign: TextAlign.center,
              textDirection: TextDirection.rtl,
              decoration: InputDecoration(

                filled: true,
                fillColor: const Color(0xffededed),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(),
                ),
                errorBorder: const OutlineInputBorder(
                  borderSide: BorderSide(width: 0.5, color: Colors.red),
                ),
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(width: 0.5),
                ),
                errorStyle:
                    TextStyle(fontSize: width * 0.02, color: Colors.grey),
                // hintText: index == -1?"":initialValue
              ),
              validator: (String? value) {
                if ((value == null || value.isEmpty) && isNes) {
                  return 'لطفا فیلد بالا را تکمیل نمایید';
                }
              },
            )),
          ),
        ],
      ),
    );
  }
}

String selectedItem = '';
class PaymentDropdownMenu extends StatefulWidget {
  final List itemList;
  String selectedValue;
  final String key1;
  final Function(String) onTextChange;
  final String content;
  PaymentDropdownMenu(
      {required this.itemList,
        required this.selectedValue,
        required this.key1,
     required this.onTextChange, required this.content});

  @override
  State<PaymentDropdownMenu> createState() => _PaymentDropdownMenuState();
}

class _PaymentDropdownMenuState extends State<PaymentDropdownMenu> {
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    String? selectedItem = widget.itemList![0]['method_title'];
    var contentId = '';
    var contentTitle = '';
    for(int i = 0 ; i < widget.itemList!.length ; i++){
      if(widget.itemList![i]['method_title'].toString() == widget.content){
        contentId = widget.itemList![i]['method_id'].toString();
        contentTitle = widget.itemList![i]['method_title'].toString();
      }
    }

    return SizedBox( width: width * 0.3,
      child: Column(
        children: [
          Container(
            height: height * 0.03,
            alignment: Alignment.centerRight,
            // width: width * 0.3,
            // margin: EdgeInsets.all(height*0.012),
            child: Text(":" + widget.key1,
                style: TextStyle(
                  decoration: TextDecoration.none,
                  fontSize: width * 0.025,
                  fontFamily: "IRANSansWeb",
                  color: Colors.black54,
                ),
                textAlign: TextAlign.start),
          ),
          Container(
            height: height * 0.07,
            child: DropdownButtonFormField2(
              decoration: InputDecoration(
                isDense: true,
                filled: true,
                contentPadding: EdgeInsets.symmetric(vertical: width * 0.02),
                fillColor: const Color(0xffededed),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(),
                ),
                errorBorder: const OutlineInputBorder(
                  borderSide: BorderSide(width: 0.5, color: Colors.red),
                ),
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(width: 0.5),
                ),
                errorStyle: const TextStyle(fontSize: 15, color: Colors.grey),
                border: OutlineInputBorder(
                  borderSide: const BorderSide(width: 1, color: Colors.red),
                  borderRadius: BorderRadius.circular(width * 0.01),
                ),
              ),
              isExpanded: true,
              hint: Text('Choose'),
              // Check for duplicates before passing to DropdownButtonFormField2
              items: [
                /*  DropdownMenuItem(
                  value: widget.content,
                  child: Text(
                    widget.content, // Customize the initial content text
                    style: const TextStyle(fontSize: 10, color: Colors.black), // Optional: Style initial content
                  ),
                ),*/
                ...widget.itemList!.map((item) => DropdownMenuItem(
                  value: item['method_title'],
                  child: Container(
                    alignment: Alignment.center,
                    width: 150,
                    height: 150,
                    child: Text(
                      item['method_title'].toString(),
                      style: const TextStyle(
                        fontSize: 10,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                )).toList(),
              ],
              // Initially set value to 'Initial Content' or another default value
              value: contentTitle,
              onChanged: (value) {
                setState(() {
                  selectedItem = value as String;
                  widget.onTextChange(value);
                });
              },
            ),

          ),
        ],
      ),
    );

  }
}

class ShipmentDropdownMenu extends StatefulWidget {
  final List itemList;
  String selectedValue;
  final String key1;
  final String content;

  final Function(String) onTextChange;
  ShipmentDropdownMenu(
      {required this.itemList,
        required this.selectedValue,
        required this.key1,
      required this.onTextChange, required this.content});

  @override
  State<ShipmentDropdownMenu> createState() => _ShipmentDropdownMenuState();
}

class _ShipmentDropdownMenuState extends State<ShipmentDropdownMenu> {
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    String? selectedItem = widget.itemList![0]['method_title'].toString();
    var contentId = '';
    var contentTitle = '';
    for(int i = 0 ; i < widget.itemList!.length ; i++) {
      if (widget.itemList![i]['method_title']!.contains(widget.content)) {
        contentId = widget.itemList![i]['method_id'].toString();
        contentTitle = widget.itemList![i]['method_title'].toString();
      }
    }

    return SizedBox( width: width * 0.3,
      child: Column(
        children: [
          Container(
            height: height * 0.03,
            alignment: Alignment.centerRight,
            // width: width * 0.3,
            // margin: EdgeInsets.all(height*0.012),
            child: Text(":" + widget.key1,
                style: TextStyle(
                  decoration: TextDecoration.none,
                  fontSize: width * 0.025,
                  fontFamily: "IRANSansWeb",
                  color: Colors.black54,
                ),
                textAlign: TextAlign.start),
          ),
          Container(
            height: height * 0.07,
            child: DropdownButtonFormField2(
              decoration: InputDecoration(
                isDense: true,
                filled: true,
                contentPadding: EdgeInsets.symmetric(vertical: width * 0.02),
                fillColor: const Color(0xffededed),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(),
                ),
                errorBorder: const OutlineInputBorder(
                  borderSide: BorderSide(width: 0.5, color: Colors.red),
                ),
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(width: 0.5),
                ),
                errorStyle: const TextStyle(fontSize: 15, color: Colors.grey),
                border: OutlineInputBorder(
                  borderSide: const BorderSide(width: 1, color: Colors.red),
                  borderRadius: BorderRadius.circular(width * 0.01),
                ),
              ),
              isExpanded: true,
              hint: Text('Choose'),
              // Check for duplicates before passing to DropdownButtonFormField2
              items: [
              /*  DropdownMenuItem(
                  value: widget.content,
                  child: Text(
                    widget.content, // Customize the initial content text
                    style: const TextStyle(fontSize: 10, color: Colors.black), // Optional: Style initial content
                  ),
                ),*/
                ...widget.itemList!.map((item) => DropdownMenuItem(
                  value: item['method_title'],
                  child: Container(
                    alignment: Alignment.center,
                    width: 150,
                    height: 150,
                    child: Text(
                      item['method_title'].toString(),
                      style: const TextStyle(
                        fontSize: 10,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                )).toList(),
              ],
              // Initially set value to 'Initial Content' or another default value
              value: contentTitle,
              onChanged: (value) {
                setState(() {
                  selectedItem = value as String;
                  widget.onTextChange(value);
                });
              },
            ),

          ),
          ])
        ,
      );

  }
}

class ProvinceDropdownMenu extends StatefulWidget {
  final List<String>? itemList;
  String selectedValue;
  final String key1;
  final Function(String) onTextChange;
  ProvinceDropdownMenu(
      {required this.itemList,
        required this.selectedValue,
        required this.key1,
        required this.onTextChange});

  @override
  State<ProvinceDropdownMenu> createState() => _ProvinceDropdownMenuState();
}

class _ProvinceDropdownMenuState extends State<ProvinceDropdownMenu> {
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    String? selectedItem = widget.itemList![0];
    return SizedBox( width: width * 0.3,
      child: Column(
        children: [
        Container(
        height: height * 0.03,
        alignment: Alignment.centerRight,
        // width: width * 0.3,
        // margin: EdgeInsets.all(height*0.012),
        child: Text(":" + widget.key1,
            style: TextStyle(
              decoration: TextDecoration.none,
              fontSize: width * 0.025,
              fontFamily: "IRANSansWeb",
              color: Colors.black54,
            ),
            textAlign: TextAlign.start),
      ),
      Container(
        height: height * 0.07,
        child: DropdownButtonFormField2(
            decoration: InputDecoration(
              isDense: true,
              filled: true,
              contentPadding: EdgeInsets.symmetric(vertical: width * 0.02),
              fillColor: const Color(0xffededed),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(),
              ),
              errorBorder: const OutlineInputBorder(
                borderSide: BorderSide(width: 0.5, color: Colors.red),
              ),
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(width: 0.5),
              ),
              errorStyle: const TextStyle(fontSize: 15, color: Colors.grey),
              border: OutlineInputBorder(
                borderSide: const BorderSide(width: 1, color: Colors.red),
                borderRadius: BorderRadius.circular(width * 0.01),
              ),
            ),
            isExpanded: true,
            hint: Text('Choose'),
            // Check for duplicates before passing to DropdownButtonFormField2
            items: widget.itemList!.map((item) => DropdownMenuItem(
                value: item,
                child:  Container(
                  alignment: Alignment.center,
                  width: 150,
                  height: 150,
                  child: Text(
                    item.toString(),
                    style: TextStyle(
                      fontSize:10,
                    ),
                    textAlign: TextAlign.center,
                  ),
                )
            )).toList(),
            value: selectedItem,
            onChanged: (value) {
              setState(() {
                selectedItem = value as String;
                widget.onTextChange(value);
              });
            }),
      ),
    ]),
    );

  }
}

List removeDuplicates(List list) {
  final uniqueItems = list!.toSet().toList(); // Convert to Set to remove duplicates
  return uniqueItems;
}
