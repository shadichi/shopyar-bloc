import 'package:flutter/material.dart';
import 'package:shapyar_bloc/features/feature_orders/domain/entities/orders_entity.dart';
import '../../../../core/params/add_order_get_selected_products_params.dart';
import '../../../../core/params/selected_products-params.dart';
import '../../../feature_products/domain/entities/product_entity.dart';
import '../../domain/entities/add_order_product_entity.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/add_order_bloc.dart';
import '../bloc/add_order_card_product_status.dart';

class EditOrderProduct extends StatelessWidget {
  ProductEntity currentProducts;
  List<AddOrderProductEntity>? products;
  int item;
  OrdersEntity ordersEntity;

  EditOrderProduct(
      this.currentProducts, this.products, this.item, this.ordersEntity);

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Card(
      child: Container(
        width: width,
        height: height * 0.21,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(width * 0.03)),
          color: Colors.white,
        ),
        child: Column(
          children: [
            Container(
              child: Row(
                children: [
                  Container(
                    child: Column(
                      children: [
                        Container(
                            child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: LayoutBuilder(
                                  builder: (context, constraints) {
                                    final width = constraints.maxWidth;
                                    var fontSize = 11.0;
                                    if (width <= 480) {
                                      fontSize = 10.0;
                                    } else if (width > 480 && width <= 960) {
                                      fontSize = 12.0;
                                    } else {
                                      fontSize = 11;
                                    }
                                    return Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            currentProducts.name.toString() +
                                                currentProducts.id.toString(),
                                            textAlign: TextAlign.center,
                                            style:
                                                TextStyle(fontSize: fontSize),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                )),
                            width: width * 0.6,
                            alignment: Alignment.centerRight),
                        SizedBox(
                          height: height * 0.01,
                        ),
                        Container(
                          child:
                              Text('${currentProducts.price.toString()} تومان'),
                          /*  color: Colors.yellow,*/
                          width: width * 0.4,
                          alignment: Alignment.centerRight,
                        ),
                      ],
                    ),
                    /*  color: Colors.grey,*/
                    width: width * 0.5,
                  ),
                  Container(
                    child: currentProducts.image.toString().isNotEmpty
                        ? Image.network(currentProducts.image.toString())
                        : Image.asset("assets/images/index.png"),
                    width: width * 0.14,
                    height: height * 0.07,
                    alignment: Alignment.centerLeft,
                  ),
                ],
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
              ),
              /* color: Colors.deepPurple,*/
              padding: EdgeInsets.symmetric(
                  horizontal: height * 0.01, vertical: height * 0.01),
            ),
            Divider(),
            Column(
              children: [
                BlocBuilder<AddOrderBloc, AddOrderState>(
                    builder: (context, state) {
                  int count = 0;
                  bool flag = false;
                  if(state.count.containsKey(currentProducts.id)){
               //     print("nothing");
                  }else{
                    try {
                      var matchedLineItem = ordersEntity.lineItems!.firstWhere(
                            (element) => element.productId == currentProducts.id,
                      );
                      count = matchedLineItem.quantity;
                      context
                          .read<AddOrderBloc>()
                          .add(addCurrentProducts(currentProducts, count));
                      flag = true;
                    } catch (e) {
                      count = 0;
                    }
                  }

                  return Container(
                    // color: Colors.blueAccent,
                    width: width * 0.6,
                    height: height * 0.085,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          child: Container(
                            alignment: Alignment.center,
                            width: width * 0.1,
                            height: height * 0.04,
                            child: Icon(
                              Icons.add_circle, // Use the built-in add icon
                              size: width * 0.07,
                              color: Colors.blueAccent,
                            ),
                          ),
                          onTap: () {
                            context
                                .read<AddOrderBloc>()
                                .add(AddOrderAddProduct(currentProducts));
                          },
                        ),
                        BlocBuilder<AddOrderBloc, AddOrderState>(
                          builder: (context, state) {
                            /*if(state.count != 0){
                              flag = false;
                            }*/
                           /* print("state.isFirstTime");
                            print(state.isFirstTime);*/
                            print(state.count);
                            return Container(
                                alignment: Alignment.center,
                                width: width * 0.1,
                                height: height * 0.04,
                                child: Text(
                                  state.count[currentProducts.id].toString()=="null"?"0":state.count[currentProducts.id].toString()
                               //   count!=0?count.toString():state.count[currentProducts.id].toString()
                                //  flag?count.toString():state.count[currentProducts.id].toString().isEmpty?"0":state.count[currentProducts.id].toString()
                                  ,
                                  style: TextStyle(
                                      fontSize: width * 0.04,
                                      color: Colors.black),
                                ));
                          },
                        ),
                        GestureDetector(
                          child: Container(
                            alignment: Alignment.center,
                            width: width * 0.1,
                            height: height * 0.04,
                            child: Icon(
                              Icons.remove_circle,
                              // Use the built-in add icon
                              size: width * 0.07,
                              color: Colors.blueAccent,
                            ),
                          ),
                          onTap: () {
                            context
                                .read<AddOrderBloc>()
                                .add(DecreaseProductCount(currentProducts));
                          },
                        ),
                      ],
                    ),
                  );

                  /*
                  if (state.addOrderCardProductStatus
                      is AddOrderCardProductNotLoaded) {

                    ListTile(
                    //  title: Text(currentProducts.name.toString()),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Button to decrease the count
                          IconButton(
                            icon: Icon(Icons.remove),
                            onPressed: () {
                              // Dispatch DecreaseProductCount event
                              context.read<AddOrderBloc>().add(
                                  DecreaseProductCount(currentProducts));
                            },
                          ),
                          // Display the count of the product
                          Text("add"),
                          // Button to increase the count
                          IconButton(
                            icon: Icon(Icons.add),
                            onPressed: () {
                              // Dispatch IncreaseProductCount event
                              context.read<AddOrderBloc>().add(
                                  AddOrderAddProduct(currentProducts));

                                    print("countttt");
                                                print(product.name);
                                                print(count);
                                                print("ff");
                            },
                          ),
                        ],
                      ),
                    );
                  }
                  if (state.addOrderCardProductStatus
                      is AddOrderCardProductLoaded) {
                    print("11");
                    AddOrderCardProductLoaded editOrderProductsInitialStatus =
                        state.addOrderCardProductStatus
                            as AddOrderCardProductLoaded;

                    final count = editOrderProductsInitialStatus
                            .cart[currentProducts.id] ?? 0;
                    print("ordersEntity.lineItems![item].id");
                    var flag = false;
                    products!.forEach((element) {
                      if(element.id == ordersEntity.lineItems![item].productId){
                        flag = true;
                      }
                    });
                    ordersEntity.lineItems![item].productId ?? 0;
                    return !flag

                        ? Container(
                            color: Colors.grey,
                            alignment: Alignment.center,
                            width: width * 0.7,
                            height: height * 0.09,
                            child: Container(
                              width: width * 0.3,
                              height: height * 0.04,
                              child: ElevatedButton(
                                  style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              Colors.blueAccent),
                                      shape: MaterialStateProperty.all<
                                              RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(width * 0.02),
                                      ))),
                                  onPressed: () {
                                    context.read<AddOrderBloc>().add(
                                        AddOrderAddProduct(
                                            currentProducts));
                                  },
                                  child: Text(
                                    "انتخاب محصول",
                                    style: TextStyle(
                                        fontSize: width * 0.03,
                                        color: Colors.white),
                                  )),
                            ),
                          )
                        : Container(
                            color: Colors.blueAccent,
                            width: width * 0.6,
                            height: height * 0.085,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  child: Container(
                                    alignment: Alignment.center,
                                    width: width * 0.1,
                                    height: height * 0.04,
                                    child: Icon(
                                      Icons
                                          .add_circle, // Use the built-in add icon
                                      size: width * 0.07,
                                      color: Colors.blueAccent,
                                    ),
                                  ),
                                  onTap: () {
                                    context.read<AddOrderBloc>().add(
                                        AddOrderAddProduct(
                                            currentProducts));
                                  },
                                ),
                                Container(
                                    alignment: Alignment.center,
                                    width: width * 0.1,
                                    height: height * 0.04,
                                    child: Text(
                                      count.toString(),
                                      style: TextStyle(
                                          fontSize: width * 0.04,
                                          color: Colors.black),
                                    )),
                                GestureDetector(
                                  child: Container(
                                    alignment: Alignment.center,
                                    width: width * 0.1,
                                    height: height * 0.04,
                                    child: Icon(
                                      Icons.remove_circle,
                                      // Use the built-in add icon
                                      size: width * 0.07,
                                      color: Colors.blueAccent,
                                    ),
                                  ),
                                  onTap: () {
                                    context.read<AddOrderBloc>().add(
                                        DecreaseProductCount(
                                            currentProducts));
                                  },
                                ),
                              ],
                            ),
                          );
                  }
                  print("33");

                  return Container(
                    color: Colors.grey,

                    alignment: Alignment.center,
                    width: width * 0.7,
                    height: height * 0.09,
                    child: Container(
                      width: width * 0.3,
                      height: height * 0.04,
                      child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Colors.blueAccent),
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(width * 0.02),
                              ))),
                          onPressed: () {
                            context.read<AddOrderBloc>().add(
                                AddOrderAddProduct(currentProducts));
                          },
                          child: Text(
                            "انتخاب محصول",
                            style: TextStyle(
                                fontSize: width * 0.03, color: Colors.white),
                          )),
                    ),
                  );*/
                }),
                /* Container(
                  child: Row(
                    children: [
                      Container(
                        child: Column(
                          children: [
                            Container(
                              */ /*color: Colors.black12,*/ /*
                              child: Text(
                                editOrderProductEntity.stockQuantity.toString(),
                                style: TextStyle(
                                    color: int.tryParse(editOrderProductEntity
                                                .stockQuantity
                                                .toString()) ==
                                            null
                                        ? Colors.green
                                        : int.tryParse(editOrderProductEntity
                                                    .stockQuantity
                                                    .toString())! <
                                                30
                                            ? Colors.red
                                            : Colors.green),
                              ) */ /*,color: Colors.grey*/ /*,
                              width: width * 0.3,
                              height: height * 0.025,
                            ),
                            Container(
                              child: Text(
                                "موجودی انبار",
                                style: TextStyle(color: Colors.grey),
                              ),
                              */ /*color: Colors.green,*/ /*
                              width: width * 0.3,
                              height: height * 0.025,
                            ),
                          ],
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        ),
                       */ /* color: Colors.blue,*/ /*
                        height: height * 0.07,
                      ),
                      Container(
                        child: Column(
                          children: [
                            Container(
                              child: Text(
                                  editOrderProductEntity.totalSales.toString()),
                            */ /*  color: Colors.grey,*/ /*
                              width: width * 0.3,
                              height: height * 0.025,
                            ),
                            Container(
                              child: Text(
                                "فروش کلی",
                                style: TextStyle(color: Colors.grey),
                              ) */ /*,color: Colors.green*/ /*,
                              width: width * 0.3,
                              height: height * 0.025,
                            ),
                          ],
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        ),
                       */ /* color: Colors.blue,*/ /*
                        height: height * 0.07,
                      )
                    ],
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                  ),
                  */ /*color: Colors.blueGrey,*/ /*
                )*/
              ],
            )
          ],
        ),
      ),
      elevation: 8,
      color: Colors.white,
    );
  }
}
