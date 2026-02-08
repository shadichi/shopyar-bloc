import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shopyar/core/widgets/alert_dialog.dart';
import 'package:shopyar/core/widgets/progress-bar.dart';
import 'package:shopyar/features/feature_add_edit_product/data/models/variation_model.dart';
import 'package:shopyar/features/feature_add_edit_product/presentation/bloc/add_product_bloc.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopyar/features/feature_add_edit_product/presentation/bloc/submit_product_status.dart';
import 'package:shopyar/features/feature_products/presentation/bloc/products_bloc.dart';
import '../../../../core/config/app-colors.dart';
import '../../../../core/params/products_params.dart';
import '../../data/models/add_order_data_model.dart';
import '../../data/models/product_submit_model.dart';
import '../bloc/add_product_status.dart';
import '../widgets/add_product_bill.dart';
import '../widgets/add_product_bill_additional.dart';

enum ProductType {
  simple,
  variable,
}

class AddProductProductFormScreen extends StatefulWidget {
  const AddProductProductFormScreen({super.key});

  @override
  State<AddProductProductFormScreen> createState() =>
      _AddProductProductFormScreenState();
}

class _AddProductProductFormScreenState
    extends State<AddProductProductFormScreen> {
  int activeStep = 0;
  final GlobalKey<FormState> _addProductBillformKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _addProductBillAddformKey = GlobalKey<FormState>();

  late final AddProductBloc _addProductBloc;

  @override
  void initState() {
    super.initState();
    _addProductBloc = context.read<AddProductBloc>(); // safe here
    _addProductBloc.add(ClearProductFormEvent());
    _addProductBloc.add(AddProductsDataLoadEvent());
  }
  @override
  void dispose() {
    // از context استفاده نکن — از فیلد ذخیره شده استفاده کن
    _addProductBloc.add(ClearProductFormEvent());
    super.dispose();
  }

  final TextEditingController productName = TextEditingController();
  final TextEditingController shortExplanation = TextEditingController();
  final TextEditingController explanation = TextEditingController();
  final TextEditingController price = TextEditingController();
  final TextEditingController commissionPrice = TextEditingController();
  final TextEditingController sku = TextEditingController();

  File? imageFile;
  List<File> galleryImages = [];

  String productNameValue = '';
  String shortExplanationValue = '';
  String explanationValue = '';
  String priceValue = '';
  String commissionPriceValue = '';
  String skuValue = '';

  String productTypeValue = '';
  List<int> productCatValue = [];
  List<int> productBrandValue = [];
  String productStatValue = '';
  int? productCountValue = 0;
   BuiltAttributePayload attributesValue = BuiltAttributePayload(attributes: [], variations: []);
  /* VariationUiModel variationValue = VariationUiModel(
     attributes: {},
     displayAttributes: {},
   );*/
   List<VariationUiModel> variationValue = [];

  @override
  Widget build(BuildContext context) {
    final List<TextEditingController> addProductBillTextEditing = [
      productName,
      shortExplanation,
      explanation,
      price,
      commissionPrice,
      sku,
    ];

    final List<Function(String)> addProductBillOnTextChange = [
      (value) => productNameValue = value,
      (value) => shortExplanationValue = value,
      (value) => explanationValue = value,
      (value) => priceValue = value,
      (value) => commissionPriceValue = value,
      (value) => skuValue = value,
    ];

    final List<Function(String)> addProductBillAddOnTextChange = [
      (value) => productTypeValue = value,
      (value) => productStatValue = value,
    ];
    final Function(List<VariationUiModel>) variationModelChooser =
        (value) => variationValue = value;

    final Function(BuiltAttributePayload) attributeChooser =
        (value) => attributesValue = value;

    final Function(List<int>) categoryChooser =
        (value) => productCatValue = value;

    final Function(List<int>) brandChooser =
        (value) => productBrandValue = value;

    void onFeaturedImageChanged(File? f) {
      setState(() => imageFile = f);
    }

    void onProductCountValueChanged(int? f) {
      setState(() => productCountValue = f);
    }

    void onGalleryChanged(List<File> files) {
      setState(() => galleryImages = files);
    }

    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return BlocConsumer<AddProductBloc, AddProductState>(
      listener: (context, state) async {
        if (state.submitProductStatus is SubmitProductLoaded) {
          context.read<AddProductBloc>().add(ResetSubmitProductStatusEvent());

          bool isSuccess = false;
          isSuccess = await alertDialogScreen(
                context,
                "محصول با موفقیت اضافه شد!",
                2,
                false,
                icon: Icons.check_circle,
              ) ??
              false;
          if (isSuccess) {
            context.read<ProductsBloc>().add(
                  LoadProductsData(InfParams('10', true, "", false)),
                );

            // Navigator.pop(context);
            Navigator.pop(context);
          }
        }
        if (state.submitProductStatus is SubmitProductError) {
          alertDialogScreen(context, 'خطا در اضافه کردن محصول!', 2, false,
              icon: Icons.check_circle);
        }
      },
      builder: (context, state) {
        final status = state.addProductStatus;
        final isSubmitting = state.submitProductStatus is SubmitProductLoading;

        Widget mainContent;
        if (status is AddProductsDataLoading) {
          mainContent = ProgressBar();
        } else if (status is AddProductsDataLoaded) {
          final data = status.addProductDataModel;
          mainContent = Column(
            children: [
              stepper(),
              ListTile(
                title: Text(
                  activeStep == 0 ? 'مشخصات محصول' : 'محصولات',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: AppConfig.calFontSize(context, 4.5)),
                ),
                subtitle: Text(
                  activeStep == 0
                      ? 'لطفا مشخصات اصلی محصول را وارد کنید.'
                      : 'لطفا مشخصات اضافی محصول را انتخاب کنید.',
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: AppConfig.calFontSize(context, 4)),
                ),
              ),
              Expanded(
                child: Container(
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
                      child: _buildSection(
                          data,
                          addProductBillOnTextChange,
                          addProductBillTextEditing,
                          onFeaturedImageChanged,
                          onGalleryChanged,
                          addProductBillAddOnTextChange,
                          categoryChooser,
                          brandChooser,
                          attributeChooser,
                          variationModelChooser,
                          onProductCountValueChanged
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                alignment: Alignment.topCenter,
                height: height*0.16,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    nextButton(),
                    previousButton(),
                  ],
                ),
              ),
            ],
          );
        } else if (status is AddProductsDataError) {
          mainContent = Center(
            child: SizedBox(
              height: AppConfig.calHeight(context, 100),
              child: const Text(
                "خطا در بارگیری اطلاعات!",
                style: TextStyle(color: Colors.white),
              ),
            ),
          );
        } else {
          // حالت پیش‌فرض
          mainContent = ProgressBar();
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(
              "افزودن محصول جدید",
              style: TextStyle(
                color: Colors.white,
                fontSize: AppConfig.calTitleFontSize(context),
              ),
            ),
          ),
          body: Stack(
            children: [
              mainContent,
              if (isSubmitting) _loadingBarrier('در حال ثبت محصول...'),
            ],
          ),
        );
      },
    );
  }

  Widget stepper() {
    return Container(
      width: 320,
      height: 50,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            width: 40,
            decoration: BoxDecoration(
              color: AppConfig.backgroundColor,
              border: activeStep == 1
                  ? Border.all(width: 2, color: Colors.grey)
                  : null,
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: FractionallySizedBox(
                heightFactor: 0.6,
                widthFactor: 0.9,
                child: CircleAvatar(
                    backgroundColor: Colors.white, child: Text('2')),
              ),
            ),
          ),
          SizedBox(
            width: 200,
            height: 20,
            child: DottedLine(
              direction: Axis.horizontal,
              alignment: WrapAlignment.center,
              lineLength: double.infinity,
              lineThickness: 1.0,
              dashLength: 4.0,
              dashColor: Colors.black,
              dashGradient: [
                AppConfig.firstLinearColor,
                AppConfig.secondLinearColor
              ],
              dashRadius: 0.0,
              dashGapLength: 4.0,
              dashGapColor: Colors.transparent,
              dashGapGradient: [
                AppConfig.firstLinearColor,
                AppConfig.secondLinearColor
              ],
              dashGapRadius: 0.0,
            ),
          ),
          Container(
            width: 40,
            decoration: BoxDecoration(
              color: AppConfig.backgroundColor,
              border: activeStep == 0
                  ? Border.all(width: 2, color: Colors.grey)
                  : null,
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: FractionallySizedBox(
                heightFactor: 0.6,
                widthFactor: 0.9,
                child: CircleAvatar(
                    backgroundColor: Colors.white, child: Text('1')),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(
    AddProductDataModel addProductDataModel,
    List<Function(String)> addProductBillOnTextChange,
    addProductBillTextEditing,
    onFeaturedImageChanged,
    onGalleryChanged,
    List<Function(String)> addProductBillAddOnTextChange,
    Function(List<int>) categoryChooser,
    Function(List<int>) brandChooser,
    Function(BuiltAttributePayload) attributeChooser,
    Function(List<VariationUiModel>) variationUiModel,
    Function(int) countUiModel,
  ) {
    switch (activeStep) {
      case 0:
        return AddProductBill(
          addProductBillOnTextChange,
          addProductBillTextEditing,
          _addProductBillformKey,
          imageFile,
          // File?
          galleryImages,
          // List<File>
          onFeaturedImageChanged,
          onGalleryChanged,
        );

      case 1:
        return AddProductBillAdditional(
            _addProductBillAddformKey,
            addProductDataModel,
            addProductBillAddOnTextChange,
            categoryChooser,
            brandChooser,
            attributeChooser,
          variationUiModel,
            countUiModel

        );

      default:
        return const SizedBox.shrink();
    }
  }

  Widget nextButton() {
    return Container(
      //  margin: const EdgeInsets.all(10),
      width: AppConfig.calWidth(context, 31),
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            if (activeStep == 0) {
              if (_addProductBillformKey.currentState!.validate()) {
                activeStep++;
              }
            } else if (activeStep == 1) {
              if ((productTypeValue == ProductType.variable.name) &&
                  attributesValue.attributes.isEmpty) {
                alertDialogScreen(
                    context,
                    "لطفا درصورت انتخاب محصول متغیر، مقادیر ویژگی متغیر را هم انتخاب کنید. ",
                    1,
                    true);
                return;
              }
              if ((_addProductBillAddformKey.currentState?.validate() ??
                  false)) {
                print(attributesValue.attributes);
                print(attributesValue.variations);
                Map<String, dynamic> test = {};
// ساختن لیست ورییشن‌ها
                final List<Map<String, dynamic>> variationJsonList = variationValue.map((v) {
                  return {
                    "attributes": v.attributes,
                    if (v.regularPrice != null && v.regularPrice!.isNotEmpty)
                      "regular_price": v.regularPrice,
                    if (v.salePrice != null && v.salePrice!.isNotEmpty)
                      "sale_price": v.salePrice,
                    "manage_stock": v.manageStock,
                    if (v.manageStock && v.stockQuantity != null && v.stockQuantity!.isNotEmpty)
                      "stock_quantity": int.tryParse(v.stockQuantity!) ?? 0,
                    "in_stock": v.inStock,
                    if (v.imageFile != null) "image_media_id": v.imageFile, // File
                  };
                }).toList();


                /// استخراج فایل‌های ورییشن
                final List<File?> variationImageFiles = variationJsonList.map((item) {
                  final val = item['image_media_id'];
                  return val is File ? val : null;
                }).toList();


                /// پاک کردن هردا**
                for (final item in variationJsonList) {
                  if (item['image_media_id'] is File) {
                    item.remove('image_media_id');
                  }
                }



                print('variationJsonList');
                print(attributesValue.attributes);
                // print(variationValue.regularPrice);
                context
                    .read<AddProductBloc>()
                    .add(SubmitProductBlocEvent(ProductSubmitModel(
                      name: productNameValue,
                      type: productTypeValue,
                      status: productStatValue,
                      sku: skuValue,
                      regularPrice: priceValue,
                      salePrice: commissionPriceValue,
                      manageStock: attributesValue.attributes.isNotEmpty?false:true,
                      description: explanationValue,
                      shortDescription: shortExplanationValue,
                      stockQuantity: productCountValue,
                      featuredFile: imageFile,
                      galleryFiles: galleryImages,
                      categoryIds: productCatValue,
                      brandIds: productBrandValue,
                      attributes: attributesValue.attributes,
                      variations: attributesValue.attributes.isNotEmpty
                          ? variationJsonList
                          : [],
                  variationImageFiles: variationImageFiles,
                    )));
                /*  print(productNameValue);
                print(shortExplanationValue);
                print(explanationValue);
                print(priceValue);
                print(commissionPriceValue);
                print(skuValue);
                print(imageFile);
                print(galleryImages);
                print(productTypeValue);
                print(jsonEncode(attributesValue));
                print(productCatValue);
                print(productBrandValue);
                print(productStatValue);
                print(productCountValue);*/
              }
            } /*else {
              activeStep = 0;
            }*/
          });
          /* print('galleryImages');
          print(galleryImages);
          print(imageFile);*/
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppConfig.secondaryColor,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(5))),
        ),
        child: Text(
          activeStep == 1 ? 'ثبت' : 'بعدی',
          style: TextStyle(
              color: Colors.white, fontSize: AppConfig.calFontSize(context, 4)),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget previousButton() {
    return Container(
      width: AppConfig.calWidth(context, 30),
      margin: const EdgeInsets.all(10),
      child: ElevatedButton(
        onPressed: () {
          if (activeStep > 0) {
            setState(() {
              activeStep--;
            });
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppConfig.secondaryColor,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(5))),
        ),
        child: Text('قبلی',
            style: TextStyle(
                color: Colors.white,
                fontSize: AppConfig.calFontSize(context, 4))),
      ),
    );
  }

  Widget _loadingBarrier([String? message]) {
    return Stack(
      children: [
        const ModalBarrier(dismissible: false, color: Colors.black54),
        Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ProgressBar(),
              if (message != null) ...[
                SizedBox(height: AppConfig.calHeight(context, 8)),
                Text(
                  message,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: AppConfig.calWidth(context, 3.5),
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
