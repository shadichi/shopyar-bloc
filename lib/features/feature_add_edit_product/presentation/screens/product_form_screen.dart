import 'package:flutter/material.dart';
import 'package:shopyar/core/widgets/progress-bar.dart';
import 'package:shopyar/features/feature_add_edit_product/presentation/bloc/add_product_bloc.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/config/app-colors.dart';
import '../bloc/add_product_status.dart';
import '../widgets/add_product_bill.dart';
import '../widgets/add_product_bill_additional.dart';

class AddProductProductFormScreen extends StatefulWidget {
  const AddProductProductFormScreen({super.key});

  @override
  State<AddProductProductFormScreen> createState() =>
      _AddProductProductFormScreenState();
}

class _AddProductProductFormScreenState
    extends State<AddProductProductFormScreen> {
  int activeStep = 0;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<AddProductBloc>().add(AddProductsDataLoad());
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return BlocConsumer<AddProductBloc, AddProductState>(
      listener: (context, state) {},
      builder: (context, state) {
        final status = state.addProductStatus;

        Widget mainContent;
        if (status is AddProductsDataLoading) {
          mainContent = ProgressBar();
        } else if (status is AddProductsDataLoaded) {
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
                      child: _buildSection(),
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  nextButton(),
                  previousButton(),
                ],
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
          body: mainContent,
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
     /* List<Function(String)> onTextChange,
      List<TextEditingController> textEditing,*/
      ) {
    switch (activeStep) {
      case 0:
        return AddProductBill(_formKey);

      case 1:
        return AddProductBillAdditional();

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
          if (activeStep == 0){
           if(_formKey.currentState!.validate()){
             activeStep ++;
           }
          }else{
            activeStep = 0;
          }
        });
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppConfig.secondaryColor,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(5))),
        ),
        child: Text(
          activeStep == 1
              ?  'ثبت'
              : 'بعدی',
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
}
