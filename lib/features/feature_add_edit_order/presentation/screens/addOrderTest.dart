import 'package:flutter/material.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:shapyar_bloc/core/colors/app-colors.dart';
import 'package:shapyar_bloc/features/feature_add_edit_order/domain/entities/add_order_orders_entity.dart';
import '../../../../core/colors/app-colors.dart';
import '../../../../core/config/app-colors.dart';
import '../../../../core/params/setOrderPArams.dart';
import '../../../../core/utils/static_values.dart';
import '../../../../core/widgets/alert_dialog.dart';
import '../../../../core/widgets/progress-bar.dart';
import '../../../../locator.dart';
import '../../data/models/add_order_data_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/add_order_orders_model.dart';
import '../bloc/add_order_bloc.dart';
import '../bloc/add_order_set_order_status.dart';
import '../bloc/add_order_status.dart';
import '../widgets/AddOrderBillTest.dart';
import '../widgets/add_order_bill.dart';
import '../widgets/add_order_product.dart';

class AddOrderTest extends StatefulWidget {
  static const routeName = '/add_order_test';

  @override
  _AddOrderTest createState() => _AddOrderTest();
}

class _AddOrderTest extends State<AddOrderTest> {
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
      // All fields are valid
      print("Form is valid");
    } else {
      // Some fields are invalid
      print("Form is invalid");
    }
  }

  @override
  void initState() {
    super.initState();

    context.read<AddOrderBloc>().add(LoadAddOrderProductsData());
  }

  final TextEditingController controller = TextEditingController();


  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

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

    return BlocBuilder<AddOrderBloc, AddOrderState>(
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
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  stepper(),
                  Container(
                    child: ListTile(
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
                        child: _buildSection(onTextChange),
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
              'ایجاد سفارش جدید',
              style: TextStyle(color: Colors.white, fontSize: 13),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSection(onTextChange) {
    switch (activeStep) {
      case 0:
        return Addorderbilltest(paymentMethod,shipmentMethod,onTextChange,_formKey,);
      case 1:
        return  ListView.builder(
    itemCount: 3,
    itemBuilder: (context, index) {
    final product =
    StaticValues.staticProducts[index];
    return AddOrderProduct(product);
    });
      default:
        return Container();
    }
  }

  Widget nextButton(AddOrderProductsLoadedStatus addOrderProductsLoadedStatus) {
    return Container(
      margin: EdgeInsets.all(10),
      width: activeStep==1?100:80,
      child: ElevatedButton(
        onPressed: () {
          _validateForm();

          if (activeStep == 1) {
                double totalPrice = 0;
                for (final entry
                in addOrderProductsLoadedStatus
                    .cart.entries) {
                  final productId = entry.key;
                  final quantity = entry.value;

                  lineItem.add(LineItem(
                    id: 0,
                    productId: productId,
                    name: "",
                    quantity: quantity,
                    total: totalPrice.toString(),
                  ));
                }
                print('lineItemlineItemlineItemlineItem');
                print(lineItem);
            if (lineItem.isEmpty) {
              alertDialog(context,
                  'هیچ محصولی انتخاب نشده است!', 1, true);
              return;
            } AddOrderOrdersEntity order =
            AddOrderOrdersEntity(
                id: 0,
                status: 'در انتظار',
                billing: Ing(
                    firstName: customerLNBill,
                    lastName: customerFNBill,
                    address1: addressBill,
                    city: cityBill,
                    email: emailBill,
                    state: provinceBill,
                    postcode: postalCodeBill,
                    country: "ایران",
                    phone: phoneBill),
                shipping: Ing(
                    firstName: customerLNBill,
                    lastName: customerFNBill,
                    address1: addressBill,
                    city: cityBill,
                    email: emailBill,
                    state: provinceBill,
                    postcode: postalCodeBill,
                    country: "ایران",
                    phone: phoneBill),
                paymentMethod: paymentBill,
                paymentMethodTitle: paymentBill,
                lineItems: lineItem,
                shippingLines: shippingLine);
            print(addOrderProductsLoadedStatus.cart);
            var payType = '';
            if (paymentMethod!.isNotEmpty) {
              payType = paymentMethod![
              pay.indexOf(paymentBill)]
                  .methodId
                  .toString();
            }
            var shipType = '';
            if (shipmentMethod!.isNotEmpty) {
              shipType = shipmentMethod![
              ship.indexOf(shipmentBill)]
                  .methodId
                  .toString();
            }
            String priceShip = shipPriceBill.isEmpty
                ? ""
                : shipPriceBill;
            context.read<AddOrderBloc>().add(SetOrder(
                SetOrderParams(order, payType, shipType,
                    priceShip)));


          }
          if (activeStep < upperBound) {
            setState(() {
              activeStep++;
            });
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppConfig.secondaryColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(5)))),
        child: Text(activeStep==1?'ثبت سفارش':'بعدی',style: TextStyle(color: Colors.white,fontSize:activeStep==1?9:12),),
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
        child: Text('قبلی',style: TextStyle(color: Colors.white,fontSize: 12),),
        style: ElevatedButton.styleFrom(
            backgroundColor: AppConfig.secondaryColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(5)))),
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
                dashGradient: [Colors.red, Colors.blue],
                dashRadius: 0.0,
                dashGapLength: 4.0,
                dashGapColor: Colors.transparent,
                dashGapGradient: [Colors.red, Colors.blue],
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

  String headerText() {
    switch (activeStep) {
      case 1:
        return 'Preface';

      case 2:
        return 'Table of Contents';

      default:
        return 'Introduction';
    }
  }
}
