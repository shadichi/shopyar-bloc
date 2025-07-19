import 'package:flutter/material.dart';
import 'package:shapyar_bloc/core/params/home_user_data_params.dart';
import 'package:shapyar_bloc/core/params/setOrderPArams.dart';
import 'package:shapyar_bloc/core/utils/static_values.dart';
import 'package:shapyar_bloc/features/feature_add_edit_order/data/models/add_order_data_model.dart';
import 'package:shapyar_bloc/features/feature_add_edit_order/data/models/add_order_orders_model.dart';
import 'package:shapyar_bloc/features/feature_add_edit_order/presentation/bloc/add_order_status.dart';
import 'package:shapyar_bloc/features/feature_orders/presentation/bloc/orders_bloc.dart';
import 'package:shapyar_bloc/features/feature_products/presentation/widgets/product.dart';
import 'package:shapyar_bloc/test3.dart';
import '../../../../core/params/products_params.dart';
import '../../../../core/widgets/alert_dialog.dart';
import '../../../feature_products/domain/entities/product_entity.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../locator.dart';
import '../../domain/entities/add_order_orders_entity.dart';
import '../../domain/entities/add_order_product_entity.dart';
import '../bloc/add_order_bloc.dart';
import '../bloc/add_order_card_product_status.dart';
import '../bloc/add_order_set_order_status.dart';
import '../widgets/add_order_bill.dart';
import '../widgets/add_order_product.dart';

class AddOrder extends StatefulWidget {
  static const routeName = '/add_order';

  @override
  _AddOrderState createState() => _AddOrderState();
}

class _AddOrderState extends State<AddOrder> {
  int _currentStep = 0;
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
  Widget build(BuildContext context) {
    /* print(StaticValues.paymentMethods);
    print(StaticValues.shippingMethods);*/
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
    print('paymentBill');
    print(paymentBill);
    paymentMethod = StaticValues.paymentMethods
        .map((method) => PaymentMethod.fromJson(method))
        .toList();
    shipmentMethod = StaticValues.shippingMethods
        .map((method) => ShippingMethod.fromJson(method))
        .toList();
    /*  print(paymentMethod![0].methodTitle);
    print(shipmentMethod![0].methodTitle);*/
    // print("ff");
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return BlocProvider<AddOrderBloc>(
      create: (context) => AddOrderBloc(locator(), locator(), locator()),
      child: Stack(
        children: [
          BlocBuilder<AddOrderBloc, AddOrderState>(
            builder: (context, state) {
              Widget bodyContent;

              if (state.addOrderStatus is AddOrderProductsErrorStatus) {
                bodyContent = Center(child: Text('خطا!'));
              } else if (state.addOrderStatus
                  is AddOrderProductsLoadingStatus) {
                BlocProvider.of<AddOrderBloc>(context)
                    .add(LoadAddOrderProductsData());
                bodyContent = Center(child: CircularProgressIndicator());
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

                bodyContent = Stack(
                  children: [
                    Theme(
                      data: ThemeData(
                          colorScheme: ColorScheme.fromSwatch().copyWith(
                            primary: AppColors.section4,
                          ),
                          fontFamily: 'IRANSansWeb'),
                      child: Stepper(
                        controlsBuilder: (context, details) {
                          return Row(
                            children: <Widget>[
                              TextButton(
                                onPressed: (){details.onStepContinue;},
                                child: const Text('ادامه',style: TextStyle(color: AppColors.white70),),
                              ),
                              TextButton(
                                onPressed: (){details.onStepCancel;},
                                child: const Text('لغو',style: TextStyle(color: AppColors.white70),),
                              ),
                            ],
                          );
                        },
                        currentStep: _currentStep,
                        onStepTapped: (step) {
                          setState(() => _currentStep = step);
                        },
                        steps: [
                          Step(
                            title: Text(
                              'مشخصات صورتحساب',
                              style: TextStyle(color: Colors.white),
                            ),
                            content: AddOrderBill(paymentMethod, shipmentMethod,
                                onTextChange, _formKey),
                            isActive: _currentStep == 0,
                              subtitle: Text('مشخصات صورتحساب برای ایجاد سفارش را وارد کنید.',style: TextStyle(color: AppColors.white70),)


                          ),
                          Step(
                            title: Text('محصولات',style: TextStyle(color: AppColors.white),),
                            content: Container(
                              width: width * 0.7,
                              height: height * 0.55,
                              child: ListView.builder(
                                  itemCount: 3,
                                  itemBuilder: (context, index) {
                                    final product =
                                        StaticValues.staticProducts[index];
                                    return AddOrderProduct(product);
                                  }),
                            ),
                            isActive: _currentStep == 1,
                            subtitle: Text('محصولات انتخابی برای ایجاد سفارش را انتخاب کنید.',style: TextStyle(color: AppColors.white70),)
                          ),
                        ],
                      ),
                    ),
                    BlocBuilder<AddOrderBloc, AddOrderState>(
                        builder: (context, state) {
                      if (state.addOrderSetOrderStatus
                          is AddOrderSetOrderLoadingStatus) {
                        return Container(
                          width: width,
                          height: height,
                          padding: EdgeInsets.only(bottom: width * 0.03),
                          alignment: Alignment.bottomCenter,
                          child: SizedBox(
                            height: height * 0.07,
                            width: width * 0.8,
                            child: ElevatedButton(
                                style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            Colors.deepPurple),
                                    shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(width * 0.02),
                                    ))),
                                onPressed: () {},
                                child: Container(
                                    width: width * 0.3,
                                    alignment: Alignment.center,
                                    child: CircularProgressIndicator())),
                          ),
                        );
                      }
                      if (state.addOrderSetOrderStatus
                          is AddOrderSetOrderSuccess) {
                        return Container(
                          width: width,
                          height: height,
                          padding: EdgeInsets.only(bottom: width * 0.03),
                          alignment: Alignment.bottomCenter,
                          child: SizedBox(
                            height: height * 0.07,
                            width: width * 0.8,
                            child: ElevatedButton(
                                style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            Colors.deepPurple),
                                    shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(width * 0.02),
                                    ))),
                                onPressed: () {},
                                child: Container(
                                    width: width * 0.3,
                                    alignment: Alignment.center,
                                    child: Text("ثبت شد",
                                        style:
                                            TextStyle(color: Colors.white)))),
                          ),
                        );
                      }
                      if (state.addOrderSetOrderStatus
                          is AddOrderSetOrderFailed) {
                        return Container(
                          width: width,
                          height: height,
                          padding: EdgeInsets.only(bottom: width * 0.03),
                          alignment: Alignment.bottomCenter,
                          child: SizedBox(
                            height: height * 0.07,
                            width: width * 0.8,
                            child: ElevatedButton(
                                style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            Colors.deepPurple),
                                    shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(width * 0.02),
                                    ))),
                                onPressed: () {},
                                child: Container(
                                    width: width * 0.3,
                                    alignment: Alignment.center,
                                    child: Text("ثبت نشد",
                                        style:
                                            TextStyle(color: Colors.white)))),
                          ),
                        );
                      }
                      if (state.addOrderSetOrderStatus
                          is AddOrderSetOrderInitialStatus) {
                        return Container(
                          width: width,
                          height: height,
                          padding: EdgeInsets.only(bottom: width * 0.03),
                          alignment: Alignment.bottomCenter,
                          child: SizedBox(
                            height: height * 0.07,
                            width: width * 0.8,
                            child: ElevatedButton(
                                style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            Colors.deepPurple),
                                    shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(width * 0.02),
                                    ))),
                                onPressed: () {
                                  _validateForm();
                                  if (lineItem.isEmpty) {
                                    alertDialog(context,
                                        'هیچ محصولی انتخاب نشده است!', 1, true);
                                  } else {
                                    double totalPrice = 0;
                                    for (final entry
                                        in addOrderProductsLoadedStatus
                                            .cart!.entries) {
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
                                    AddOrderOrdersEntity order =
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
                                },
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Expanded(
                                        child: Container(
                                      // width: width*0.06,
                                      alignment: Alignment.center,
                                      child: Text("قیمت کل: ",
                                          style: TextStyle(
                                              fontSize: width * 0.028,
                                              color: Colors.white)),
                                    )),
                                    Container(
                                        width: width * 0.3,
                                        alignment: Alignment.center,
                                        child: Text(
                                          "ثبت سفارش",
                                          style: TextStyle(color: Colors.white),
                                        ))
                                  ],
                                )),
                          ),
                        );
                      }
                      return Container(
                        color: Colors.pink,
                      );
                    })
                  ],
                );
              } else {
                bodyContent = Center(child: Text("خطا در پردازش داده‌ها"));
              }

              return Scaffold(
                backgroundColor: AppColors.background,
                body: bodyContent,
                appBar: AppBar(
                  backgroundColor: AppColors.background,
                  iconTheme: IconThemeData(
                    color: Colors.white, //change your color here
                  ),
                  title: Text(
                    'ایجاد سفارش جدید',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
