/*
import 'package:flutter/material.dart';
import 'package:shapyar_bloc/core/params/products_params.dart';
import 'package:shapyar_bloc/features/feature_products/presentation/bloc/products_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shapyar_bloc/features/feature_products/presentation/widgets/product.dart';
import 'package:shapyar_bloc/test3.dart';
import '../../../../locator.dart';
import 'features/feature_products/presentation/bloc/products_status.dart';
import 'features/feature_products/presentation/widgets/variation_product.dart';

class ProductsScreen extends StatelessWidget {
  static const routeName = "/products_screen";

  const ProductsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isRTL = Directionality.of(context) == TextDirection.rtl;
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return BlocProvider<ProductsBloc>(
      create: (context) => ProductsBloc(locator(), locator()),
      child:
      BlocBuilder<ProductsBloc, ProductsState>(builder: (context, state) {
        if (state.productsStatus is ProductsLoadingStatus) {
          print("OrdersLoadingStatus");
          context
              .read<ProductsBloc>()
              .add(LoadProductsData(ProductsParams(10,false,'')));

          return Center(child: CircularProgressIndicator());
        }
        if (state.productsStatus is UserErrorStatus) {
          return Text("error");
        }
        if (state.productsStatus is pUserLoadedStatus) {
          context
              .read<ProductsBloc>()
              .add(LoadProductsData(ProductsParams(10,false,'')));
        }
        if (state.productsStatus is ProductsErrorStatus) {
          return Text("dataerror");
        }
        if (state.productsStatus is ProductsLoadedStatus) {
          final ProductsLoadedStatus productsLoadedStatus =
          state.productsStatus as ProductsLoadedStatus;

          return Scaffold(
              backgroundColor: AppColors.background,
              */
/*floatingActionButton: FloatingActionButton(
                onPressed: () {},
                backgroundColor: Color(0xff0A369D),
                child: Text(
                  '+',
                  style: TextStyle(color: Colors.white, fontSize: width * 0.08),
                ),
              ),*//*

              // appBar: AppBar(title: Text(homeUserDataParams.userName)),
              // backgroundColor: Colors.red,
              appBar: AppBar(
                title: Text(
                  'همه محصولات',
                  style:
                  TextStyle(fontSize: height * 0.03, color: Colors.white),
                ),
                backgroundColor: AppColors.background,
                // Match app bar color with background
                elevation: 0.0,
                actions: [
                  IconButton(
                    icon: Icon(Icons.search, color: Colors.white),
                    onPressed: () {
                      // Handle search icon press
                    }, //productsLoadedStatus.productsDataState![0].name.toString()
                  ),
                  */
/*  IconButton(
                    icon: Icon(isRTL ? Icons.arrow_forward : Icons.arrow_back,),
                    onPressed: () {
                      Navigator.pushNamed(context,HomeScreen.routeName);
                    }, //productsLoadedStatus.productsDataState![0].name.toString()
                  ),*//*

                ], // Remove shadow for a seamless look
              ),
              body: Container(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        */
/* Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Card(
                            child: Container(
                              width: width * 0.4,
                              height: height * 0.12,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Container(
                                    child: Text(
                                      "200",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  Container(
                                    child: Text(
                                      "محصول در انبار",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  // Start point of the gradient
                                  end: Alignment.bottomRight,
                                  // End point of the gradient
                                  colors: [
                                    AppColors.section3,
                                    // Purple from hex code
                                    Color(int.parse('0xFF0077B6')),
                                    // White
                                  ], //// List of colors in the gradient
                                ),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(
                                      10.0), // Set top-right corner radius
                                ),
                              ),
                            ),
                            elevation: 30,
                          ),
                          Card(
                            child: Container(
                              width: width * 0.4,
                              height: height * 0.12,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Container(
                                    child: Text(
                                      "200",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  Container(
                                    child: Text(
                                      "محصول رو به اتمام",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  // Start point of the gradient
                                  end: Alignment.bottomRight,
                                  // End point of the gradient
                                  colors: [
                                    AppColors.section3,
                                    // Purple from hex code
                                    Color(int.parse('0xFF0077B6')),
                                    // White
                                  ], //// List of colors in the gradient
                                ),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10.0),
                                ),
                              ),
                            ),
                            elevation: 30,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: height * 0.01,
                    ),
                    Card(
                      child: Container(
                        alignment: Alignment.center,
                        width: width * 0.87,
                        height: height * 0.08,
                        child: Text(
                          "اضافه کردن محصول",
                          style: TextStyle(color: Colors.white),
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            // Start point of the gradient
                            end: Alignment.bottomRight,
                            // End point of the gradient
                            colors: [
                              AppColors.section3,
                              // Purple from hex code
                              Color(int.parse('0xFF0077B6')),
                              // White
                            ], // List of colors in the gradient
                          ),
                          borderRadius: BorderRadius.all(
                            Radius.circular(10.0),
                          ),
                        ),
                      ),
                      elevation: 3,
                      shadowColor: Colors.white,
                    ),*//*

                        Container(
                          height: height * 0.2,
                          width: width * 0.85,
                          //  color: Colors.red,
                          child: Column(
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Container(
                                    child: Text(
                                      'سود خالص',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  Container(
                                    child: Text(
                                      'تعداد فروخته شده',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  Container(
                                    child: Text(
                                      'قیمت',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),

                                  Container(
                                    child: Text(
                                      'پرفروش',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                              Divider(
                                color: Colors.white30,
                              ),
                              Container(
                                // color: Colors.yellow,
                                height: height * 0.14,
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Container(
                                            height: height * 0.03,
                                            width: width * 0.1,
                                            //color: Colors.red,
                                            child: Text(
                                              'آیتم 1',
                                              style: TextStyle(color: Colors.green),
                                            ),
                                          ),
                                          Container(
                                            height: height * 0.03,
                                            width: width * 0.1,
                                            //  color: Colors.red,
                                            child: Text(
                                              'آیتم 1',
                                              style: TextStyle(color: Colors.green),
                                            ),
                                          ),
                                          Container(
                                            height: height * 0.03,
                                            width: width * 0.1,
                                            //color: Colors.red,
                                            child: Text(
                                              'آیتم 1',
                                              style: TextStyle(color: Colors.green),
                                            ),
                                          ),
                                          Container(
                                            height: height * 0.03,
                                            width: width * 0.1,
                                            //    color: Colors.red,
                                            child: Text(
                                              'آیتم 1',
                                              style: TextStyle(color: Colors.green),
                                            ),
                                          ),
                                          Container(
                                            height: height * 0.03,
                                            width: width * 0.1,
                                            //  color: Colors.red,
                                            child: Text(
                                              'آیتم 1',
                                              style: TextStyle(color: Colors.green),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Divider(
                                        color: Colors.white30,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Container(
                                            height: height * 0.03,
                                            width: width * 0.1,
                                            //color: Colors.red,
                                            child: Text(
                                              'آیتم 1',
                                              style: TextStyle(color: Colors.green),
                                            ),
                                          ),
                                          Container(
                                            height: height * 0.03,
                                            width: width * 0.1,
                                            //  color: Colors.red,
                                            child: Text(
                                              'آیتم 1',
                                              style: TextStyle(color: Colors.green),
                                            ),
                                          ),
                                          Container(
                                            height: height * 0.03,
                                            width: width * 0.1,
                                            //color: Colors.red,
                                            child: Text(
                                              'آیتم 1',
                                              style: TextStyle(color: Colors.green),
                                            ),
                                          ),
                                          Container(
                                            height: height * 0.03,
                                            width: width * 0.1,
                                            //    color: Colors.red,
                                            child: Text(
                                              'آیتم 1',
                                              style: TextStyle(color: Colors.green),
                                            ),
                                          ),
                                          Container(
                                            height: height * 0.03,
                                            width: width * 0.1,
                                            //  color: Colors.red,
                                            child: Text(
                                              'آیتم 1',
                                              style: TextStyle(color: Colors.green),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Divider(
                                        color: Colors.white30,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Container(
                                            height: height * 0.03,
                                            width: width * 0.1,
                                            //color: Colors.red,
                                            child: Text(
                                              'آیتم 1',
                                              style: TextStyle(color: Colors.green),
                                            ),
                                          ),
                                          Container(
                                            height: height * 0.03,
                                            width: width * 0.1,
                                            //  color: Colors.red,
                                            child: Text(
                                              'آیتم 1',
                                              style: TextStyle(color: Colors.green),
                                            ),
                                          ),
                                          Container(
                                            height: height * 0.03,
                                            width: width * 0.1,
                                            //color: Colors.red,
                                            child: Text(
                                              'آیتم 1',
                                              style: TextStyle(color: Colors.green),
                                            ),
                                          ),
                                          Container(
                                            height: height * 0.03,
                                            width: width * 0.1,
                                            //    color: Colors.red,
                                            child: Text(
                                              'آیتم 1',
                                              style: TextStyle(color: Colors.green),
                                            ),
                                          ),
                                          Container(
                                            height: height * 0.03,
                                            width: width * 0.1,
                                            //  color: Colors.red,
                                            child: Text(
                                              'آیتم 1',
                                              style: TextStyle(color: Colors.green),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Divider(
                                        color: Colors.white30,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Container(
                                            height: height * 0.03,
                                            width: width * 0.1,
                                            //color: Colors.red,
                                            child: Text(
                                              'آیتم 1',
                                              style: TextStyle(color: Colors.green),
                                            ),
                                          ),
                                          Container(
                                            height: height * 0.03,
                                            width: width * 0.1,
                                            //  color: Colors.red,
                                            child: Text(
                                              'آیتم 1',
                                              style: TextStyle(color: Colors.green),
                                            ),
                                          ),
                                          Container(
                                            height: height * 0.03,
                                            width: width * 0.1,
                                            //color: Colors.red,
                                            child: Text(
                                              'آیتم 1',
                                              style: TextStyle(color: Colors.green),
                                            ),
                                          ),
                                          Container(
                                            height: height * 0.03,
                                            width: width * 0.1,
                                            //    color: Colors.red,
                                            child: Text(
                                              'آیتم 1',
                                              style: TextStyle(color: Colors.green),
                                            ),
                                          ),
                                          Container(
                                            height: height * 0.03,
                                            width: width * 0.1,
                                            //  color: Colors.red,
                                            child: Text(
                                              'آیتم 1',
                                              style: TextStyle(color: Colors.green),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Divider(
                                        color: Colors.white30,
                                      )
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: height * 0.01,
                        ),
                        Center(
                          child: Container(
                            height: height * 0.5,
                            width: width * 0.87,
                            child: ListView.builder(
                              itemCount:
                              productsLoadedStatus.productsDataState!.length,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  child: Product(productsLoadedStatus
                                      .productsDataState![index]),
                                  onTap: () {
                                    if (productsLoadedStatus
                                        .productsDataState![index]
                                        .childes!
                                        .isEmpty) {
                                      var snackBar = SnackBar(
                                          content: Text('بدون محصول متغیر ...'));
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(snackBar);
                                    } else {
                                      print("dd");
                                      showModalBottomSheet(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.vertical(
                                              top: Radius.circular(10),
                                            ),
                                          ),
                                          context: context,
                                          builder: (context) {
                                            // mainpageProvider.checkIsPendingFilter();
                                            return Builder(
                                                builder: (BuildContext context) {
                                                  return VariationProduct(
                                                      productsLoadedStatus,
                                                      index,
                                                      productsLoadedStatus
                                                          .productsDataState![index]
                                                          .childes!
                                                          .length -
                                                          1);
                                                });
                                          });
                                    }
                                  },
                                );
                              },
                            ),
                          ),
                        )
                      ],
                    ),
                  )));
        }
        return Container();
      }),
    );
  }
}
*/
