import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:shapyar_bloc/core/params/products_params.dart';
import 'package:shapyar_bloc/features/feature_products/presentation/bloc/products_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shapyar_bloc/features/feature_products/presentation/widgets/product.dart';
import 'package:shapyar_bloc/test3.dart';
import '../../../../core/utils/static_values.dart';
import '../../../../core/widgets/alert_dialog.dart';
import '../../../../locator.dart';
import '../bloc/products_status.dart';
import '../widgets/ending_product.dart';
import '../widgets/variation_product.dart';
import 'package:anim_search_bar/anim_search_bar.dart';

class ProductsScreen extends StatelessWidget {
  static const routeName = "/products_screen";

  ProductsScreen({Key? key}) : super(key: key);

  TextEditingController searchProduct = TextEditingController();
  bool searchTemp = true;

  @override
  Widget build(BuildContext context) {
    final isRTL = Directionality.of(context) == TextDirection.rtl;
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return BlocProvider<ProductsBloc>(
      create: (context) => ProductsBloc(locator(), locator()),
      child:
          BlocConsumer<ProductsBloc, ProductsState>(
            listener: (context, state){
              if (state.productsStatus is ProductsSearchFailedStatus){
                alertDialog(context,'هیچ محصولی یافت نشد!',1,false);
              }
            },
              builder: (context, state) {
        if (state.productsStatus is ProductsLoadingStatus) {
          print("OrdersLoadingStatus");
          context
              .read<ProductsBloc>()
              .add(LoadProductsData(ProductsParams(10, false, '')));

          return Center(child: CircularProgressIndicator());
        }
        if (state.productsStatus is UserErrorStatus) {
          return Text("error");
        }
        if (state.productsStatus is pUserLoadedStatus) {
          context
              .read<ProductsBloc>()
              .add(LoadProductsData(ProductsParams(10, false, '')));
        }
        if (state.productsStatus is ProductsErrorStatus) {
          return Text("خطا هنگام بارگذاری محصولات!");
        }
    /*    if (state.productsStatus is ProductsSearchFailedStatus) {
          return Container(
              height: height,
              width: width,alignment: Alignment.center,
              child: Center(
                  child: Container(//color: Colors.red,
                    height: height*0.14,
                    child: Column(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                    Text(
                      "محصول مورد نظر پیدا نشد!",
                      style: TextStyle(color: Colors.white),
                    ),
                    ElevatedButton(onPressed: (){
                      StaticValues.staticProducts.clear();
                      BlocProvider.of<ProductsBloc>(context).add(
                          LoadProductsData(
                              ProductsParams(10, false, '')));
                    }, child: Text('بازگشت'))
                                    ],
                                  ),
                  )));
        }*/
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
                  AnimSearchBar(
                    color: AppColors.background,
                    searchIconColor: Colors.white,
                    width: width * 0.7,
                    helpText: 'جستجو',
                    style: TextStyle(fontSize: width * 0.04),
                    textController: searchProduct,
                    onSuffixTap: () {
                      print('onSuffixTap');
                      /* setState(() {
                    textEditingController.clear();
                  });*/
                    },
                    onSubmitted: (String) {
                      if (String.isEmpty) {
                        searchTemp = false;
                        StaticValues.staticOrders.clear();
                      }
                      print(String);
                      BlocProvider.of<ProductsBloc>(context).add(
                          LoadProductsData(
                              ProductsParams(10, true, searchProduct.text)));
                      searchProduct.clear();
                    },
                  ),
                ], // Remove shadow for a seamless look
              ),
              body: Container(
                  child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: height * 0.01,
                    ),
                    Center(
                      child: Container(
                        // color: Colors.red,
                        height: height * 0.768,
                        width: width * 0.87,
                        child: GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3, // Number of columns
                            crossAxisSpacing: 0, // Horizontal spacing
                            mainAxisSpacing: 1, // Vertical spacing
                          ),
                          // padding: EdgeInsets.all(10),
                          itemCount: StaticValues.staticProducts
                              .length, // Number of items in the grid
                          itemBuilder: (context, index) {
                            return Product(StaticValues.staticProducts[index]);
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
