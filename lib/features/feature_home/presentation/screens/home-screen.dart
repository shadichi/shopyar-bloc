import 'package:flutter/material.dart';
import 'package:shapyar_bloc/core/params/middle_card_data.dart';
import 'package:shapyar_bloc/core/utils/static_values.dart';
import 'package:shapyar_bloc/features/feature_home/presentation/bloc/home_status.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shapyar_bloc/features/feature_home/presentation/widgets/middle-card.dart';
import 'package:shapyar_bloc/features/feature_orders/presentation/screens/orders_screen.dart';
import '../../../../core/colors/app-colors.dart';
import '../../../../core/config/app-colors.dart';
import '../../../../core/widgets/progress-bar.dart';
import '../widgets/chart.dart';
import '../bloc/home_bloc.dart';
import '../widgets/drawer.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:jdate/jdate.dart';
import 'package:fl_chart/fl_chart.dart';

import '../widgets/pie-chart.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = "/home_screen";
  final void Function(bool)? onDrawerStatusChange;

  const HomeScreen({Key? key, this.onDrawerStatusChange}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    BlocProvider.of<HomeBloc>(context).add(LoadDataEvent());
    BlocProvider.of<HomeBloc>(context).add(LoadHomeDataEvent());
  }

  var test = '';

  @override
  Widget build(BuildContext context) {
    print('HomeScreen');
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    final dteNow = Jalali.now();
    var jd = JDate(dteNow.year, dteNow.month, dteNow.day);
    return BlocBuilder<HomeBloc, HomeState>(builder: (context, state) {
      if (state.homeStatus is HomeLoading) {
        return Center(child: ProgressBar());
      }
      if (state.homeStatus is HomeLoadedStatus) {
        /*  final UserLoadedStatus userLoadedStatus =
            state.homeStatus as UserLoadedStatus;
        final UserDataParams homeUserDataParams =
            userLoadedStatus.homeUserDataParams;*/
        // context.read<HomeBloc>().add(LoadOrdersData(OrdersParams(10,"shop-yar.ir/wp-json/shop-yar","10",""), ));
        return Scaffold(
          backgroundColor: AppConfig.background,
          drawer: HomeDrawer(),
          appBar: AppBar(
            iconTheme: IconThemeData(color: Colors.white),
            backgroundColor: AppConfig.background,
            centerTitle: false,
            titleSpacing: 0.0,
            title: Transform(
              // you can forcefully translate values left side using Transform
              transform: Matrix4.translationValues(-200.0, 0.0, 0.0),
              child: Container(
                //  color: Colors.green,
                //  padding: EdgeInsets.only(left: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding: EdgeInsets.all(width * 0.03),
                      child: Text(
                        StaticValues.shopName,
                        textDirection: TextDirection.rtl,
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: width * 0.04),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 2),
                      //color: Colors.pink,
                      child: Text(
                        jd.echo('l، d F'),
                        textDirection: TextDirection.rtl,
                        style: TextStyle(
                            color: Colors.grey.shade300,
                            fontSize: width * 0.03,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          onDrawerChanged: (isOpened) {
            widget.onDrawerStatusChange!(isOpened);
          },
          body: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding:  EdgeInsets.all(width*0.03),
                child: Column(
                  spacing: height*0.03,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    HomeScreenPieChart(
                      items: [
                        StaticValues
                            .staticHomeDataEntity!.statusCounts!.wcCompleted,
                        StaticValues.staticHomeDataEntity!.statusCounts!.wcOnHold,
                        StaticValues
                            .staticHomeDataEntity!.statusCounts!.wcPending,
                        StaticValues
                            .staticHomeDataEntity!.statusCounts!.wcProcessing,
                        StaticValues
                            .staticHomeDataEntity!.statusCounts!.wcRefunded
                      ],
                    ),

                    MiddleCard(
                      middleCardData: MiddleCardData(
                          StaticValues.staticHomeDataEntity!.dailySales!.qty
                              .toString(),
                          StaticValues.staticHomeDataEntity!.monthlySales!.qty
                              .toString(),
                          StaticValues.staticHomeDataEntity!.dailyCancelled!.qty
                              .toString(),
                          StaticValues.staticHomeDataEntity!.monthlyCancelled!.qty
                              .toString()),
                    ),

                    Container(alignment: Alignment.centerRight,
                      child: Text(
                        "آمار سفارش هفته اخیر",
                        style: TextStyle(color: Colors.white,fontSize: width*0.03),
                      ),
                    ),
                    Container(
                      width: width,
                      height: height * 0.4,
                      decoration: BoxDecoration(
                          //color: AppColors.section4,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(width * 0.07),
                              topRight: Radius.circular(width * 0.07))),
                      child: Chart(),
                      /* child: Card(
                        child: Chart(),
                        elevation: 8,
                        color: Colors.white,
                      ),*/
                    ),
                    SizedBox(
                      height: height * 0.08,
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      } else if (state.homeStatus is HomeErrorStatus) {
        // context.read<HomeBloc>().add(LoadOrdersData(OrdersParams(10,"http://shop-yar.ir/wp-json/shop-yar","per_page=10","")));

        return Center(child: Text('خطا!'));
      } else if (state.homeStatus is HomeLoadedStatus) {
        /*final UserLoadedStatus userLoadedStatus =
            state.homeStatus as UserLoadedStatus;*/
        /* final UserLoadedStatus userLoadedStatus =
        state.homeStatus as UserLoadedStatus;
        final HomeUserDataParams homeUserDataParams =
            userLoadedStatus.homeUserDataParams;*/

        /*   final CwCompleted cwComplete = state.cwStatus as CwCompleted;
        BookMarkIcon(name: cwComplete.currentCityEntity.name!);
*/
        final HomeLoadedStatus ordersLoadedStatus =
            state.homeStatus as HomeLoadedStatus;

        /*     final OrdersLoadedStatus ordersLoadedStatus = state.homeStatus as OrdersLoadedStatus;
       final List<OrdersEntity>? ordersEntity =
            ordersLoadedStatus.orderDataState;
        ordersLoadedStatus.OrdersEntity..

        print("test");
        print(loginEntity![0]);*/
        /*final HomeUserDataParams homeUserDataParams =
            userLoadedStatus.homeUserDataParams;*/
        return Scaffold(
          // appBar: AppBar(title: Text(homeUserDataParams.userName)),
          // backgroundColor: Colors.red,
          body: SafeArea(
            child: Container(
              height: height,
              width: width,
              //color: Colors.green,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, OrdersScreen.routeName);
                    },
                    child: Container(
                      margin: EdgeInsets.only(top: height * 0.02),
                      alignment: Alignment.center,
                      height: height * 0.13,
                      width: width * 0.9,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Card(
                        elevation: 20,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      }
      /* final UserDataLoadedStatus userDataLoadedStatus =
          state.logInStatus as UserDataLoadedStatus;
      LoginEntity? loginEntity = userDataLoadedStatus.loginEntity;*/
      return Container(
        color: Colors.red,
      );
    });
  }
}
