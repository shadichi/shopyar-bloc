import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shapyar_bloc/core/utils/static_values.dart';
import 'package:shapyar_bloc/features/feature_orders/presentation/bloc/orders_bloc.dart';
import 'package:shapyar_bloc/features/feature_orders/presentation/widgets/order.dart';
import 'package:shapyar_bloc/core/colors/test3.dart';
import '../../../../core/widgets/alert_dialog.dart';
import '../../../feature_add_edit_order/presentation/screens/add_order.dart';
import '../bloc/orders_status.dart';
import 'package:anim_search_bar/anim_search_bar.dart';

class OrdersScreen extends StatefulWidget {
  static const routeName = "/orders_screen";

  const OrdersScreen({Key? key}) : super(key: key);

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
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

  @override
  Widget build(BuildContext context) {
    final isRTL = Directionality.of(context) == TextDirection.rtl;
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return BlocConsumer<OrdersBloc, OrdersState>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state.ordersStatus is OrdersLoadingStatus) {
            return Center(child: CircularProgressIndicator());
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
          }
          if (state.ordersStatus is OrdersLoadedStatus) {
            print("this is");
            return Scaffold(
              /*  floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.pushNamed(context,AddOrder.routeName);
            },
            backgroundColor: Color(0xff0A369D),
            child: Text(
              '+',
              style: TextStyle(color: Colors.white, fontSize: width * 0.08),
            ),
          ),*/
              // appBar: AppBar(title: Text(homeUserDataParams.userName)),
               backgroundColor: AppColors.background,
              appBar: AppBar(
                title: Text(
                  'همه سفارشات',
                  style: TextStyle(fontSize: height * 0.03, color: Colors.white),
                ),
                backgroundColor: AppColors.background,
                // Match app bar color with background
                elevation: 0.0,
                actions: [
                  AnimSearchBar(color: AppColors.background,searchIconColor: Colors.white,
                    width: width * 0.7,
                    helpText: 'جستجو',
                    style: TextStyle(fontSize: width * 0.04),
                    textController: textEditingController,
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
                      BlocProvider.of<OrdersBloc>(context).add(
                          LoadOrdersData(searchTemp, String, false, '', ''));
                    },
                  ),
                  /* IconButton(
                icon: Icon(Icons.search),
                onPressed: () {
                  AnimSearchBar
                },
              ),*/
                  IconButton(
                    icon: Icon(Icons.filter_alt_outlined, color: Colors.white),
                    onPressed: () {
                      print(StaticValues.status);
                      BlocProvider.of<OrdersBloc>(context)
                          .add(ShowFilter(showFilter));
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.add,color: Colors.white),
                    onPressed: () {
                      Navigator.pushNamed(context, AddOrder.routeName);
                    },
                  ),
                  /*  IconButton(
                icon: Icon(isRTL ? Icons.arrow_forward : Icons.arrow_back,),
                onPressed: () {
                  Navigator.pushNamed(context,HomeScreen.routeName);
                }, //productsLoadedStatus.productsDataState![0].name.toString()
              ),*/
                ], // Remove shadow for a seamless look
              ),
              body: Stack(
                children: [
                  SafeArea(
                    child: RefreshIndicator(
                      onRefresh: () async {
                        await Future.delayed(const Duration(seconds: 2));
                        context.read<OrdersBloc>().add(RefreshOrdersData());
                      },
                      child: ListView.builder(
                          itemCount: StaticValues.staticOrders.length,
                          itemBuilder: (context, item) {
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
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.circular(width * 0.06),
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
                                        ElevatedButton(
                                          onPressed: () {
                                            print(selectedCount);
                                            print(selectedStatus);
                                            BlocProvider.of<OrdersBloc>(context)
                                                .add(LoadOrdersData(
                                                    false, '', false, '', ''));
                                            BlocProvider.of<OrdersBloc>(context)
                                                .add(ShowFilterOff(showFilter));
                                            selectedStatus = '';
                                            selectedCount = '10';
                                            StaticValues.staticOrders.clear();
                                          },
                                          child: Text("پاک کردن فیلتر"),
                                        ),
                                        ElevatedButton(
                                          onPressed: () {
                                            print(selectedCount);
                                            print(selectedStatus.substring(3));
                                            BlocProvider.of<OrdersBloc>(context)
                                                .add(LoadOrdersData(
                                                    false,
                                                    '',
                                                    true,
                                                    selectedCount.toString(),
                                                    selectedStatus.substring(3).toString()));
                                            BlocProvider.of<OrdersBloc>(context)
                                                .add(ShowFilterOff(showFilter));
                                            selectedStatus = '';
                                            selectedCount = '10';
                                          },
                                          child: Text("اعمال تغییرات"),
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
