import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shapyar_bloc/core/utils/static_values.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shapyar_bloc/core/widgets/alert_dialog.dart';

import '../../../core/params/orders_edit_status.dart';
import '../presentation/bloc/orders_bloc.dart';
import '../presentation/bloc/orders_status.dart';

void showFilterBottomSheet(BuildContext context,
    Function(String) onStatusSelected, ordersId, String selectedStatus) {
  var height = MediaQuery.of(context).size.height;
  var width = MediaQuery.of(context).size.width;

  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (context) {
      return BlocConsumer<OrdersBloc, OrdersState>(
        listener: (context, state) async {

          if (state.editStatus is EditOrderSuccessStatus) {

          await  alertDialog(context, 'سفارش تغییر وضعیت داده شد!', 2, true);
            Navigator.pop(context);
          }
        },
        builder: (context, state) {
          if (state.editStatus is EditOrderLoadingStatus) {
            return Container(
              color: Colors.black.withOpacity(0.5),
              child: Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
            );
          }
          if (state.editStatus is EditOrderFailedStatus) {
            print('Failed');

          }
          if (state.editStatus is EditOrderInitialStatus || state.editStatus is EditOrderSuccessStatus) {
            return Padding(
              padding: EdgeInsets.all(width * 0.02),
              child: Column(
                mainAxisSize: MainAxisSize.min, // Adjust height dynamically
                children: [
                  Text(
                    "Filter Orders",
                    style: TextStyle(
                        fontSize: width * 0.02, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: width * 0.02),
                  Container(
                    height: height * 0.5,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: StaticValues.status.length,
                      itemBuilder: (context, index) {
                        final key = StaticValues.status.keys.elementAt(index);
                        final value = StaticValues.status[key];
                        return Container(
                          padding: EdgeInsets.symmetric(vertical: width * 0.02),
                          alignment: Alignment.center,
                          child: Container(
                            color: Colors.blueGrey,
                            height: height * 0.1,
                            width: width * 0.7,
                            alignment: Alignment.center,
                            child: ListTile(
                              title:
                                  Text(value!, textAlign: TextAlign.center),
                              onTap: () {
                                print(key.substring(3));
                                BlocProvider.of<OrdersBloc>(context).add(
                                    EditStatus(OrdersEditStatus(
                                        ordersId, key.substring(3))));
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          }
          return Container();
        },
      );
    },
  );
}
