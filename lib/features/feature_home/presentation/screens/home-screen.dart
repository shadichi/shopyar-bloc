import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shopyar/core/utils/static_values.dart';
import 'package:shopyar/features/feature_home/presentation/bloc/home_status.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopyar/features/feature_home/presentation/widgets/middle-card.dart';
import 'package:shopyar/features/feature_orders/presentation/screens/orders_screen.dart';
import '../../../../core/config/app-colors.dart';
import '../../../../core/widgets/alert_dialog.dart';
import '../../../../core/widgets/progress-bar.dart';
import '../../../../core/widgets/snackBar.dart';
import '../../../feature_log_in/presentation/screens/log_in_screen.dart';
import '../../../feature_orders/data/models/store_info.dart';
import '../widgets/chart.dart';
import '../bloc/home_bloc.dart';
import '../widgets/drawer.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:jdate/jdate.dart';
import 'package:intl/intl.dart';
import 'package:shopyar/extension/persian_digits.dart';
import 'package:hive/hive.dart';
import '../widgets/pie-chart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = "/home_screen";
  final void Function(bool)? onDrawerStatusChange;
  final VoidCallback? onReady;


  const HomeScreen({Key? key, this.onDrawerStatusChange,this.onReady,}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
   // _startPollingReady();
    BlocProvider.of<HomeBloc>(context).add(LoadDataEvent());
  }

  Timer? _pollTimer;


  void _startPollingReady() {
    _pollTimer = Timer.periodic(const Duration(milliseconds: 250), (t) {
      if (StaticValues.webService.isNotEmpty) {
        widget.onReady?.call();
        t.cancel();
      }
    });
  }
  @override
  void dispose() {
    _pollTimer?.cancel();
    super.dispose();
  }



  Future<void> _onRefresh() {
    final c = Completer<void>();
    context.read<HomeBloc>().add(RefreshHomeData(c));
    return c.future;
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    final dteNow = Jalali.now();
    var jd = JDate(dteNow.year, dteNow.month, dteNow.day);

    return BlocConsumer<HomeBloc, HomeState>(
        listener: (context, state) {
      if (state.homeStatus is HomeAccountExitStatus) {
        Navigator.pushReplacementNamed(context, LogInScreen.routeName);
      }
      if (state.homeStatus is HomeLoadedStatus) {
        widget.onReady?.call();
        if(StaticValues.versionNo!="1.0.3"){
          alertDialogScreen(context, "لطفاً بروزرسانی جدید برنامه را از راست چین نصب کنید!",0,true);

        }
      }
    }, builder: (context, state) {
      if (state.homeStatus is HomeLoading) {
        return Center(child: ProgressBar());
      }
      if (state.homeStatus is HomeLoadedStatus) {

        return Scaffold(
          drawer: HomeDrawer(),
          appBar: AppBar(
            titleSpacing: 0.0,
            actions: [
              Container(
                //color: Colors.yellow,
                alignment: Alignment.center,
                width: AppConfig.calWidth(context, 40),

                // margin: EdgeInsets.only(top: AppConfig.calWidth(context, 5)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Container(
                        height: AppConfig.calHeight(context, 4),
                        alignment: Alignment.center,
                        //  padding: EdgeInsets.all(width * 0.03),
                        child: Text(
                          StaticValues.shopName,
                          maxLines: 1,
                          style: TextStyle(
                              overflow: TextOverflow.ellipsis,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: AppConfig.calWidth(context, 4.3)),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        alignment: Alignment.center,
                        height: AppConfig.calHeight(context, 3),
                        child: Text(
                          jd.echo('l، d F').stringToPersianDigits(),
                          //  textDirection: ,
                          style: TextStyle(
                              color: Colors.grey.shade400,
                              fontSize: AppConfig.calWidth(context, 3.8),
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          onDrawerChanged: (isOpened) {
            widget.onDrawerStatusChange!(isOpened);
          },
          body: Center(
            child: RefreshIndicator(
              onRefresh: () => _onRefresh(),
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(width * 0.03),
                  child: Column(
                    spacing: height * 0.02,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      StaticValues
                                      .staticHomeDataEntity!.statusCounts!.wcCompleted ==
                                  0 &&
                              StaticValues.staticHomeDataEntity!.statusCounts!
                                      .wcOnHold ==
                                  0 &&
                              StaticValues.staticHomeDataEntity!.statusCounts!
                                      .wcPending ==
                                  0 &&
                              StaticValues.staticHomeDataEntity!.statusCounts!
                                      .wcProcessing ==
                                  0 &&
                              StaticValues.staticHomeDataEntity!.statusCounts!
                                      .wcCancelled ==
                                  0
                          ? Center(
                              child: Container(
                                height: AppConfig.calHeight(context, 30),
                                alignment: Alignment.center,
                                child: Text(
                                  'هیچ داده‌ای برای نمایش چارت وجود ندارد!',
                                  style: TextStyle(
                                      fontSize:
                                          AppConfig.calFontSize(context, 3),
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                              ),
                            )
                          : Padding(
                              padding: EdgeInsets.only(
                                  top: AppConfig.calHeight(context, 5),
                                  bottom: AppConfig.calHeight(context, 1.2)),
                              child: HomeScreenPieChart(
                                items: [
                                  StaticValues.staticHomeDataEntity!
                                      .statusCounts!.wcCompleted,
                                  StaticValues.staticHomeDataEntity!
                                      .statusCounts!.wcOnHold,
                                  StaticValues.staticHomeDataEntity!
                                      .statusCounts!.wcPending,
                                  StaticValues.staticHomeDataEntity!
                                      .statusCounts!.wcProcessing,
                                  StaticValues.staticHomeDataEntity!
                                      .statusCounts!.wcCancelled
                                ],
                              ),
                            ),
                      SizedBox(
                        height: AppConfig.calHeight(context, 2.5),
                      ),
                      MiddleCard(
                        statusCounts: StaticValues.staticHomeDataEntity,
                      ),
                      Container(
                        padding: EdgeInsets.only(
                            right: AppConfig.calWidth(context, 2)),
                        alignment: Alignment.centerRight,
                        child: Text(
                          "تعداد سفارشات هفته اخیر",
                          style: TextStyle(
                              color: Colors.white, fontSize: width * 0.04),
                        ),
                      ),
                      Container(
                        width: width,
                        height: height * 0.3,
                        margin: EdgeInsets.only(
                            right: AppConfig.calWidth(context, 6)),
                        decoration: BoxDecoration(
                            //    color: Colors.red,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(width * 0.07),
                                topRight: Radius.circular(width * 0.07))),
                        child: Chart(StaticValues.staticHomeDataEntity),
                      ),
                      SizedBox(
                        height: height * 0.1,
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      } else if (state.homeStatus is HomeErrorStatus) {
        return Center(
            child: Text(
          'خطا در بارگیری اطلاعات صفحه اصلی!',
          style: TextStyle(
              color: Colors.white, fontSize: AppConfig.calFontSize(context, 4)),
        ));
      } else if (state.homeStatus is HomeLoadedStatus) {
        final HomeLoadedStatus ordersLoadedStatus =
            state.homeStatus as HomeLoadedStatus;
        return Scaffold(
          body: SizedBox(
            height: height,
            width: width,
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
        );
      }
      return Container(
        color: AppConfig.backgroundColor,
        child: Text('خطا در بارگیری اطلاعات!'),
      );
    });
  }
}
