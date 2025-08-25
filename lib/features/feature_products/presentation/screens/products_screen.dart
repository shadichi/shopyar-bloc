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

class ProductsScreen extends StatefulWidget {
  static const routeName = "/products_screen";

  ProductsScreen({Key? key}) : super(key: key);

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen>
    with AutomaticKeepAliveClientMixin {
  TextEditingController searchProduct = TextEditingController();

  bool searchTemp = true;

  bool _suppressNextSubmit = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    BlocProvider.of<ProductsBloc>(context)
        .add(LoadProductsData(ProductsParams('10', false, '', false)));
  }

  @override
  Widget build(BuildContext context) {
    final isRTL = Directionality.of(context) == TextDirection.rtl;
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return BlocConsumer<ProductsBloc, ProductsState>(
        listener: (context, state) {
      if (state.productsStatus is ProductsSearchFailedStatus) {
        alertDialogScreen(context, 'هیچ محصولی یافت نشد!', 1, false);
      }
    }, builder: (context, state) {
      if (state.productsStatus is ProductsLoadingStatus) {
        print("OrdersLoadingStatus");
        /* context
            .read<ProductsBloc>()
            .add(LoadProductsData(ProductsParams('10', false, '')));
*/
        return Center(child: ProgressBar());
      }
      if (state.productsStatus is UserErrorStatus) {
        return Text("خطا در بارگذاری اطلاعات یوزر!");
      }

      if (state.productsStatus is ProductsErrorStatus) {
        return Text("خطا هنگام بارگذاری محصولات!");
      }

      if (state.productsStatus is ProductsLoadedStatus) {
        final ProductsLoadedStatus productsLoadedStatus =
            state.productsStatus as ProductsLoadedStatus;

        return Scaffold(
            appBar: AppBar(
              centerTitle: false,
              automaticallyImplyLeading: false,
              titleSpacing: 0,
              title: Align(
                alignment: Alignment.centerRight,
                child:  Container(
                  width: AppConfig.calWidth(context, 94),
                  height:  AppConfig.calWidth(context, 9),
                  padding: EdgeInsets.only(right: AppConfig.calWidth(context, 7)),
                  child: SearchBar(
                    backgroundColor:
                    WidgetStateProperty.all(AppConfig.secondaryColor),
                    leading: Icon(
                      Icons.search,
                      size: AppConfig.calWidth(context, 5),
                    ),
                    hintText: 'جستجو',textStyle: WidgetStateProperty.all(TextStyle(color: Colors.white,fontSize: AppConfig.calFontSize(context, 3))),
                    hintStyle: WidgetStateProperty.all(
                        TextStyle(fontSize:  AppConfig.calFontSize(context, 3), color: Colors.white60)),
                    onSubmitted: (query) {
                      if (_suppressNextSubmit) {
                        _suppressNextSubmit = false;
                        return;
                      }
                      if (query.trim().isEmpty) return;

                      context.read<ProductsBloc>().add(
                        LoadProductsData(
                            ProductsParams('10', true, query, false)),
                      );

                      _suppressNextSubmit = true;
                      searchProduct.clear();
                    },

                  ),
                ),
              ),
            ),
            body: Center(
              child: StaticValues.staticProducts.isEmpty
                  ? Container(
                      color: AppConfig.background,
                      child: Center(
                          child: Column(crossAxisAlignment: CrossAxisAlignment.center,mainAxisAlignment: MainAxisAlignment.center,spacing: AppConfig.calWidth(
                              context, 4),
                            children: [
                              Text('محصولی یافت نشد!',
                                                      style: TextStyle(
                                color: Colors.white,
                                fontSize: AppConfig.calFontSize(context, 3)),
                                                    ),
                              IconButton(onPressed: (){
                                BlocProvider.of<ProductsBloc>(context)
                                    .add(LoadProductsData(ProductsParams('10', false, '', false)));
                              }, icon:   Icon(Icons.refresh,color: Colors.white,size: AppConfig.calWidth(context, 6),))

                            ],
                          )),
                    )
                  : SizedBox(
                      // color: Colors.red,
                      height: height,
                      //  width: width * 0.87,
                      child: ListView.builder(
                        // padding: EdgeInsets.all(10),
                        itemCount: StaticValues.staticProducts.length + 1,
                        // Number of items in the grid
                        itemBuilder: (context, index) {
                          if (index == StaticValues.staticProducts.length) {
                            //,child: _LoadMoreButton()
                            return Container(
                                height: AppConfig.calHeight(context, 21),
                                child: _LoadMoreButton());
                          }
                          return Product(StaticValues.staticProducts[index]);
                        },
                      ),
                    ),
            ));
      }
      return Container();
    });
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

class _LoadMoreButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final state = context.watch<ProductsBloc>().state;
    final isLoadingMore = state.isLoadingMore == true;

    return Container(
      padding: EdgeInsets.only(
        bottom: AppConfig.calWidth(context, 24),
        right: AppConfig.calWidth(context, 3),
        left: AppConfig.calWidth(context, 3),
      ),
      margin: EdgeInsets.only(
        top: AppConfig.calWidth(context, 1.2),
      ),
      height: AppConfig.calHeight(context, 10),
      child: ElevatedButton(
        onPressed: isLoadingMore
            ? () {
                print('fgggggggggggggggggggg');
              }
            : () {
                print('fgggggg');
                final currentCount = StaticValues.staticProducts.length;
                print(currentCount);
                context.read<ProductsBloc>().add(
                      LoadProductsData(ProductsParams(
                          (currentCount + 10).toString(), false, '', true)),
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
