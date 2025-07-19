import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:shapyar_bloc/core/params/products_params.dart';
import 'package:shapyar_bloc/features/feature_products/presentation/bloc/products_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shapyar_bloc/features/feature_products/presentation/widgets/product.dart';
import 'package:shapyar_bloc/test3.dart';
import '../../../locator.dart';
import 'features/feature_products/presentation/bloc/products_status.dart';
import 'features/feature_products/presentation/widgets/ending_product.dart';

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

                ], // Remove shadow for a seamless look
              ),
              body: Container(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [

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
                                          SizedBox(
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
                        Container(
                          width: width * 0.85,
                          alignment: Alignment.centerRight,
                          child: Text(
                            'محصولات رو به اتمام',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        Center(
                          child: SizedBox(
                              height: height * 0.15,
                              width: width * 0.87,
                              // color: Colors.red,
                              child: EndingProduct(
                                  productsLoadedStatus.productsDataState![3])),
                        ),
                        SizedBox(
                          height: height * 0.01,
                        ),
                        Container(
                          width: width * 0.85,
                          alignment: Alignment.centerRight,
                          child: Text(
                            'محصولات',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        Center(
                          child: SizedBox(
                            // color: Colors.red,
                            height: height * 0.5,
                            width: width * 0.87,
                            child: GridView.builder(
                              gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3, // Number of columns
                                crossAxisSpacing: 0, // Horizontal spacing
                                mainAxisSpacing: 1, // Vertical spacing
                              ),
                              // padding: EdgeInsets.all(10),
                              itemCount: productsLoadedStatus.productsDataState!
                                  .length, // Number of items in the grid
                              itemBuilder: (context, index) {
                                return Product(
                                    productsLoadedStatus.productsDataState![index]);
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
