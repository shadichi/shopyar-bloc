import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:shopyar/core/config/app-colors.dart';
import 'package:dropdown_button2/src/dropdown_button2.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopyar/core/widgets/progress-bar.dart';
import 'package:shopyar/features/feature_add_edit_product/presentation/bloc/add_product_bloc.dart';

import '../../data/models/add_order_data_model.dart';

class AddProductBillAdditional extends StatefulWidget {
  AddProductDataModel addProductDataModel;
  //final GlobalKey<FormState> formKey;

  AddProductBillAdditional(this.addProductDataModel);

  @override
  State<AddProductBillAdditional> createState() => _AddProductBillAdditionalState();
}

class _AddProductBillAdditionalState extends State<AddProductBillAdditional> {
  @override
  void initState() {
    super.initState();
  }

  String customerLNBill = 'dd';


  TextEditingController controller = TextEditingController();

  int activeStep = 0;
  final _picker = ImagePicker();
  String indexImagePath = '';

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    Widget mainContent;
    mainContent = Form(
   //   key: widget.formKey,
      child: Container(

        // height: height,
        padding: EdgeInsets.all(8),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(

              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  // height:AppConfig.calHeight(context, 50),
                  // color: Colors.green,
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 400),
                    transitionBuilder: (child, animation) => SlideTransition(
                      position: Tween<Offset>(
                              begin: const Offset(1, 0), end: Offset.zero)
                          .animate(animation),
                      child: child,
                    ),
                    child: Padding(
                      key: ValueKey<int>(activeStep),
                      //width: 500,
                      padding: EdgeInsets.symmetric(horizontal: width * 0.01),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [Expanded(child: _buildSection())],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    return mainContent;
  }

  Widget _buildSection() {
    switch (activeStep) {
      case 0:
        return Column(
          spacing: AppConfig.calHeight(context, 2),
          children: [
          /*  DropdownMenu(
              itemList: ["ساده","متغیر"],
              selectedValue: "ساده",
              onTextChange:  (value) => customerLNBill = value,
              key1: 'نوع محصول',
            ),
            AttributeSection(key1: '',),

            DropdownMenu(
              itemList: ["ساده","متغیر"],
              selectedValue: "ساده",
              onTextChange:  (value) => customerLNBill = value,
              key1: 'فروشنده',
            ),*/
            AppDropdown<Category>(
              items: widget.addProductDataModel.categories,
              label: 'دسته‌بندی',
              getLabel: (c) => c.name,
              onChanged: (c) {
                print('category picked: ${c.id} - ${c.name}');
                // اینجا میتونی توی bloc بفرستی
              },
            ),
            AppDropdown<Brand>(
              items: widget.addProductDataModel.brands,
              label: 'برند',
              getLabel: (b) => b.name,
              onChanged: (b) {
                print('brand picked: ${b.id}');
              },
            ),
            AppDropdown<Attribute>(
              items: widget.addProductDataModel.attributes,
              label: 'ویژگی',
              getLabel: (a) => a.name,
              onChanged: (a) {
                // اگه خواستی بعدش terms اون attribute رو هم یه dropdown دیگه نشون بده
              },
            ),

            /*DropdownMenu(
              itemList: ["ساده","متغیر"],
              selectedValue: "ساده",
              onTextChange:  (value) => customerLNBill = value,
              key1: 'برچسب',
            ),
            DropdownMenu(
              itemList: ["ساده","متغیر"],
              selectedValue: "ساده",
              onTextChange:  (value) => customerLNBill = value,
              key1: 'برند',
            ),
            DropdownMenu(
              itemList: ["ساده","متغیر"],
              selectedValue: "ساده",
              onTextChange:  (value) => customerLNBill = value,
              key1: 'وضعیت',
            ),*/
            SizedBox(height: AppConfig.calHeight(context, 0.5),),

            textField(
              controller,
              'موجودی',
              context,
              onChanged: (String value) {},
             //   isNec: true
            ),checkBoxs()
          ],
        );

      case 1:
        return textField(
          controller,
          'نام',
          context,
          onChanged: (String value) {},
        );

      default:
        return const SizedBox.shrink();
    }
  }
/*

  Widget attributeSection(){
    return Container(

      padding: EdgeInsets.all(AppConfig.calHeight(context, 2)),
      width: double.infinity,
      height: AppConfig.calHeight(context, 20),
      decoration: BoxDecoration(
         // color: Colors.green,
          border: Border.all(color: Colors.white),
          borderRadius: BorderRadius.all(Radius.circular(
              AppConfig.calBorderRadiusSize(context)))),
      child: Column(
        children: [
          Row(
            children: [
              Flexible(
                child: AttributeSection( itemList: ["رنگ","حجم",],
                  selectedValue: "رنگ",
                  onTextChange:  (value) => customerLNBill = value,
                  key1: 'انتخاب ویژگی موجود', buildAttRowList: llllList,),
              ),
            ],
          ),
          BlocBuilder<AddProductBloc, AddProductState>(builder: (context, state){
            return   Flexible(child: ListView.builder(itemCount: state.attList,itemBuilder: (context, index){
              return llllList[index];
            }));
          })

        ],
      ),

    );
  }
*/

/*

  List<Widget> llllList = [
    Text("data",style: TextStyle(color: AppConfig.white),),
    Text("data",style: TextStyle(color: AppConfig.white),),
    Text("data",style: TextStyle(color: AppConfig.white),),
    Text("data",style: TextStyle(color: AppConfig.white),),
    Text("data",style: TextStyle(color: AppConfig.white),),
  ];*/

  Widget checkBoxs() {
    return Container(
      width: double.infinity,
     // height: 150,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Flexible(
            child: Container(
              child: CheckboxListTile(
                title: Text("مدیریت انبار",style: TextStyle(color: AppConfig.white),),
                value: true,
                onChanged: (newValue) {},
              ),
            ),
          ),   Flexible(
            child: Container(
              child: CheckboxListTile(
                title: Text("در انبار",style: TextStyle(color: AppConfig.white),),
                value: true,
                onChanged: (newValue) {},
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget textField(
      TextEditingController controller, String hintText, BuildContext context,
      {bool isOnlyChild = false,
      required ValueChanged<String> onChanged,
      bool isNec = false,
      bool isDigit = false,
      bool isLongExpression = false}) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return SizedBox(
        //width: double.infinity,
        height: isLongExpression ? height * 0.15 : height * 0.08,
        child: TextFormField(
          controller: controller,
          onChanged: onChanged,
          maxLines: isLongExpression ? null : 1,
          minLines: isLongExpression ? 4 : 1,
          keyboardType: isDigit ? TextInputType.number : TextInputType.text,
          decoration: InputDecoration(
            hintText: hintText,
            filled: true,
            fillColor: Colors.white,
            contentPadding:
                const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
          ),
          validator: isNec
              ? (value) => (value == null || value.trim().isEmpty) ? ' ' : null
              : null,
        ));
  }

  Widget _CustomElevatedButton(String label, void Function() onPress,
      {Color color = Colors.black}) {
    return ElevatedButton(
      onPressed: onPress,
      child: Text(
        label,
        style: TextStyle(
            color: color, fontSize: AppConfig.calFontSize(context, 2.5)),
      ),
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(AppConfig.white),
      ),
    );
  }
}

/*Widget sdfcsdfsd(customerLNBill, llllList){
  return Container(
    child: Row(
      children: [
        Text("نگ"),
        Flexible(
          child: AttributeSection( itemList: ["رنگ","حجم",],
            selectedValue: "رنگ",
            onTextChange:  (value) => customerLNBill = value,
            key1: 'انتخاب ویژگی موجود', buildAttRowList:llllList,),
        ),
      ],
    ),
  );
}*/


class AttributeSection extends StatefulWidget {
  final String key1;

  const AttributeSection({
    super.key,
    required this.key1,
  });

  @override
  State<AttributeSection> createState() => _AttributeSectionState();
}

class _AttributeSectionState extends State<AttributeSection> {
  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;

    return BlocBuilder<AddProductBloc, AddProductState>(
      builder: (context, state) {
        // ✅ ۱. لیست‌هایی که از بلاک می‌گیریم
        final available = state.availableAttributes.toSet().toList(); // یکتا
        final selected = state.selectedAttributes;

        return Container(
          padding: EdgeInsets.all(AppConfig.calHeight(context, 2)),
          width: double.infinity,
          height: AppConfig.calHeight(context, 20),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white),
            borderRadius: BorderRadius.all(
              Radius.circular(AppConfig.calBorderRadiusSize(context)),
            ),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  SizedBox(
                    width: w * 0.4,
                    child: Text(
                      widget.key1,
                      style: TextStyle(
                        color: AppConfig.white,
                        fontSize: AppConfig.calFontSize(context, 3),
                      ),
                    ),
                  ),
                  Expanded(
                    child: SizedBox(
                      height: h * 0.045,
                      child: DropdownButtonFormField2<String>(
                        // ✅ ۲. کلید پویا تا dropdown بعد از هر انتخاب ریست بشه
                        key: ValueKey(available.join(',')),
                        isExpanded: true,
                        value: null, // ✅ ۳. همیشه null، چون بعد از انتخاب می‌خوایم خالی شه
                        hint: const Text('Choose'),
                        decoration: InputDecoration(
                          isDense: true,
                          filled: true,
                          fillColor: const Color(0xffededed),
                          contentPadding: EdgeInsets.symmetric(
                            vertical: w * 0.01,
                            horizontal: w * 0.01,
                          ),
                          enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(width: 0.5),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(width: 1),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(w * 0.01),
                          ),
                        ),
                        items: available
                            .map(
                              (item) => DropdownMenuItem<String>(
                            value: item,
                            child: Text(
                              item,
                              style: TextStyle(
                                fontSize:
                                AppConfig.calFontSize(context, 3),
                              ),
                            ),
                          ),
                        )
                            .toList(),
                        onChanged: (value) {
                          if (value == null) return;

                          // به بلاک بگو این یکی انتخاب شد
                          context
                              .read<AddProductBloc>()
                              .add(SelectAttribute(value));
                        },
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              // ✅ لیست انتخاب‌شده‌ها
              Expanded(
                child: ListView.builder(
                  itemCount: selected.length,
                  itemBuilder: (context, index) {
                    final item = selected[index];
                    return Text(
                      item,
                      style: TextStyle(color: AppConfig.white),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class AppDropdown<T> extends StatefulWidget {
  final List<T> items;
  final T? initialValue;
  final String label; // مثلا: "دسته‌بندی" یا "برند"
  final String Function(T) getLabel; // بگه از این مدل چی نشون بدم
  final void Function(T) onChanged;

  const AppDropdown({
    super.key,
    required this.items,
    required this.getLabel,
    required this.onChanged,
    required this.label,
    this.initialValue,
  });

  @override
  State<AppDropdown<T>> createState() => _AppDropdownState<T>();
}

class _AppDropdownState<T> extends State<AppDropdown<T>> {
  T? _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.initialValue ?? (widget.items.isNotEmpty ? widget.items.first : null);
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: TextStyle(color: AppConfig.white),
        ),
        SizedBox(
          height: h * 0.05,
          child: DropdownButtonFormField2<T>(
            isExpanded: true,
            value: _selected,
            decoration: InputDecoration(
              isDense: true,
              filled: true,
              fillColor: const Color(0xffededed),
              contentPadding: EdgeInsets.symmetric(vertical: w * 0.02, horizontal: 8),
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(width: 0.5),
              ),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(width: 1),
              ),
            ),
            hint: const Text('Choose'),
            items: widget.items
                .map(
                  (item) => DropdownMenuItem<T>(
                value: item,
                child: Text(
                  widget.getLabel(item),
                  style: TextStyle(
                    fontSize: AppConfig.calFontSize(context, 4),
                  ),
                ),
              ),
            )
                .toList(),
            onChanged: (value) {
              if (value == null) return;
              setState(() {
                _selected = value;
              });
              widget.onChanged(value);
            },
          ),
        ),
      ],
    );
  }
}


