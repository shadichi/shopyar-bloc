import 'package:flutter/material.dart';
import 'package:dropdown_button2/src/dropdown_button2.dart';
import 'package:shapyar_bloc/core/config/app-colors.dart';
import '../../../feature_orders/domain/entities/orders_entity.dart';
import '../../data/models/add_order_data_model.dart';
import '../screens/product_form_screen.dart';

class Addorderbilltest extends StatefulWidget {
  List<PaymentMethod>? paymentMethod;
  List<ShippingMethod>? shipmentMethod;
  final List<Function(String)> onTextChange;
  final GlobalKey<FormState> formKey;
  final List<TextEditingController> textEditing;
  final ProductFormMode isEditMode;
  final OrdersEntity? ordersEntity;

  Addorderbilltest(
      this.paymentMethod,
      this.shipmentMethod,
      this.onTextChange,
      this.formKey,
      this.textEditing,
      this.isEditMode, {
        this.ordersEntity, // 👈 اختیاری
      }) : assert(
  isEditMode == ProductFormMode.create || ordersEntity != null,
  'در حالت edit باید ordersEntity مقدار داشته باشد',
  );


  @override
  State<Addorderbilltest> createState() => _AddorderbilltestState();
}

class _AddorderbilltestState extends State<Addorderbilltest> {
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
  void initState() {
    // TODO: implement initState
    super.initState();
    if(widget.isEditMode == ProductFormMode.edit){
      final e = widget.ordersEntity!;
      widget.textEditing[0].text = e.billing!.firstName;
      widget.textEditing[1].text = e.billing!.lastName;
      widget.textEditing[2].text = e.billing!.address1;
      widget.textEditing[3].text = e.billing!.city;
      widget.textEditing[4].text = e.billing!.postcode;
      widget.textEditing[5].text = e.billing!.email.toString();
      widget.textEditing[6].text = e.billing!.phone;
      widget.textEditing[7].text = e.paymentMethod!;
    //  widget.textEditing[8].text = e.billing!.firstName;
    //  widget.textEditing[9].text = e.billing!.firstName;

    }
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Form(
      key: widget.formKey,
      child: Container(
        padding: EdgeInsets.all(8),
        // color: Colors.green,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            spacing: 20,
            children: [
              // نام و نام‌خانوادگی
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  textField(
                    widget.textEditing[0], 'نام', height, context,
                    onChanged: widget.onTextChange[1], // FN
                  ),
                  textField(
                    widget.textEditing[1], ' نام خانوادگی', height, context,
                    onChanged: widget.onTextChange[0], // LN
                  ),
                ],
              ),

// استان + شهر
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ProvinceDropdownMenu(
                    itemList: provinceList,
                    key1: 'استان',
                    onTextChange: widget.onTextChange[3],
                    selectedValue: widget.isEditMode == ProductFormMode.edit
                        ? widget.ordersEntity!.billing!.state
                        : '',
                    mode: widget.isEditMode,
                  ),
                  textField(
                    widget.textEditing[3], 'شهر محل زندگی', height, context,
                    onChanged: widget.onTextChange[2], // City
                  ),
                ],
              ),

// آدرس
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  textField(
                    widget.textEditing[2], 'آدرس خریدار', height, context,
                    isOnlyChild: true,
                    onChanged: widget.onTextChange[4], // Address
                  ),
                ],
              ),

// کد پستی + ایمیل
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  textField(
                    widget.textEditing[4], 'کد پستی خریدار', height, context,
                    onChanged: widget.onTextChange[5], // Postal
                  ),
                  textField(
                    widget.textEditing[5], 'ایمیل خریدار', height, context,
                    onChanged: widget.onTextChange[6], // Email
                  ),
                ],
              ),

// تلفن
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  textField(
                    widget.textEditing[6], 'شماره همراه خریدار', height, context,
                    isOnlyChild: true,
                    onChanged: widget.onTextChange[7], // Phone
                  ),
                ],
              ),

// پرداخت + حمل‌ونقل (خودت قبلاً onTextChange گذاشتی، اوکیه)
              PaymentDropdownMenu(
                itemList: widget.paymentMethod!.toList(),
                key1: "روش پرداخت",
                selectedValue: widget.isEditMode == ProductFormMode.edit
                    ? widget.ordersEntity!.paymentMethodTitle.toString()
                    : '',
                onTextChange: widget.onTextChange[9], // Payment
                mode: widget.isEditMode,
              ),
              ShipmentDropdownMenu(
                itemList: widget.shipmentMethod!.toList(),
                key1: "روش حمل و نقل",
                selectedValue: widget.isEditMode == ProductFormMode.edit
                    ? widget.ordersEntity!.shippingLines![0].methodTitle.toString()
                    : '',
                onTextChange: widget.onTextChange[8], // Shipment
                mode: widget.isEditMode,
              ),

// هزینه حمل
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  textField(
                    widget.textEditing[7], 'هزینه حمل ونقل', height, context,
                    isOnlyChild: true,
                    onChanged: widget.onTextChange[10], // ShipPrice
                  ),
                ],
              ),

            ],
          ),
        ),
      ),
    );
  }

  Widget textField(
      TextEditingController controller,
      String hintText,
      double height,
      BuildContext context, {
        bool isOnlyChild = false,
        required ValueChanged<String> onChanged, // 👈 اضافه شد
      }) {
    return SizedBox(
      width: isOnlyChild ? 310 : 150,
      height: height * 0.05,
      child: TextFormField(
        controller: controller,
        style: TextStyle(
          fontSize: AppConfig.calFontSize(context, 2),
          color: Colors.black87,
        ),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey.shade500),
          filled: true,
          fillColor: Colors.white,
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: BorderSide(color: Colors.grey, width: 1),
          ),
          errorStyle: const TextStyle(color: Colors.transparent, fontSize: 0, height: 0),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: const BorderSide(color: Colors.red, width: 1.5),
          ),
        ),
        validator: (value) => (value == null || value.trim().isEmpty) ? ' ' : null,
        onChanged: onChanged, // 👈 اینجا کال‌بک پِرِنت صدا می‌خوره
      ),
    );
  }

}

class ProvinceDropdownMenu extends StatefulWidget {
  final List<String>? itemList;
  String selectedValue;
  final String key1;
  final Function(String) onTextChange;
  ProductFormMode mode;

  ProvinceDropdownMenu(
      {required this.itemList,
      required this.selectedValue,
      required this.key1,
      required this.onTextChange,required this.mode});

  @override
  State<ProvinceDropdownMenu> createState() => _ProvinceDropdownMenuState();
}

class _ProvinceDropdownMenuState extends State<ProvinceDropdownMenu> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    String? selectedItem = widget.mode == ProductFormMode.edit
        ? (widget.selectedValue.isEmpty == true ? null : widget.selectedValue) // اگر خالی بود => null
        : widget.itemList!.first; // ✅

    return SizedBox(
      width: width * 0.33,
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
  ProductFormMode mode;

  ShipmentDropdownMenu(
      {required this.itemList,
      required this.selectedValue,
      required this.key1,
      required this.onTextChange, required this.mode});

  @override
  State<ShipmentDropdownMenu> createState() => _ShipmentDropdownMenuState();
}

class _ShipmentDropdownMenuState extends State<ShipmentDropdownMenu> {
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    String? selectedItem = widget.mode == ProductFormMode.edit
        ? (widget.selectedValue.isEmpty == true ? null : widget.selectedValue) // اگر خالی بود => null
        : widget.itemList!.first.methodTitle; // ✅

    widget.onTextChange(selectedItem!);
    print('selectedItem');
    print(selectedItem);
    return SizedBox(
      width: width * 0.33,
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
  final ProductFormMode mode;

  PaymentDropdownMenu(
      {required this.itemList,
      required this.selectedValue,
      required this.key1,
      required this.onTextChange,
      required this.mode});

  @override
  State<PaymentDropdownMenu> createState() => _PaymentDropdownMenuState();
}

class _PaymentDropdownMenuState extends State<PaymentDropdownMenu> {
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    String? selectedItem = widget.mode == ProductFormMode.edit
        ? (widget.selectedValue.isEmpty == true ? null : widget.selectedValue)
        : widget.itemList!.first.methodTitle; // ✅

   /* print('selectedItem');
    print(selectedItem);*/
    return SizedBox(
      width: width * 0.33,
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
