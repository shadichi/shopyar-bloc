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

class AddProductBillAdditional extends StatefulWidget {
  //final GlobalKey<FormState> formKey;

  AddProductBillAdditional();

  @override
  State<AddProductBillAdditional> createState() => _AddProductBillAdditionalState();
}

class _AddProductBillAdditionalState extends State<AddProductBillAdditional> {
  @override
  void initState() {
    super.initState();
  }

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
                Container(
                  child: Text("تصویر شاخص",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: AppConfig.calFontSize(context, 2.5))),
                  width: double.infinity,
                ),
                BlocBuilder<AddProductBloc, AddProductState>(
                    builder: (context, state) {
                  final stateImageFile = state.featuredImage;
                  print("statestate");
                  print(state);
                  print(stateImageFile);
                  return stateImageFile == null
                      ? Container(
                          width: double.infinity,
                          // عرض نهایی
                          height: AppConfig.calHeight(context, 20),
                          // ارتفاع ثابت دلخواه
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.white),
                              borderRadius: BorderRadius.all(Radius.circular(
                                  AppConfig.calBorderRadiusSize(context)))),
                          child: Padding(
                              padding: EdgeInsets.all(height * 0.07),
                              child: _CustomElevatedButton("افزودن تصویر شاخص",
                                  () {
                                context
                                    .read<AddProductBloc>()
                                    .add(PickImageFromGalleryRequested());
                              })),
                        )
                      : Container(
                          width: double.infinity,
                          // عرض نهایی
                          height: AppConfig.calHeight(context, 20),
                          // ارتفاع ثابت دلخواه
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.white),
                              borderRadius: BorderRadius.all(Radius.circular(
                                  AppConfig.calBorderRadiusSize(context)))),
                          child: Row(
                            children: [
                              Expanded(
                                child: Container(
                                  child: Image.file(
                                    stateImageFile,
                                  ),
                                  padding: EdgeInsets.all(
                                      AppConfig.calHeight(context, 02)),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20))),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                    padding: EdgeInsets.all(
                                        AppConfig.calHeight(context, 02)),
                                    child:
                                        _CustomElevatedButton("حذف تصویر", () {
                                      context
                                          .read<AddProductBloc>()
                                          .add(ClearPickedImage());
                                    })),
                              ),
                              Expanded(
                                child: Container(
                                    padding: EdgeInsets.all(
                                        AppConfig.calHeight(context, 02)),
                                    child: _CustomElevatedButton("تغییر تصویر",
                                        () {
                                      context
                                          .read<AddProductBloc>()
                                          .add(PickImageFromGalleryRequested());
                                    })),
                              ),
                            ],
                          ));
                  return Container(
                    width: double.infinity,
                    // عرض نهایی
                    height: AppConfig.calHeight(context, 20),
                    // ارتفاع ثابت دلخواه
                    color: Colors.red,
                  );
                }),
                Container(
                  child: Text("گالری تصاویر",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: AppConfig.calFontSize(context, 2.5))),
                  width: double.infinity,
                ),
                BlocBuilder<AddProductBloc, AddProductState>(
                    builder: (context, state) {
                  final List<File> galleryImages = state.galleryImages;
                  return galleryImages.isNotEmpty
                      ? Container(
                          width: double.infinity,
                          height: AppConfig.calHeight(context, 30),
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.white),
                              borderRadius: BorderRadius.all(Radius.circular(
                                  AppConfig.calBorderRadiusSize(context)))),
                          child: Column(
                            children: [
                              Expanded(
                                child: Container(
                                  // height: AppConfig.calHeight(context, 3),
                                  //  width: AppConfig.calWidth(context, 3),
                                  padding: EdgeInsets.all(height * 0.02),
                                  child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: galleryImages.length,
                                      itemBuilder: (context, index) {
                                        return Stack(children: [
                                          Container(
                                            margin:
                                                EdgeInsets.all(height * 0.003),
                                            height: AppConfig.calHeight(
                                                context, 20),
                                            width:
                                                AppConfig.calWidth(context, 20),
                                            child: Image.file(
                                              galleryImages[index],
                                            ),
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(AppConfig
                                                        .calBorderRadiusSize(
                                                            context)))),
                                          ),
                                          IconButton(
                                            icon: Icon(
                                              Icons.delete,
                                              color: Colors.red,
                                              size: 40,
                                            ),
                                            onPressed: () {
                                              context
                                                  .read<AddProductBloc>()
                                                  .add(RemoveGalleryAtRequested(
                                                      index));
                                            },
                                          ),
                                        ]);
                                      }),
                                ),
                              ),
                              Container(
                                child: Row(
                                  children: [
                                    Container(
                                      child: _CustomElevatedButton(
                                          "افزودن تصویر", () {
                                        context
                                            .read<AddProductBloc>()
                                            .add(PickGalleryRequested());
                                      }, color: Colors.red),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(
                                                  AppConfig.calBorderRadiusSize(
                                                      context)))),
                                    ),
                                    Container(
                                      child: _CustomElevatedButton(
                                          "پاک کردن همه", () {
                                        context
                                            .read<AddProductBloc>()
                                            .add(PickGalleryRequested());
                                      }),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(
                                                  AppConfig.calBorderRadiusSize(
                                                      context)))),
                                    ),
                                  ],
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                ),
                                alignment: Alignment.center,
                              )
                            ],
                          ))
                      : Container(
                          width: double.infinity,
                          height: AppConfig.calHeight(context, 20),
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.white),
                              borderRadius: BorderRadius.all(Radius.circular(
                                  AppConfig.calBorderRadiusSize(context)))),
                          child: Padding(
                              padding: EdgeInsets.all(height * 0.07),
                              child: _CustomElevatedButton(
                                  "افزودن گالری تصاویر", () {
                                context
                                    .read<AddProductBloc>()
                                    .add(PickGalleryRequested());
                              })),
                        );
                })
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
          children: [
            textField(
              controller,
              'نام محصول',
              context,
              onChanged: (String value) {},
             //   isNec: true
            ),
            textField(controller, 'توضیح کوتاه', context,
                onChanged: (String value) {},),
            textField(controller, 'توضیح', context,
                onChanged: (String value) {}, isLongExpression: true),
            textField(
              controller,
              'قیمت',
              context,
              onChanged: (String value) {},
            ),
            textField(
              controller,
              'قیمت کمیسیون',
              context,
              onChanged: (String value) {},
            ),
            textField(
              controller,
              'sku',
              context,
              onChanged: (String value) {},

            ),
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
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    String? selectedItem =  widget.itemList!.first; // ✅

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

