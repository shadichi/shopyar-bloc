import 'package:flutter/material.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:shapyar_bloc/features/feature_orders/presentation/widgets/order.dart';
import '../../../../core/widgets/snackBar.dart';
import '../../../feature_orders/domain/entities/orders_entity.dart';
import '../../../../core/config/app-colors.dart';
import '../../../../core/utils/static_values.dart';
import '../../../../core/widgets/alert_dialog.dart';
import '../../../../core/widgets/progress-bar.dart';
import '../../data/models/add_order_data_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/add_order_orders_model.dart';
import '../bloc/add_order_bloc.dart';
import '../bloc/add_order_status.dart';
import '../widgets/AddOrderBillTest.dart';
import '../widgets/add_order_product.dart';

enum ProductFormMode {
  create,
  edit(),
}

class ProductFormScreen extends StatefulWidget {
  static const createRoute = '/orders-create';
  static const editRoute   = '/orders-edit';

  final ProductFormMode mode;
  final OrdersEntity? ordersEntity;

  const ProductFormScreen._({required this.mode, this.ordersEntity}); // 👈 private constructor

  factory ProductFormScreen.create() =>
      ProductFormScreen._(mode: ProductFormMode.create);

  factory ProductFormScreen.edit({required OrdersEntity ordersEntity}) =>
      ProductFormScreen._(
        mode: ProductFormMode.edit,
        ordersEntity: ordersEntity,
      );
//کلمه‌ی factory یعنی «این سازنده لزوماً همیشه یک آبجکت جدید نمی‌سازه، می‌تونه یک نمونه‌ی موجود رو برگردونه یا منطق اضافه اجرا کنه».
  @override
  _AddOrderTest createState() => _AddOrderTest();
}

class _AddOrderTest extends State<ProductFormScreen> {
  int activeStep = 0;

  int upperBound = 1;

  List<PaymentMethod>? paymentMethod = [];
  List<ShippingMethod>? shipmentMethod = [];

  List pay = [];
  List ship = [];

  String customerLNBill = '';
  String customerFNBill = '';
  String cityBill = '';
  String provinceBill = '';
  String addressBill = '';
  String postalCodeBill = '';
  String emailBill = '';
  String phoneBill = '';
  String shipmentBill = '';
  String paymentBill = '';
  String shipPriceBill = '';
  List<LineItem> lineItem = [];
  List<ShippingLine> shippingLine = [];

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _validateForm() {
    if (_formKey.currentState?.validate() ?? false) {
      print("Form is valid ✅");
    } else {
      print("Form is invalid ❌");
    }
  }

  @override
  void initState() {
    super.initState();

    context.read<AddOrderBloc>().add(LoadAddOrderProductsData());
    if (widget.mode == ProductFormMode.edit ) {
      context.read<AddOrderBloc>().add(HydrateCartFromOrder (widget.ordersEntity!));

    }
  }

  final TextEditingController controller = TextEditingController();

  TextEditingController step1CustomerFNBill = TextEditingController();
  TextEditingController step1CustomerLNBill = TextEditingController();
  TextEditingController step1AddressBill = TextEditingController();
  TextEditingController step1CityBill = TextEditingController();
  TextEditingController step1PostalCodeBill = TextEditingController();
  TextEditingController step1EmailBill = TextEditingController();
  TextEditingController step1PhoneBill = TextEditingController();
  TextEditingController step1ShipPrice = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    List<TextEditingController> textEditing = [
      step1CustomerFNBill,
      step1CustomerLNBill,
      step1AddressBill,
      step1CityBill,
      step1PostalCodeBill,
      step1EmailBill,
      step1PhoneBill,
      step1ShipPrice,
    ];

    List<Function(String)> onTextChange = [
      (value) {
        customerLNBill = value;
        print("نام خانوادگی خریدار");
        print(customerLNBill);
      },
      (value) {
        customerFNBill = value;
        print("نام خریدار");
        print(customerFNBill);
      },
      (value) {
        cityBill = value;
        print("شهر محل زندگی");
        print(cityBill);
      },
      (value) {
        provinceBill = value;
        print("استان");
        print(provinceBill);
      },
      (value) {
        addressBill = value;
        print("آدرس خریدار");
        print(addressBill);
      },
      (value) {
        postalCodeBill = value;
        print("کد پستی خریدار");
        print(postalCodeBill);
      },
      (value) {
        emailBill = value;
        print("ایمیل");
        print(emailBill);
      },
      (value) {
        phoneBill = value;
        print("شماره همراه");
        print(phoneBill);
      },
      (value) {
        shipmentBill = value;
        print("روش حمل و نقل");
        print(shipmentBill);
      },
      (value) {
        paymentBill = value;
        print("روش پرداخت");
        print(paymentBill);
      },
      (value) {
        shipPriceBill = value;
        print("هزینه حمل و نقل");
        print(shipPriceBill);
      }
    ];

    paymentMethod = StaticValues.paymentMethods
        .map((method) => PaymentMethod.fromJson(method))
        .toList();
    shipmentMethod = StaticValues.shippingMethods
        .map((method) => ShippingMethod.fromJson(method))
        .toList();

    return BlocConsumer<AddOrderBloc, AddOrderState>(
      listener: (context, state) {
        if (state.addOrderStatus is AddOrderSuccessStatus) {
          alertDialogScreen(context, 'سفارش با موفقیت ایجاد شد.', 2, false,
              icon: Icons.check_circle);
        }
      },
      builder: (context, state) {
        Widget bodyContent;

        if (state.addOrderStatus is AddOrderProductsErrorStatus) {
          bodyContent = Center(child: Text('خطا!'));
        } else if (state.addOrderStatus is AddOrderProductsLoadingStatus) {
          BlocProvider.of<AddOrderBloc>(context)
              .add(LoadAddOrderProductsData());
          bodyContent = Center(child: ProgressBar());
        } else if (state.addOrderStatus is AddOrderProductsLoadedStatus) {
          AddOrderProductsLoadedStatus addOrderProductsLoadedStatus =
              state.addOrderStatus as AddOrderProductsLoadedStatus;
          paymentMethod!.forEach((element) {
            pay.add(element.methodTitle);
          });
          shipmentMethod!.forEach((element) {
            ship.add(element.methodTitle);
          });
          pay.forEach((element) {
            print(element);
          });
          ship.forEach((element) {
            print(element);
          });

          bodyContent = Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                stepper(),
                ListTile(
                  title: Text(
                    activeStep == 0 ? 'مشخصات صورتحساب' : 'محصولات',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                  subtitle: Text(
                    activeStep == 0
                        ? 'لطفا مشخصات صورتحساب را وارد فرمایید.'
                        : 'لطفا محصولات را انتخاب فرمایید.',
                    style: TextStyle(color: Colors.grey, fontSize: 11),
                  ),
                ),
                Expanded(
                  child: AnimatedSwitcher(
                    duration: Duration(milliseconds: 400),
                    transitionBuilder: (child, animation) => SlideTransition(
                      position: Tween<Offset>(
                        begin: Offset(1.0, 0.0), // از راست بیاد ←
                        end: Offset.zero,
                      ).animate(animation),
                      child: child,
                    ),
                    child: SizedBox(
                      key: ValueKey<int>(activeStep),
                      width: 350,
                      //  height: 300,
                      child: _buildSection(onTextChange, textEditing, widget.mode, widget.ordersEntity),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    nextButton(addOrderProductsLoadedStatus),
                    previousButton(),
                  ],
                ),
              ],
            ),
          );
        } else {
          bodyContent = Center(child: Text("خطا در پردازش داده‌ها"));
        }

        return Scaffold(
          backgroundColor: AppConfig.background,
          body: bodyContent,
          appBar: AppBar(
            backgroundColor: AppConfig.background,
            iconTheme: IconThemeData(
              color: Colors.white, //change your color here
            ),
            title: Text(
              widget.mode == ProductFormMode.create?'ایجاد سفارش جدید':'ویرایش سفارش ${widget.ordersEntity!.id.toString()} ',
              style: TextStyle(color: Colors.white, fontSize: 13),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSection(onTextChange, textEditing, isEditMode, OrdersEntity? ordersEntity ) {
    switch (activeStep) {
      case 0:
        return Addorderbilltest(
            paymentMethod, shipmentMethod, onTextChange, _formKey, textEditing, isEditMode,  ordersEntity: ordersEntity);
      case 1:
        return ListView.builder(
            itemCount: 13,
            itemBuilder: (context, index) {
              final product = StaticValues.staticProducts[index];
              return AddOrderProduct(isEditMode,  product,ordersEntity: ordersEntity,);
            });
      default:
        return Container();
    }
  }

  Widget nextButton(AddOrderProductsLoadedStatus addOrderProductsLoadedStatus) {
    return Container(
      margin: EdgeInsets.all(10),
      width: activeStep == 1 ? 100 : 80,
      child: ElevatedButton(
        onPressed: () {
          if (activeStep == 0) {
            if (_formKey.currentState?.validate() ?? false) {
              setState(() {
                activeStep++;
              });
            } else {

              showSnack(context, "لطفا همه فیلدهای مورد نیاز را پر کنید!");
            }
          } else {
            setState(() {
              activeStep++;
            });
          }
        },
        style: ElevatedButton.styleFrom(
            backgroundColor: AppConfig.secondaryColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(5)))),
        child: Text(
          activeStep == 1 ? 'ثبت سفارش' : 'بعدی',
          style: TextStyle(
              color: Colors.white, fontSize: activeStep == 1 ? 9 : 12),
        ),
      ),
    );
  }

  Widget previousButton() {
    return Container(
      margin: EdgeInsets.all(10),
      child: ElevatedButton(
        onPressed: () {
          // Decrement activeStep, when the previous button is tapped. However, check for lower bound i.e., must be greater than 0.
          if (activeStep > 0) {
            setState(() {
              activeStep--;
            });
          }
        },
        style: ElevatedButton.styleFrom(
            backgroundColor: AppConfig.secondaryColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(5)))),
        child: Text(
          'قبلی',
          style: TextStyle(color: Colors.white, fontSize: 12),
        ),
      ),
    );
  }

  Widget stepper() {
    return Container(
      width: 320,
      height: 50,
      alignment: Alignment.center,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            width: 40,
            decoration: BoxDecoration(
              color: AppConfig.background,
              border: activeStep == 1
                  ? Border.all(width: 2, color: Colors.grey)
                  : null,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: FractionallySizedBox(
                heightFactor: 0.6,
                // Adjust those two for the white space
                widthFactor: 0.9,
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Text('2'),
                ),
              ),
            ),
          ),
          Container(
              width: 200,
              height: 20,
              /*color: Colors.green,*/
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(horizontal: 5),
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
              )),
          Container(
            width: 40,
            decoration: BoxDecoration(
              color: AppConfig.background,
              border: activeStep == 0
                  ? Border.all(width: 2, color: Colors.grey)
                  : null,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: FractionallySizedBox(
                heightFactor: 0.6,
                // Adjust those two for the white space
                widthFactor: 0.9,
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Text('1'),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget section1() {
    return Container(
      padding: EdgeInsets.all(8),
      // color: Colors.green,
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            spacing: 20,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  textField(controller, 'نام'),
                  textField(controller, ' نام خانوادگی'),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  textField(controller, 'استان'),
                  textField(controller, 'شهر محل زندگی')
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  textField(controller, 'آدرس خریدار', isOnlyChild: true)
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  textField(controller, 'کد پستی خریدار'),
                  textField(controller, 'ایمیل خریدار'),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  textField(controller, 'شماره همراه خریدار', isOnlyChild: true)
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  textField(controller, 'روش پرداخت'),
                  textField(controller, 'روش حمل ونقل')
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  textField(controller, 'هزینه حمل ونقل', isOnlyChild: true)
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget section2() {
    return Container(
      padding: EdgeInsets.all(8),
      color: Colors.grey,
      /*  decoration: BoxDecoration(
        color: Colors.orange,
        borderRadius: BorderRadius.circular(5),
      ),*/
    );
  }

  Widget textField(controller, hintText, {bool isOnlyChild = false}) {
    return Container(
      width: isOnlyChild ? 310 : 150,
      height: 30,
      child: TextField(
        controller: controller,
        style: TextStyle(fontSize: 10, color: Colors.black87),
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
          // Optional:
          // errorBorder, focusedErrorBorder, suffixIcon
        ),
      ),
    );
  }
}
