import 'package:flutter/material.dart';
import 'package:dropdown_button2/src/dropdown_button2.dart';
import 'package:shapyar_bloc/core/config/app-colors.dart';
import '../../data/models/add_order_data_model.dart';

class Addorderbilltest extends StatelessWidget {
  List<PaymentMethod>? paymentMethod;
  List<ShippingMethod>? shipmentMethod;
  final List<Function(String)> onTextChange;
  final GlobalKey<FormState> formKey;
  final List<TextEditingController> textEditing;

  Addorderbilltest(
      this.paymentMethod, this.shipmentMethod, this.onTextChange, this.formKey, this.textEditing);



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
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Form(
      key: formKey,
      child: Container(
        padding: EdgeInsets.all(8),
        // color: Colors.green,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            spacing: 20,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  textField(textEditing[0], 'نام', height, context),
                  textField(textEditing[1], ' نام خانوادگی', height, context),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ProvinceDropdownMenu(
                    itemList: provinceList,
                    key1: 'استان',
                    onTextChange: onTextChange[3],
                    selectedValue: '',
                  ),
                  textField(textEditing[3], 'شهر محل زندگی', height, context),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  textField(textEditing[2], 'آدرس خریدار', height, context,
                      isOnlyChild: true)
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  textField(textEditing[4], 'کد پستی خریدار', height, context),
                  textField(textEditing[5], 'ایمیل خریدار', height, context),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  textField(textEditing[6], 'شماره همراه خریدار', height, context,
                      isOnlyChild: true)
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  PaymentDropdownMenu(
                    itemList: paymentMethod!.toList(),
                    key1: "روش پرداخت",
                    selectedValue: '',
                    onTextChange: onTextChange[9],
                  ),
                  ShipmentDropdownMenu(
                    itemList: shipmentMethod!.toList(),
                    key1: "روش حمل و نقل",
                    selectedValue: '',
                    onTextChange: onTextChange[8],
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  textField(textEditing[7], 'هزینه حمل ونقل', height, context,
                      isOnlyChild: true)
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget textField(controller, hintText, height, context,
      {bool isOnlyChild = false}) {
    return Container(
      width: isOnlyChild ? 310 : 150,
      height: height * 0.05,
      child: TextFormField(
        controller: controller,
        style: TextStyle(
            fontSize: AppConfig.calFontSize(context, 2), color: Colors.black87),
        decoration: InputDecoration(
          contentPadding:
              const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
          //prefixIcon: Icon(Icons.add, color: Colors.deepPurple),
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey.shade500),
          filled: true,
          fillColor: Colors.white,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            //  borderSide: BorderSide(color: Colors.grey, width: 1.4),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: BorderSide(color: Colors.grey, width: 1),
          ),
          errorStyle: TextStyle(  color: Colors.transparent,
            fontSize: 0,
            height: 0, ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: BorderSide(color: Colors.red, width: 1.5),
          ),
          // Optional:
          // errorBorder, focusedErrorBorder, suffixIcon
        ),
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return ' ';
          }
          return null;
        },
      ),
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
    return SizedBox(
      width: width * 0.41,
      child: Column(children: [
        Container(
          height: height * 0.05,
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
                errorStyle: const TextStyle(height: 0),
                border: OutlineInputBorder(
                  borderSide: const BorderSide(width: 1, color: Colors.red),
                  borderRadius: BorderRadius.circular(width * 0.01),
                ),
              ),
              isExpanded: true,
              hint: Text('Choose'),
              // Check for duplicates before passing to DropdownButtonFormField2
              items: widget.itemList!
                  .map((item) => DropdownMenuItem(
                      value: item,
                      child: Container(
                        alignment: Alignment.center,
                        width: 150,
                        height: 150,
                        child: Text(
                          item.toString(),
                          style: TextStyle(
                            fontSize: 10,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      )))
                  .toList(),
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

class ShipmentDropdownMenu extends StatefulWidget {
  final List<ShippingMethod>? itemList;
  String selectedValue;
  final String key1;
  final Function(String) onTextChange;

  ShipmentDropdownMenu(
      {required this.itemList,
      required this.selectedValue,
      required this.key1,
      required this.onTextChange});

  @override
  State<ShipmentDropdownMenu> createState() => _ShipmentDropdownMenuState();
}

class _ShipmentDropdownMenuState extends State<ShipmentDropdownMenu> {
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    String? selectedItem = widget.itemList![0].methodTitle;
    widget.onTextChange(selectedItem!);
    print('selectedItem');
    print(selectedItem);
    return SizedBox(
      width: width * 0.41,
      child: Column(children: [
        Container(
          height: height * 0.05,
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
              items: widget.itemList!
                  .map((item) => DropdownMenuItem(
                      value: item.methodTitle,
                      child: Container(
                        alignment: Alignment.center,
                        width: 150,
                        height: 150,
                        child: Text(
                          item.methodTitle.toString(),
                          style: TextStyle(
                            fontSize: 10,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      )))
                  .toList(),
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

class PaymentDropdownMenu extends StatefulWidget {
  final List<PaymentMethod>? itemList;
  String selectedValue;
  final String key1;
  final Function(String) onTextChange;

  PaymentDropdownMenu(
      {required this.itemList,
      required this.selectedValue,
      required this.key1,
      required this.onTextChange});

  @override
  State<PaymentDropdownMenu> createState() => _PaymentDropdownMenuState();
}

class _PaymentDropdownMenuState extends State<PaymentDropdownMenu> {
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    String? selectedItem = widget.itemList![0].methodTitle;
    widget.onTextChange(selectedItem!);
    print('selectedItem');
    print(selectedItem);
    return SizedBox(
      width: width * 0.41,
      child: Column(
        children: [
          Container(
            height: height * 0.05,
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
                items: widget.itemList!
                    .map((item) => DropdownMenuItem(
                        value: item.methodTitle,
                        child: Container(
                          alignment: Alignment.center,
                          width: 150,
                          height: 150,
                          child: Text(
                            item.methodTitle.toString(),
                            style: TextStyle(
                              fontSize: 10,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        )))
                    .toList(),
                value: selectedItem,
                onChanged: (value) {
                  setState(() {
                    selectedItem = value as String;
                    widget.onTextChange(value);
                  });
                }),
          ),
        ],
      ),
    );
  }
}
