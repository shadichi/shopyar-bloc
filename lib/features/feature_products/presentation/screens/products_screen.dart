import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:shapyar_bloc/core/params/products_params.dart';
import 'package:shapyar_bloc/features/feature_products/presentation/bloc/products_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shapyar_bloc/features/feature_products/presentation/widgets/product.dart';
import 'package:shapyar_bloc/core/colors/app-colors.dart';
import '../../../../core/config/app-colors.dart';
import '../../../../core/utils/static_values.dart';
import '../../../../core/widgets/alert_dialog.dart';
import '../../../../core/widgets/progress-bar.dart';
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
          BlocConsumer<ProductsBloc, ProductsState>(listener: (context, state) {
            print('context.watch<ProductsBloc>().state');
            print(context.watch<ProductsBloc>().state);
        if (state.productsStatus is ProductsSearchFailedStatus) {
          alertDialogScreen(context, 'هیچ محصولی یافت نشد!', 1, false);
        }

      }, builder: (context, state) {
        if (state.productsStatus is ProductsLoadingStatus) {
          print("OrdersLoadingStatus");
          context
              .read<ProductsBloc>()
              .add(LoadProductsData(ProductsParams('10', false, '')));

          return Center(child: ProgressBar());
        }
        if (state.productsStatus is UserErrorStatus) {
          return Text("خطا در بارگذاری اطلاعات یوزر!");
        }
        if (state.productsStatus is pUserLoadedStatus) {
          context
              .read<ProductsBloc>()
              .add(LoadProductsData(ProductsParams('10', false, '')));
        }
        if (state.productsStatus is ProductsErrorStatus) {
          return Text("خطا هنگام بارگذاری محصولات!");
        }

        if (state.productsStatus is ProductsLoadedStatus) {
          final ProductsLoadedStatus productsLoadedStatus =
              state.productsStatus as ProductsLoadedStatus;

          return Scaffold(
              backgroundColor: AppConfig.background,
              appBar: AppBar(
                title: Text(
                  'همه محصولات',
                  style: TextStyle(
                      fontSize: AppConfig.calTitleFontSize(context),
                      color: Colors.white),
                ),
                backgroundColor: AppConfig.background,
                // Match app bar color with background
                elevation: 0.0,
                actions: [
                  AnimSearchBar(
                    color: AppConfig.background,
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
                              ProductsParams('10', true, searchProduct.text)));
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
                        height: height,
                        width: width * 0.87,
                        child: ListView.builder(
                          // padding: EdgeInsets.all(10),
                          itemCount: StaticValues.staticProducts.length + 1,
                          // Number of items in the grid
                          itemBuilder: (context, index) {
                            if (index == StaticValues.staticProducts.length) {
                              return Container(child: _LoadMoreButton(),);
                            }
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

class _LoadMoreButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final state = context.watch<ProductsBloc>().state;
    final isLoadingMore = state.isLoadingMore == true;

    return Container(
      padding: EdgeInsets.only(
        bottom: AppConfig.calWidth(context, 30),
        right: AppConfig.calWidth(context, 8),
        left: AppConfig.calWidth(context, 8),
      ),
      height: AppConfig.calHeight(context, 23),
      child: ElevatedButton(
        onPressed: isLoadingMore
            ? (){print('fgggggggggggggggggggg');}
            : () {
          print('fgggggg');
                final currentCount = StaticValues.staticProducts.length;
                context.read<ProductsBloc>().add(
                      LoadProductsData(ProductsParams(
                          (currentCount + 10).toString(), false, '')),
                    );
              },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppConfig.secondaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(width: 0.3, color: Colors.grey[300]!),
          ),
        ),
        child: isLoadingMore
            ? SizedBox(
                child: ProgressBar(
                size: 3,
              ))
            : Text(
                "بارگیری بیشتر",
                style: TextStyle(
                  fontSize: AppConfig.calFontSize(context, 3.2),
                  color: Colors.white,
                ),
              ),
      ),
    );
  }
}
