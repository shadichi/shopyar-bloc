import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shapyar_bloc/core/utils/static_values.dart';
import 'package:shapyar_bloc/features/feature_orders/presentation/bloc/orders_bloc.dart';
import 'package:shapyar_bloc/features/feature_orders/presentation/widgets/order.dart';
import '../../../../core/config/app-colors.dart';
import '../../../../core/widgets/progress-bar.dart';
import '../../../feature_add_edit_order/presentation/screens/product_form_screen.dart';
import '../bloc/orders_status.dart';
import 'package:anim_search_bar/anim_search_bar.dart';

class OrdersScreen extends StatefulWidget {
  static const routeName = "/orders_screen";

  const OrdersScreen({Key? key}) : super(key: key);

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen>
    with AutomaticKeepAliveClientMixin {
  final _scrollController = ScrollController();

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    //context.read<OrdersBloc>().add(LoadOrdersData());
    BlocProvider.of<OrdersBloc>(context)
        .add(LoadOrdersData(false, '', false, '', ''));
  }

  Future<void> _onRefresh() {
    final c = Completer<void>();
    context
        .read<OrdersBloc>()
        .add(RefreshOrdersData(c));
    return c.future;
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
    super.build(context);
    final isRTL = Directionality.of(context) == TextDirection.rtl;
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return BlocConsumer<OrdersBloc, OrdersState>(
        listener: (context, state) {
          if (state.ordersStatus is OrdersSearchFailedStatus) {
            StaticValues.staticOrders.clear();
            BlocProvider.of<OrdersBloc>(context)
                .add(LoadOrdersData(false, '', false, '', ''));
          }
        },
        builder: (context, state) {
          if (state.ordersStatus is OrdersLoadingStatus) {
            return Center(child: ProgressBar());
          }

          if (state.ordersStatus is UserErrorStatus) {
            return Center(child: Text("خطا!"));
          }
          if (state.ordersStatus is OrdersErrorStatus) {
            return Text("خطا در هنگام بارگیری سفارشات!");
          }
          if (state.ordersStatus is OrdersLoadingStatus &&
              StaticValues.staticOrders.isEmpty) {
            return Center(child: ProgressBar());
          }

          if (state.ordersStatus is OrdersLoadedStatus) {
            final isInitialLoading =
                state.ordersStatus is OrdersLoadingStatus &&
                    StaticValues.staticOrders.isEmpty;

            isLoadBtn = true;
            return Scaffold(
              appBar: AppBar(
                centerTitle: false,
                automaticallyImplyLeading: false,
                titleSpacing: 0,
                title: Align(
                  alignment: Alignment.centerRight, // stick to right
                  child: Container(
                    padding:
                        EdgeInsets.only(right: AppConfig.calWidth(context, 7)),
                    width: AppConfig.calWidth(context, 62),
                    height: AppConfig.calWidth(context, 9),
                    child: SearchBar(
                      backgroundColor:
                          MaterialStateProperty.all(AppConfig.secondaryColor),
                      leading: Icon(Icons.search,
                          size: AppConfig.calWidth(context, 5)),
                      hintText: 'جستجو',
                      textStyle: MaterialStateProperty.all(
                        TextStyle(
                            color: Colors.white,
                            fontSize: AppConfig.calFontSize(context, 3)),
                      ),
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              AppConfig.calBorderRadiusSize(context)))),
                      hintStyle: MaterialStateProperty.all(
                        TextStyle(
                            fontSize: AppConfig.calFontSize(context, 3),
                            color: Colors.white60),
                      ),
                      onSubmitted: (query) {
                        if (query.isEmpty) {
                          searchTemp = false;
                          StaticValues.staticOrders.clear();
                        }
                        context.read<OrdersBloc>().add(
                            LoadOrdersData(searchTemp, query, false, '', ''));
                      },
                    ),
                  ),
                ),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.filter_alt_outlined,
                        color: Colors.white),
                    onPressed: () =>
                        context.read<OrdersBloc>().add(ShowFilter(showFilter)),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add, color: Colors.white),
                    onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => ProductFormScreen.create())),
                  ),
                  // const SizedBox(width: 8),
                ],
              ),
              body: Stack(
                children: [
                  RefreshIndicator(
                    onRefresh: _onRefresh,
                    child: StaticValues.staticOrders.isEmpty
                        ? ListView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            children: [
                              Container(alignment: Alignment.center,height: AppConfig.calHeight(context, 90),
                                child: Center(
                                    child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  spacing: AppConfig.calWidth(context, 4),
                                  children: [
                                    Text(
                                      'سفارشی یافت نشد!',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: AppConfig.calFontSize(
                                              context, 3)),
                                    ),
                                    IconButton(
                                        onPressed: () {
                                          BlocProvider.of<OrdersBloc>(context)
                                              .add(LoadOrdersData(
                                                  false, '', false, '', ''));
                                        },
                                        icon: Icon(
                                          Icons.refresh,
                                          color: Colors.white,
                                          size: AppConfig.calWidth(context, 6),
                                        ))
                                  ],
                                )),
                              ),
                            ],
                          )
                        : ListView.builder(
                        physics: const AlwaysScrollableScrollPhysics(),
                            controller: _scrollController,
                            itemCount: StaticValues.staticOrders.length + 1,
                            itemBuilder: (context, item) {
                              if (item ==
                                  StaticValues.staticOrders.length) {
                                return _LoadMoreButton();
                              }
                              return Order(
                                  ordersLoadedStatus:
                                      StaticValues.staticOrders[item],
                                  item: item);
                            }),
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
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.circular(width * 0.03),
                              ),
                              width: width * 0.8,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text("اعمال فیلتر",
                                      style: TextStyle(
                                          fontSize:
                                              AppConfig.calFontSize(context, 4),
                                          fontWeight: FontWeight.bold)),
                                  SizedBox(height: height * 0.06),
                                  DropdownButtonFormField(
                                    dropdownColor: Colors.white,
                                    items: StaticValues.status.entries
                                        .map((entry) {
                                      return DropdownMenuItem(
                                          value: entry.key,
                                          child: Text(entry.value,
                                              style: TextStyle(
                                                  fontSize:
                                                      AppConfig.calFontSize(
                                                          context, 3))));
                                    }).toList(),
                                    onChanged: (value) {
                                      selectedStatus = value!;
                                    },
                                    decoration: InputDecoration(
                                        labelText: "وضعیت سفارش",
                                        labelStyle: TextStyle(
                                            fontSize: AppConfig.calFontSize(
                                                context, 3.2))),
                                  ),
                                  SizedBox(height: height * 0.06),
                                  DropdownButtonFormField(
                                    dropdownColor: Colors.white,
                                    items:
                                        ["5", "10", "20", "50"].map((status) {
                                      return DropdownMenuItem(
                                          value: status,
                                          child: Text(
                                            status,
                                            style: TextStyle(
                                                fontSize: AppConfig.calFontSize(
                                                    context, 3)),
                                          ));
                                    }).toList(),
                                    onChanged: (value) {
                                      selectedCount = value!;
                                    },
                                    decoration: InputDecoration(
                                        labelText: "تعداد سفارش",
                                        labelStyle: TextStyle(
                                            fontSize: AppConfig.calFontSize(
                                                context, 3.2))),
                                  ),
                                  SizedBox(height: height * 0.06),
                                  SizedBox(
                                    width: width * 0.87,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            BlocProvider.of<OrdersBloc>(context)
                                                .add(LoadOrdersData(
                                                    false, '', true, '', ''));
                                            BlocProvider.of<OrdersBloc>(context)
                                                .add(ShowFilterOff(showFilter));
                                            selectedStatus = '';
                                            selectedCount = '10';
                                          },
                                          child: Container(
                                              alignment: Alignment.center,
                                              height: AppConfig.calHeight(
                                                  context, 05),
                                              child: Text(
                                                "پاک کردن فیلتر",
                                                style: TextStyle(
                                                    fontSize:
                                                        AppConfig.calFontSize(
                                                            context, 2.8)),
                                              )),
                                        ),
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
                                                  fontSize:
                                                      AppConfig.calFontSize(
                                                          context, 2.8),
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
