import 'package:flutter/material.dart';
import 'package:dropdown_button2/src/dropdown_button2.dart';
import 'package:shapyar_bloc/core/config/app-colors.dart';
import '../../../feature_orders/domain/entities/orders_entity.dart';
import '../../data/models/add_order_data_model.dart';
import '../screens/product_form_screen.dart';

class AddOrderBill extends StatefulWidget {
  List<PaymentMethod>? paymentMethod;
  List<ShippingMethod>? shipmentMethod;
  final List<Function(String)> onTextChange;
  final GlobalKey<FormState> formKey;
  final List<TextEditingController> textEditing;
  final ProductFormMode isEditMode;
  final OrdersEntity? ordersEntity;

  AddOrderBill(
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
  State<AddOrderBill> createState() => _AddOrderBillState();
}

class _AddOrderBillState extends State<AddOrderBill> {
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
    super.initState();

    if (widget.isEditMode == ProductFormMode.edit) {
      final e = widget.ordersEntity!;
      widget.textEditing[0].text = e.billing!.firstName;  // نام
      widget.textEditing[1].text = e.billing!.lastName;   // نام خانوادگی
      widget.textEditing[2].text = e.billing!.address1;
      widget.textEditing[3].text = e.billing!.city;
      widget.textEditing[4].text = e.billing!.postcode;
      widget.textEditing[5].text = e.billing!.email ?? '';
      widget.textEditing[6].text = e.billing!.phone;
      widget.textEditing[7].text = e.shippingPrice ?? '';

      print('e.billing!.email');
      print(e.billing!.email);
      print(e.billing!.postcode);

      // 🔔 اینجا کال‌بک‌های پدر رو هم صدا بزن
      WidgetsBinding.instance.addPostFrameCallback((_) {
        widget.onTextChange[1](widget.textEditing[0].text); // FN
        widget.onTextChange[0](widget.textEditing[1].text); // LN
        widget.onTextChange[4](widget.textEditing[2].text); // Address
        widget.onTextChange[2](widget.textEditing[3].text); // City
        widget.onTextChange[5](widget.textEditing[4].text); // Postal
        widget.onTextChange[6](widget.textEditing[5].text); // Email
        widget.onTextChange[7](widget.textEditing[6].text); // Phone
        widget.onTextChange[10](widget.textEditing[7].text); // ShipPrice

        // استان/پرداخت/حمل‌ونقل هم باید به پدر اطلاع داده بشن
        final prov = e.billing!.state;
        final payTitle  = e.paymentMethodTitle?.toString() ?? '';
        final shipTitle = (e.shippingLines?.isNotEmpty ?? false)
            ? e.shippingLines![0].methodTitle ?? ''
            : '';

        if (prov.isNotEmpty) widget.onTextChange[3](prov);
        if (payTitle.isNotEmpty) widget.onTextChange[9](payTitle);
        if (shipTitle.isNotEmpty) widget.onTextChange[8](shipTitle);
      });
    } else {
      // حالت create → پیش‌فرض‌ها رو هم بفرست به پدر
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final defaultProv = 'آذربایجان شرقی';
        final defaultPay  = widget.paymentMethod?.first.methodTitle ?? '';
        final defaultShip = widget.shipmentMethod?.first.methodTitle ?? '';
        widget.onTextChange[3](defaultProv);
        if (defaultPay.isNotEmpty) widget.onTextChange[9](defaultPay);
        if (defaultShip.isNotEmpty) widget.onTextChange[8](defaultShip);
      });
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
              MakeRow( Expanded(
                child: textField(
                  widget.textEditing[0], 'نام', height, context,
                  onChanged: widget.onTextChange[1], // FN
                  isNec: true
                ),
              ),
                Expanded(
                  child: textField(
                    widget.textEditing[1], ' نام خانوادگی', height, context,
                    onChanged: widget.onTextChange[0], // LN
                      isNec: true
                  ),
                ),),

// استان + شهر
              MakeRow(
                Expanded(
                  child: ProvinceDropdownMenu(
                    itemList: provinceList,
                    key1: 'استان',
                    onTextChange: widget.onTextChange[3],
                    selectedValue: widget.isEditMode == ProductFormMode.edit
                        ? widget.ordersEntity!.billing!.state
                        : '',
                    mode: widget.isEditMode,
                  ),
                ),
                Expanded(
                  child: textField(
                    widget.textEditing[3], 'شهر محل زندگی', height, context,
                    onChanged: widget.onTextChange[2], // City
                  ),
                ),
              ),

// آدرس
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: textField(
                      widget.textEditing[2], 'آدرس خریدار', height, context,
                      isOnlyChild: true,
                      onChanged: widget.onTextChange[4], // Address
                    ),
                  ),
                ],
              ),

// کد پستی + ایمیل
              MakeRow(
                Expanded(
                child: textField(
                  widget.textEditing[4], 'کد پستی خریدار', height, context,
                  onChanged: widget.onTextChange[5], // Postal
                  isDigit: true
                ),
              ),
                Expanded(
                  child: textField(
                    widget.textEditing[5], 'ایمیل خریدار', height, context,
                    onChanged: widget.onTextChange[6], // Email
                  ),
                ),),


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
              MakeRow(
                Expanded(
                  child: textField(
                    widget.textEditing[7], 'هزینه حمل ونقل', height, context,
                    // isOnlyChild: true,
                    onChanged: widget.onTextChange[10], // ShipPrice
                      isDigit: true
                  ),
                ),
                Expanded(
                  child: textField(
                    widget.textEditing[6], 'شماره همراه خریدار', height, context,
                    //isOnlyChild: true,
                    onChanged: widget.onTextChange[7], // Phone
                      isNec: true,
                      isDigit: true
                  ),
                ),
              )

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
        required ValueChanged<String> onChanged,
        bool isNec = false,
        bool isDigit = false
      }) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return SizedBox(
      //width: double.infinity,
      height: height * 0.05,

      child: TextFormField(
        controller: controller,
        keyboardType: isDigit?TextInputType.number:null,
        style: TextStyle(
          fontSize: AppConfig.calFontSize(context, 3),
          color: Colors.black87,
        ),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: AppConfig.calFontSize(context, 4)),
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
        validator: isNec?(value) => (value == null || value.trim().isEmpty) ? ' ' : null:null,
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
    //  width: width * 0.4,
      child: Column(
          mainAxisSize: MainAxisSize.min,
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
                            fontSize:  AppConfig.calFontSize(context, 4),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      )))
                  .toList(),
              value: selectedItem,
              onChanged: (value) {
                setState(() {
                  print('value');
                  print(value);
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

    return SizedBox(
     // width: width * 0.85,
      child: Column(children: [
        Container(
          height: height * 0.05,
          child: DropdownButtonFormField2(
            decoration: InputDecoration(
              isDense: true,
              filled: true,
              contentPadding: EdgeInsets.symmetric(
                vertical: width * 0.02,
                horizontal: width * 0.02, // Added horizontal padding
              ),
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
            hint: Text(
              'Choose',
              textAlign: TextAlign.right, // Right align hint text
            ),
            // Check for duplicates before passing to DropdownButtonFormField2
            items: widget.itemList!
                .map((item) => DropdownMenuItem(
                value: item.methodTitle,
                child: Container(
                  alignment: Alignment.centerRight, // Changed to right alignment
                  width: double.infinity, // Changed to take full width
                  height: 150,
                  child: Text(
                    item.methodTitle.toString(),
                    style: TextStyle(
                      fontSize: AppConfig.calFontSize(context, 4),
                    ),
                    textAlign: TextAlign.right, // Changed to right alignment
                  ),
                )))
                .toList(),
            value: selectedItem,
            onChanged: (value) {
              setState(() {
                print('value');
                print(value);
                selectedItem = value as String;
                widget.onTextChange(value);
              });
            },
          ),
        ),
      ]),
    );  }
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
     // width: width * 0.85,
      child: Column(
        children: [
          Container(
            height: height * 0.05,
            child: DropdownButtonFormField2(
              decoration: InputDecoration(
                isDense: true,
                filled: true,
                contentPadding: EdgeInsets.symmetric(
                  vertical: width * 0.02,
                  horizontal: width * 0.02, // Add horizontal padding
                ),
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
                // Add alignment to the InputDecoration
                alignLabelWithHint: true,
              ),
              isExpanded: true,
              hint: Text(
                'Choose',
                textAlign: TextAlign.right, // Right align hint text
              ),
              // Check for duplicates before passing to DropdownButtonFormField2
              items: widget.itemList!
                  .map((item) => DropdownMenuItem(
                value: item.methodTitle,
                child: Container(
                  alignment: Alignment.centerRight, // Right align container
                  width: double.infinity, // Take full width
                  child: Text(
                    item.methodTitle.toString(),
                    style: TextStyle(
                      fontSize: AppConfig.calFontSize(context, 4),
                    ),
                    textAlign: TextAlign.right, // Right align text
                  ),
                ),
              ))
                  .toList(),
              value: selectedItem,
              onChanged: (value) {
                setState(() {
                  print('value');
                  print(value);
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

Widget MakeRow(Widget firstWidget, Widget secWidget){
  return  Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [
      firstWidget,SizedBox(width: 2,),secWidget
    ],
  );
}
