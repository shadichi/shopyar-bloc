import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:shopyar/core/config/app-colors.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopyar/core/widgets/progress-bar.dart';
import 'package:shopyar/features/feature_add_edit_product/presentation/bloc/add_product_bloc.dart';

class AddProductBill extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final List<Function(String)> onTextChange;
  final List<TextEditingController> textEditing;

  final File? featuredImage;
  final List<File> galleryImages;

  final ValueChanged<File?> onFeaturedChange;
  final ValueChanged<List<File>> onGalleryChange;

  AddProductBill(
    this.onTextChange,
    this.textEditing,
    this.formKey,
    this.featuredImage,
    this.galleryImages,
    this.onFeaturedChange,
    this.onGalleryChange,
  );

  @override
  State<AddProductBill> createState() => _AddProductBillState();
}

class _AddProductBillState extends State<AddProductBill> {
  final FocusNode nameFocus = FocusNode();
  final FocusNode shortDescFocus = FocusNode();
  final FocusNode descFocus = FocusNode();
  final FocusNode priceFocus = FocusNode();
  final FocusNode commissionPriceFocus = FocusNode();
  final FocusNode skuFocus = FocusNode();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    nameFocus.dispose();
    shortDescFocus.dispose();
    descFocus.dispose();
    priceFocus.dispose();
    commissionPriceFocus.dispose();
    skuFocus.dispose();
    super.dispose();
  }

  //TextEditingController controller = TextEditingController();

  int activeStep = 0;
  final _picker = ImagePicker();
  String indexImagePath = '';

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    Widget mainContent;
    mainContent = Scaffold(
      resizeToAvoidBottomInset: true,
      body: Form(
        key: widget.formKey,
        child: Container(
          // height: height,
          padding: EdgeInsets.all(8),
          child: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
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
                  BlocConsumer<AddProductBloc, AddProductState>(
                    listenWhen: (prev, curr) =>
                    prev.featuredImage != curr.featuredImage ||
                        prev.galleryImages != curr.galleryImages,
                    listener: (context, state) {
                      widget.onFeaturedChange(state.featuredImage);
                      widget.onGalleryChange(state.galleryImages);
                    },
                    builder: (context, state) {
                      final File? stateImageFile = state.featuredImage;

                      return stateImageFile == null
                          ? Container(
                        width: double.infinity,
                        height: AppConfig.calHeight(context, 20),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.circular(
                            AppConfig.calBorderRadiusSize(context),
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.07),
                          child: _CustomElevatedButton(
                            "افزودن تصویر شاخص",
                                () {
                              context
                                  .read<AddProductBloc>()
                                  .add(PickImageFromGalleryRequestedEvent());
                            },
                          ),
                        ),
                      )
                          : Container(
                        width: double.infinity,
                        height: AppConfig.calHeight(context, 20),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.circular(
                            AppConfig.calBorderRadiusSize(context),
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.all(
                                  AppConfig.calHeight(context, 2),
                                ),
                                child: Image.file(stateImageFile),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.all(
                                  AppConfig.calHeight(context, 2),
                                ),
                                child: _CustomElevatedButton(
                                  "حذف",
                                      () {
                                    context
                                        .read<AddProductBloc>()
                                        .add(ClearPickedImageEvent());
                                  },
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.all(
                                  AppConfig.calHeight(context, 2),
                                ),
                                child: _CustomElevatedButton(
                                  "تغییر",
                                      () {
                                    context
                                        .read<AddProductBloc>()
                                        .add(PickImageFromGalleryRequestedEvent());
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),

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
                   /* WidgetsBinding.instance.addPostFrameCallback((_) {
                      widget.onGalleryChange(galleryImages);
                    });*/
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
                                              margin: EdgeInsets.all(
                                                  height * 0.003),
                                              height: AppConfig.calHeight(
                                                  context, 20),
                                              width: AppConfig.calWidth(
                                                  context, 20),
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
                                                context.read<AddProductBloc>().add(
                                                    RemoveGalleryAtRequestedEvent(
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
                                              .add(PickGalleryRequestedEvent());
                                        }, color: Colors.red),
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(AppConfig
                                                    .calBorderRadiusSize(
                                                        context)))),
                                      ),
                                      Container(
                                        child: _CustomElevatedButton(
                                            "پاک کردن همه", () {
                                          context.read<AddProductBloc>().add(
                                              ClearGalleryRequestedEvent());
                                        }),
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(AppConfig
                                                    .calBorderRadiusSize(
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
                                      .add(PickGalleryRequestedEvent());
                                })),
                          );
                  })
                ],
              ),
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
            textField(widget.textEditing[0], 'نام محصول', context,
                nameFocus: nameFocus,
                onChanged: widget.onTextChange[0],
                isNec: true
                //   isNec: true
                ),
            textField(widget.textEditing[1], 'توضیح کوتاه', context,
                nameFocus: shortDescFocus, onChanged: widget.onTextChange[1]),
            textField(widget.textEditing[2], 'توضیح', context,
                nameFocus: descFocus,
                onChanged: widget.onTextChange[2],
                isLongExpression: true),
            textField(widget.textEditing[3], 'قیمت', context,
                nameFocus: priceFocus,
                onChanged: widget.onTextChange[3],
                isNec: true,
                isDigit: true),
            textField(widget.textEditing[4], 'قیمت کمیسیون', context,
                nameFocus: commissionPriceFocus,
                onChanged: widget.onTextChange[4],
                isDigit: true),
            textField(widget.textEditing[5], 'sku', context,
                nameFocus: skuFocus,
                onChanged: widget.onTextChange[5],
                isDigit: true),
          ],
        );

      case 1:
        return textField(
          widget.textEditing[0],
          'نام',
          context,nameFocus: nameFocus,
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
      required nameFocus,
      bool isNec = false,
      bool isDigit = false,
      bool isLongExpression = false}) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        focusNode: nameFocus,
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
      ),
    );
  }

  Widget _CustomElevatedButton(String label, void Function() onPress,
      {Color color = Colors.black}) {
    return ElevatedButton(
      onPressed: onPress,
      child: Text(
        label,
        style: TextStyle(
            color: color, fontSize: AppConfig.calFontSize(context, 3.4)),
      ),
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(AppConfig.white),
      ),
    );
  }
}
