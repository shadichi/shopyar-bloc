import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shapyar_bloc/core/utils/static_values.dart';
import 'package:shapyar_bloc/features/feature_orders/presentation/bloc/orders_bloc.dart';
import 'package:shapyar_bloc/features/feature_orders/presentation/widgets/order.dart';
import 'package:shapyar_bloc/core/colors/app-colors.dart';
import '../../../../core/config/app-colors.dart';
import '../../../../core/widgets/alert_dialog.dart';
import '../../../../core/widgets/progress-bar.dart';
import '../../../feature_add_edit_order/presentation/screens/product_form_screen.dart';
import '../../../feature_add_edit_order/presentation/screens/add_order.dart';
import '../bloc/orders_status.dart';
import 'package:anim_search_bar/anim_search_bar.dart';

class OrdersScreen extends StatefulWidget {
  static const routeName = "/orders_screen";

  const OrdersScreen({Key? key}) : super(key: key);

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen>  with AutomaticKeepAliveClientMixin{
  final _scrollController = ScrollController();
  @override bool get wantKeepAlive => true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    //context.read<OrdersBloc>().add(LoadOrdersData());
    BlocProvider.of<OrdersBloc>(context)
        .add(LoadOrdersData(false, '', false, '', ''));
  }

  TextEditingController textEditingController = TextEditingController();
  bool searchTemp = true;
  bool showFilter = false;
  String selectedStatus = '';
  String selectedCount = '10';
  bool isLoadBtn = false;

  int ordersCount = 10;

  @override
  Widget build(BuildContext context) {
    final isRTL = Directionality.of(context) == TextDirection.rtl;
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;



    return BlocConsumer<OrdersBloc, OrdersState>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state.ordersStatus is OrdersLoadingStatus) {
            return Center(child: ProgressBar());
          }
          if (state.ordersStatus is OrdersSearchFailedStatus) {
            StaticValues.staticOrders.clear();
            BlocProvider.of<OrdersBloc>(context)
                .add(LoadOrdersData(false, '', false, '', ''));
          }
          if (state.ordersStatus is UserErrorStatus) {
            return Center(child: Text("خطا!"));
          }
          if (state.ordersStatus is OrdersErrorStatus) {
            return Text("خطا در هنگام بارگیری سفارشات!");
          }if (state.ordersStatus is OrdersLoadingStatus && StaticValues.staticOrders.isEmpty) {
            return Center(child: ProgressBar());
          }


          if (state.ordersStatus is OrdersLoadedStatus) {

            final isInitialLoading = state.ordersStatus is OrdersLoadingStatus
                && StaticValues.staticOrders.isEmpty;

            isLoadBtn = true;
            print("this is");
            return Scaffold(
              backgroundColor: AppConfig.background,
              appBar: AppBar(
                title: Text(
                  'همه سفارشات',
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
                    style: TextStyle(fontSize: width * 0.035),
                    // کوچیک‌تر از قبل

                    textController: textEditingController,
                    onSuffixTap: () {
                      print('onSuffixTap');
                    },
                    onSubmitted: (String) {
                      if (String.isEmpty) {
                        searchTemp = false;
                        StaticValues.staticOrders.clear();
                      }
                      BlocProvider.of<OrdersBloc>(context).add(
                        LoadOrdersData(searchTemp, String, false, '', ''),
                      );
                    },
                  ),

                  IconButton(
                    icon: Icon(Icons.filter_alt_outlined, color: Colors.white),
                    onPressed: () {
                      print(StaticValues.status);
                      BlocProvider.of<OrdersBloc>(context)
                          .add(ShowFilter(showFilter));
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.add, color: Colors.white),
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>ProductFormScreen.create()));
                    },
                  ),

                ], // Remove shadow for a seamless look
              ),
              body: Stack(
                children: [
                  RefreshIndicator(
                    onRefresh: () async {
                      await Future.delayed(const Duration(seconds: 2));
                      context.read<OrdersBloc>().add(RefreshOrdersData());
                    },
                    child: StaticValues.staticOrders.isEmpty?Container(
                      color: AppConfig.background,
                      child: Center(child: Text('سفارشی وجود ندارد!',style: TextStyle(color: Colors.white, fontSize: AppConfig.calFontSize(context, 3)),)),
                    ):Container(
                      color: AppConfig.background,
                      child: ListView.builder(
                          controller: _scrollController,
                          itemCount: StaticValues.staticOrders.length + 1,
                          itemBuilder: (context, item) {
                            if (item == StaticValues.staticOrders.length) {
                              return _LoadMoreButton();
                            }
                            return Order(
                                ordersLoadedStatus:
                                StaticValues.staticOrders[item],
                                item: item);
                          }),
                    ),
                  ),
                  if (state.showFilter)
                    GestureDetector(
                      onTap: () {
                        BlocProvider.of<OrdersBloc>(context)
                            .add(ShowFilterOff(showFilter));
                      },
                      child: Container(
                        color: Colors.black.withOpacity(0.5),
                        // Darken the background
                        child: Center(
                          child: GestureDetector(
                            onTap: () {},
                            // Prevent closing when interacting with the filter
                            child: Container(
                              padding: EdgeInsets.all(width * 0.06),
                              decoration: BoxDecoration(
                                color: AppConfig.piChartSection3,
                                borderRadius:
                                    BorderRadius.circular(width * 0.03),
                              ),
                              width: width * 0.8,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text("اعمال فیلتر",
                                      style: TextStyle(
                                          fontSize: width * 0.05,
                                          fontWeight: FontWeight.bold)),
                                  SizedBox(height: height * 0.06),
                                  DropdownButtonFormField(
                                    items: StaticValues.status.entries
                                        .map((entry) {
                                      return DropdownMenuItem(
                                          value: entry.key,
                                          child: Text(entry.value));
                                    }).toList(),
                                    onChanged: (value) {
                                      selectedStatus = value!;
                                    },
                                    decoration: InputDecoration(
                                        labelText: "وضعیت سفارش"),
                                  ),
                                  SizedBox(height: height * 0.06),
                                  DropdownButtonFormField(
                                    items:
                                        ["5", "10", "20", "50"].map((status) {
                                      return DropdownMenuItem(
                                          value: status, child: Text(status));
                                    }).toList(),
                                    onChanged: (value) {
                                      selectedCount = value!;
                                    },
                                    decoration: InputDecoration(
                                        labelText: "تعداد سفارش"),
                                  ),
                                  SizedBox(height: height * 0.06),
                                  Container(
                                    width: width * 0.87,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Container(
                                            alignment: Alignment.center,
                                            child: Text(
                                              "پاک کردن فیلتر",
                                              style: TextStyle(
                                                  fontSize: width * 0.027),
                                            )),
                                        SizedBox(
                                          width: width * 0.3,
                                          height: height * 0.06,
                                          child: ElevatedButton(
                                            onPressed: () {
                                              BlocProvider.of<OrdersBloc>(
                                                      context)
                                                  .add(LoadOrdersData(
                                                      false,
                                                      '',
                                                      true,
                                                      selectedCount.toString(),
                                                      selectedStatus
                                                          .substring(3)
                                                          .toString()));
                                              BlocProvider.of<OrdersBloc>(
                                                      context)
                                                  .add(ShowFilterOff(
                                                      showFilter));
                                              selectedStatus = '';
                                              selectedCount = '10';
                                            },
                                            style: ElevatedButton.styleFrom(
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            width * 0.03)),
                                                backgroundColor:
                                                    AppConfig.secondaryColor),
                                            child: Text(
                                              "اعمال تغییرات",
                                              style: TextStyle(
                                                  fontSize: width * 0.027,
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            );
          }
          return Container();
        });
  }
}
class _LoadMoreButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final state = context.watch<OrdersBloc>().state;
    final isLoadingMore = state.isLoadingMore == true;

    return Container(
      padding: EdgeInsets.only(
        bottom: AppConfig.calWidth(context, 24),
        right: AppConfig.calWidth(context, 10),
        left: AppConfig.calWidth(context, 10),
      ),
      height: AppConfig.calHeight(context, 20),
      child: ElevatedButton(
        onPressed: isLoadingMore
            ? null
            : () {
          final currentCount = StaticValues.staticOrders.length;
          context.read<OrdersBloc>().add(
            LoadOrdersData(
              false,
              '',
              false,
              (currentCount + 10).toString(),
              '',
              isLoadMore: true,
            ),
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
            ? SizedBox(child: ProgressBar(size: 3,))
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

