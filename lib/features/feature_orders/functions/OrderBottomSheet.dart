import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shapyar_bloc/core/config/app-colors.dart';
import 'package:shapyar_bloc/core/utils/static_values.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shapyar_bloc/core/widgets/alert_dialog.dart';
import 'package:shapyar_bloc/features/feature_orders/presentation/screens/orders_screen.dart';

import '../../../core/params/orders_edit_status.dart';
import '../../../core/widgets/progress-bar.dart';
import '../presentation/bloc/orders_bloc.dart';
import '../presentation/bloc/orders_status.dart';

void showFilterBottomSheet(BuildContext context,
    Function(String) onStatusSelected, ordersId, String selectedStatus) {
  var height = MediaQuery.of(context).size.height;
  var width = MediaQuery.of(context).size.width;

  showModalBottomSheet(
    context: context,
    backgroundColor: AppConfig.backgroundColor,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (context) {
      return BlocConsumer<OrdersBloc, OrdersState>(
        listener: (context, state) async {

          if (state.editStatus is EditOrderSuccessStatus) {

            await  alertDialogScreen(context, 'سفارش تغییر وضعیت داده شد!', 2, true);
            Navigator.pushNamed(context, OrdersScreen.routeName);
          }
        },
        builder: (context, state) {

          print('showFilterBottomSheet');
          print(state.editStatus);
          print(StaticValues.status);
          if (state.editStatus is EditOrderLoadingStatus) {
            return Container(
              color: Colors.black.withOpacity(0.5),
              child: Center(
                child: ProgressBar(
                ),
              ),
            );
          }
          if (state.editStatus is EditOrderFailedStatus) {
            print('Failed');

          }
          if ( state.editStatus is OrdersLoadedStatus || state.editStatus is EditOrderInitialStatus) {
            return Padding(padding: EdgeInsets.all(AppConfig.calHeight(context, 0.8)),
              child: SingleChildScrollView(
                child: Column(

                  mainAxisSize: MainAxisSize.min, // Adjust height dynamically
                  children: [
                    Container(alignment: Alignment.center,
                      height: AppConfig.calHeight(context, 5),
                      //  padding: EdgeInsets.all(AppConfig.calHeight(context, 1)),
                      child: Text(
                        "جهت تغییر وضعیت سفارش انتخاب کنید:",
                        style: TextStyle(
                            fontSize: AppConfig.calFontSize(context, 3.2),color: Colors.white),
                      ),
                    ),
                    SizedBox(height: AppConfig.calHeight(context, 2),),
                    SizedBox(
                      height: AppConfig.calHeight(context, 90),
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: StaticValues.status.length+1,
                        itemBuilder: (context, index) {
                          String trueValue = '';
                          String trueKey = '';
                          if(index != StaticValues.status.length){
                            final key = StaticValues.status.keys.elementAt(index)??'';
                            final value = StaticValues.status[key]??'';
                            trueValue = value;
                            trueKey = key;
                          }
                          if(index == StaticValues.status.length){
                            return Container(height: AppConfig.calHeight(context, 40));
                          }else{
                            return Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(AppConfig.calWidth(context, 0.08))), color: AppConfig.backgroundColor,
                              ),
                              padding: EdgeInsets.symmetric(vertical: width * 0.02),
                              alignment: Alignment.center,

                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(AppConfig.calWidth(context, 3))),   color:  AppConfig.secondaryColor,
                                ),

                                height: height * 0.07,
                                width: width * 0.7,
                                alignment: Alignment.center,
                                child: ListTile(
                                  dense: true,
                                  contentPadding: EdgeInsets.zero,
                                  minVerticalPadding: 0,
                                  horizontalTitleGap: 0,
                                  title: Center(
                                    child: Text(
                                      trueValue,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(color: Colors.white, fontSize: AppConfig.calFontSize(context, 2.8)),
                                    ),
                                  ),
                                  onTap: () {
                                    BlocProvider.of<OrdersBloc>(context).add(
                                      EditStatus(OrdersEditStatus(ordersId, trueKey.substring(3))),
                                    );
                                  },
                                )
                                ,
                              ),
                            );
                          }
                        },

                      ),
                    ),
                    SizedBox(height: AppConfig.calHeight(context, 2),),
                  ],
                ),
              ),
            );
          }
          return Container();
        },
      );
    },
  );
}
