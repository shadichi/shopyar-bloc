import 'package:flutter/material.dart';
import 'package:shapyar_bloc/core/config/app-colors.dart';
import 'package:shapyar_bloc/core/widgets/main_wrapper.dart';

Future<bool?> alertDialogScreen(
    BuildContext context,
    String text,
    int index,
    bool pop, {
      IconData icon = Icons.error,
      bool isExit = false,
    }) {
  return showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.white,
        actionsAlignment: MainAxisAlignment.spaceBetween,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            AppConfig.calBorderRadiusSize(context),
          ),
        ),
        title: Padding(
          padding: EdgeInsets.all(AppConfig.calWidth(context, 3)),
          child: Icon(icon, color: AppConfig.backgroundColor),
        ),
        content: SingleChildScrollView(
          child: Center(
            child: Text(
              text,textAlign: TextAlign.center,
              style: TextStyle(fontSize: AppConfig.calWidth(context, 3.2),),
            ),
          ),
        ),
        actions: <Widget>[
       Directionality(
         textDirection: TextDirection.ltr,
         child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
           children: [
             TextButton(
               child: Text(
                 isExit ? 'بله' : 'باشه',
                 style: TextStyle(
                   color: AppConfig.backgroundColor,
                   fontSize: AppConfig.calWidth(context, 3),
                 ),
               ),
               onPressed: () {
                 Navigator.pop(context, true); // 👈 return true
               },
             ),
             if (isExit)
               TextButton(
                 child: Text(
                   'خیر',
                   style: TextStyle(
                     color: AppConfig.backgroundColor,
                     fontSize: AppConfig.calWidth(context, 3),
                   ),
                 ),
                 onPressed: () {
                   Navigator.pop(context, false); // 👈 return false
                 },
               ),
           ],
         ),
       )
        ],
      );
    },
  );
}

