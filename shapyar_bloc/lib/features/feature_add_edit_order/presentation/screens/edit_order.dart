/*
import 'package:flutter/material.dart';
import 'package:shop_manager_bloc/core/params/home_user_data_params.dart';
import 'package:shop_manager_bloc/core/params/setOrderPArams.dart';
import 'package:shop_manager_bloc/core/utils/static_values.dart';
import 'package:shop_manager_bloc/features/feature_add_edit_order/presentation/bloc/add_order_status.dart';
import 'package:shop_manager_bloc/features/feature_orders/domain/entities/orders_entity.dart';
import '../../../../core/params/products_params.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/widgets/alert_dialog.dart';
import '../../../../locator.dart';
import '../../data/models/add_order_orders_model.dart';
import '../../domain/entities/add_order_orders_entity.dart';
import '../bloc/add_order_bloc.dart';
import '../bloc/add_order_data_status.dart';
import '../bloc/add_order_set_order_status.dart';
import '../widgets/edit_order_bill.dart';
import '../widgets/edit_order_product.dart';

class EditOrder extends StatefulWidget {
  static const routeName = '/edit_order';

  final OrdersEntity ordersEntity;

  EditOrder(this.ordersEntity);

  @override
  _EditOrderState createState() => _EditOrderState();
}

class _EditOrderState extends State<EditOrder> {

  int _currentStep = 0;
  */
/*List<PaymentMethod>? paymentMethod = [];
  List<ShippingMethod>? shipmentMethod = [];
  *//*


  List pay = [];
  List ship = [];


  String customerLNBill ='';
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
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    customerLNBill =widget.ordersEntity.billing!.lastName;
     customerFNBill = widget.ordersEntity.billing!.firstName;
     cityBill = widget.ordersEntity.billing!.city;
     provinceBill = widget.ordersEntity.billing!.state;
     addressBill = widget.ordersEntity.billing!.address1;
     postalCodeBill = widget.ordersEntity.billing!.postcode;
     emailBill = widget.ordersEntity.billing!.email.toString();
     phoneBill = widget.ordersEntity.billing!.phone;
     shipmentBill = widget.ordersEntity.shippingLines![0].methodTitle.toString();
     paymentBill = widget.ordersEntity.paymentMethodTitle.toString();
     shipPriceBill = widget.ordersEntity.shippingLines![0].total.toString();
     lineItem = [];
    shippingLine = [];
  }


  @override
  Widget build(BuildContext context) {
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
    print("paymentBill");
    print(widget.ordersEntity.shippingLines![0].methodTitle.toString());
    print(phoneBill);
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
 //   final args = ModalRoute.of(context)!.settings.arguments as OrderDetailScreenData;

    return BlocProvider<AddOrderBloc>(
        create: (context) => AddOrderBloc(locator(), locator(), locator(), locator()),
        child: BlocBuilder<AddOrderBloc, AddOrderState>(
          builder: (context, state) {
            if (state.addOrderDataStatus is AddOrderDataLoadingStatus) {
              print("1");
              BlocProvider.of<AddOrderBloc>(context)
                  .add(LoadAddOrderData(UserDataParams("", "",{})));

              return Center(child: CircularProgressIndicator());
            }
            if (state.addOrderDataStatus is AddOrderDataLoadedStatus) {
              print("2");
              BlocProvider.of<AddOrderBloc>(context)
                  .add(LoadAddOrderProductsData(ProductsParams(10)));

              AddOrderDataLoadedStatus addOrderDataStatus =
                  state.addOrderDataStatus as AddOrderDataLoadedStatus;
             */
/* paymentMethod =
                  addOrderDataStatus.addOrderDataEntity.paymentMethods;
              shipmentMethod =
                  addOrderDataStatus.addOrderDataEntity.shippingMethods;*//*

              StaticValues.paymentMethods!.forEach((element) {
                pay.add(element['method_title']);
              });
              StaticValues.shippingMethods!.forEach((element) {
                ship.add(element['method_title']);
              });
            }
           */
/* print("pay");
            print(pay);*//*

            if (state.addOrderDataStatus is AddOrderDataErrorStatus) {
              print("3");
              return Center(child: Text("roror"));
            }
            if (state.addOrderStatus is AddOrderProductsLoadingStatus) {
              print("4");
              return Center(child: CircularProgressIndicator());
            }
            if (state.addOrderStatus is AddOrderProductsLoadedStatus) {
              AddOrderProductsLoadedStatus addOrderProductsLoadedStatus =
                  state.addOrderStatus as AddOrderProductsLoadedStatus;
              print("5");
              print(addOrderProductsLoadedStatus.cart);
              return Stack(
                children: [
                  Scaffold(
                    backgroundColor: Colors.white,
                    body: Stepper(
                      currentStep: _currentStep,
                      onStepTapped: (step) {
                        setState(() => _currentStep = step);
                        print("step1");
                      },
                      steps: [
                        Step(
                          title: Text('مشخصات صورتحساب'),
                          content: EditOrderBill( onTextChange, widget.ordersEntity),
                          isActive: _currentStep == 0,
                        ),
                        Step(
                          title: Text('محصولات'),
                          content: Container(
                              width: width * 0.7,
                              height: height * 0.55,
                              child: ListView.builder(
                                itemCount: addOrderProductsLoadedStatus
                                    .addOrderProductEntity!.length,
                                itemBuilder: (context, index) {
                                  print("6");
                                  final currentProduct = addOrderProductsLoadedStatus
                                      .addOrderProductEntity![index];
                                  final products = addOrderProductsLoadedStatus
                                      .addOrderProductEntity;
                                  0;
                                  */
/*  print(product.name);
                                      print("count");
                                      print(count);*//*


                                  return EditOrderProduct(currentProduct, products, index, widget.ordersEntity);
                                },
                              )),
                          isActive: _currentStep == 1,
                        ),
                      ],
                    ),
                  ),
                  BlocConsumer<AddOrderBloc, AddOrderState>(
                    listener: (context, state){
                      if(state.addOrderSetOrderStatus is AddOrderSetOrderSuccess){
                        alertDialog(context, "سفارش با موفقیت ویرایش شد !", 1, false);
                      }
                      if(state.addOrderSetOrderStatus is AddOrderSetOrderFailed){
                        alertDialog(context, "خطا در ثبت سفارش !", 1, false);
                      }
                    },
  builder: (context, state) {
    if(state.addOrderSetOrderStatus is AddOrderSetOrderLoadingStatus) {
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
                  backgroundColor: MaterialStateProperty.all<Color>(
                      Colors.deepPurple),
                  shape: MaterialStateProperty.all<
                      RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.circular(width * 0.02),
                      ))),
              onPressed: () {*/
/*
                print("customerLNBill");
                print(shipmentBill);
                print(paymentBill);
                double totalPrice = 0;
                for (final entry in state.count.entries) {
                  if(entry.value != 0){
                    final productId = entry.key;
                    final quantity = entry.value;

                    lineItem.add(LineItem(
                      id: 0,
                      productId: productId,
                      name: "",
                      quantity: quantity,
                      total: totalPrice.toString(),
                    ));
                  }}
                AddOrderOrdersEntity order = AddOrderOrdersEntity(
                    id: 0,
                    status: 'در انتظار',
                    total: "2000",
                    billing: Ing(
                        firstName: customerLNBill,
                        lastName: customerFNBill,
                        address1: addressBill,
                        city: cityBill,
                        email: emailBill,
                        state: provinceBill,
                        postcode: postalCodeBill,
                        country: "ایران",
                        phone: phoneBill
                    ),
                    shipping: Ing(
                        firstName: customerLNBill,
                        lastName: customerFNBill,
                        address1: addressBill,
                        city: cityBill,
                        email: emailBill,
                        state: provinceBill,
                        postcode: postalCodeBill,
                        country: "ایران",
                        phone: phoneBill
                    ),
                    paymentMethod: paymentBill,
                    paymentMethodTitle: paymentBill,
                    lineItems: lineItem,
                    shippingLines: shippingLine
                );

                print(state.count);
                var payType ='';
                if (StaticValues.paymentMethods!.isNotEmpty) {
                  payType = StaticValues.paymentMethods![pay.indexOf(paymentBill)]['method_id'].toString();
                }
                var shipType ='';
                if ( StaticValues.shippingMethods!.isNotEmpty) {
                  int index = ship.indexWhere((element) => shipmentBill.contains(element));
                  if (index != -1) {
                    shipType = StaticValues.shippingMethods![index]['method_id'].toString();
                  } else {

                    print('No matching shipping method found for shipmentBill');
                    shipType = 'free_shipping:1'; // or some fallback logic
                  }
                }
                print("payType");
                print(payType);
                print(shipType);
                String priceShip = shipPriceBill.isEmpty?"":shipPriceBill;
                context.read<AddOrderBloc>().add(
                    SetOrder(SetOrderParams(order,"","",payType,shipType,priceShip)));*//*

              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                      child: Text("لطفا منتظر بمانید ...",style: TextStyle(color: Colors.white),))
                ],
              )),
        ),
      );
    }
    */
/*if(state.addOrderSetOrderStatus is AddOrderSetOrderSuccess){
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
                  backgroundColor: MaterialStateProperty.all<Color>(
                      Colors.deepPurple),
                  shape: MaterialStateProperty.all<
                      RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.circular(width * 0.02),
                      ))),
              onPressed: () {
              },
              child: Container(
                  width: width * 0.3,
                  alignment: Alignment.center,
                  child: Text("ثبت شد",style: TextStyle(color: Colors.white)))),
        ),
      );
    }*//*

    */
/* if(state.addOrderSetOrderStatus is AddOrderSetOrderFailed){
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
                  backgroundColor: MaterialStateProperty.all<Color>(
                      Colors.deepPurple),
                  shape: MaterialStateProperty.all<
                      RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.circular(width * 0.02),
                      ))),
              onPressed: () {
              },
              child: Container(
                  width: width * 0.3,
                  alignment: Alignment.center,
                  child: Text("ثبت نشد",style: TextStyle(color: Colors.white)))),
        ),
      );
    }*//*

      if(state.addOrderSetOrderStatus is AddOrderSetOrderInitialStatus ){
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
                backgroundColor: MaterialStateProperty.all<Color>(
                    Colors.deepPurple),
                shape: MaterialStateProperty.all<
                    RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(width * 0.02),
                    ))),
            onPressed: () {
              print("customerLNBill");
              print(shipmentBill);
              print(paymentBill);
              double totalPrice = 0;
              for (final entry in state.count.entries) {
                if(entry.value != 0){
                final productId = entry.key;
                final quantity = entry.value;

                lineItem.add(LineItem(
                  id: 0,
                  productId: productId,
                  name: "",
                  quantity: quantity,
                  total: totalPrice.toString(),
                ));
              }}
              AddOrderOrdersEntity order = AddOrderOrdersEntity(
                  id: 0,
                  status: 'در انتظار',
                  total: "2000",
                  billing: Ing(
                      firstName: customerLNBill,
                      lastName: customerFNBill,
                      address1: addressBill,
                      city: cityBill,
                      email: emailBill,
                      state: provinceBill,
                      postcode: postalCodeBill,
                      country: "ایران",
                      phone: phoneBill
                  ),
                  shipping: Ing(
                      firstName: customerLNBill,
                      lastName: customerFNBill,
                      address1: addressBill,
                      city: cityBill,
                      email: emailBill,
                      state: provinceBill,
                      postcode: postalCodeBill,
                      country: "ایران",
                      phone: phoneBill
                  ),
                  paymentMethod: paymentBill,
                  paymentMethodTitle: paymentBill,
                  lineItems: lineItem,
                  shippingLines: shippingLine
              );

              print(state.count);
              var payType ='';
              if (StaticValues.paymentMethods!.isNotEmpty) {
                payType = StaticValues.paymentMethods![pay.indexOf(paymentBill)]['method_id'].toString();
              }
              var shipType ='';
              if ( StaticValues.shippingMethods!.isNotEmpty) {
                int index = ship.indexWhere((element) => shipmentBill.contains(element));
                if (index != -1) {
                  shipType = StaticValues.shippingMethods![index]['method_id'].toString();
                } else {

                  print('No matching shipping method found for shipmentBill');
                  shipType = 'free_shipping:1'; // or some fallback logic
                }
              }
                print("payType");
                print(payType);
                print(shipType);
              String priceShip = shipPriceBill.isEmpty?"":shipPriceBill;
              context.read<AddOrderBloc>().add(
                  SetOrder(SetOrderParams(order,"","",payType,shipType,priceShip)));
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                    child: Text("ویرایش سفارش",style: TextStyle(color: Colors.white),))
              ],
            )),
      ),
    );
  }
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
                backgroundColor: MaterialStateProperty.all<Color>(
                    Colors.deepPurple),
                shape: MaterialStateProperty.all<
                    RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(width * 0.02),
                    ))),
            onPressed: () {
              print("customerLNBill");
              print(shipmentBill);
              print(paymentBill);
              double totalPrice = 0;
              for (final entry in state.count.entries) {
                if(entry.value != 0){
                  final productId = entry.key;
                  final quantity = entry.value;

                  lineItem.add(LineItem(
                    id: 0,
                    productId: productId,
                    name: "",
                    quantity: quantity,
                    total: totalPrice.toString(),
                  ));
                }}
              AddOrderOrdersEntity order = AddOrderOrdersEntity(
                  id: 0,
                  status: 'در انتظار',
                  total: "2000",
                  billing: Ing(
                      firstName: customerLNBill,
                      lastName: customerFNBill,
                      address1: addressBill,
                      city: cityBill,
                      email: emailBill,
                      state: provinceBill,
                      postcode: postalCodeBill,
                      country: "ایران",
                      phone: phoneBill
                  ),
                  shipping: Ing(
                      firstName: customerLNBill,
                      lastName: customerFNBill,
                      address1: addressBill,
                      city: cityBill,
                      email: emailBill,
                      state: provinceBill,
                      postcode: postalCodeBill,
                      country: "ایران",
                      phone: phoneBill
                  ),
                  paymentMethod: paymentBill,
                  paymentMethodTitle: paymentBill,
                  lineItems: lineItem,
                  shippingLines: shippingLine
              );

              print(state.count);
              var payType ='';
              if (StaticValues.paymentMethods!.isNotEmpty) {
                payType = StaticValues.paymentMethods![pay.indexOf(paymentBill)]['method_id'].toString();
              }
              var shipType ='';
              if ( StaticValues.shippingMethods!.isNotEmpty) {
                int index = ship.indexWhere((element) => shipmentBill.contains(element));
                if (index != -1) {
                  shipType = StaticValues.shippingMethods![index]['method_id'].toString();
                } else {

                  print('No matching shipping method found for shipmentBill');
                  shipType = 'free_shipping:1'; // or some fallback logic
                }
              }
              print("payType");
              print(payType);
              print(shipType);
              String priceShip = shipPriceBill.isEmpty?"":shipPriceBill;
              context.read<AddOrderBloc>().add(
                  SetOrder(SetOrderParams(order,"","",payType,shipType,priceShip)));
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                    child: Text("ویرایش سفارش",style: TextStyle(color: Colors.white),))
              ],
            )),
      ),
    );
  },
)
                ],
              );
            }
            if (state.addOrderStatus is AddOrderProductsErrorStatus) {
              print("6");
              Text("error");
            }
            return Container(
              color: Colors.blue,
            );
          },
        ));
  }
}
*/
