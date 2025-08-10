import 'package:flutter/material.dart';
import 'package:shapyar_bloc/core/config/app-colors.dart';
import 'package:shapyar_bloc/core/widgets/main_wrapper.dart';

Future<void> alertDialogScreen(context, String text, index, pop,{IconData icon = Icons.error}) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(backgroundColor: Colors.white,shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConfig.calBorderRadiusSize(context))),
        title: Padding(
          padding:  EdgeInsets.all(AppConfig.calWidth(context, 3)),
          child: Icon(icon,color: AppConfig.background,),
        ),
        content: SingleChildScrollView(
          child: Center(
              child: Text(
                text,
                style:
                TextStyle(fontSize: AppConfig.calWidth(context, 3.2)),
              )),
        ),
        actions: <Widget>[
          TextButton(
            child: Text(
              'OK',
              style: TextStyle(color: AppConfig.background, fontSize: AppConfig.calWidth(context, 3)),
            ),
            onPressed: () {
              if (index == 1) {
                Navigator.of(context).pop();
              } else if (index == 2) {
                if (pop == true) {
                  Navigator.pop(context);
                } else {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return MainWrapper();
                  }));
                }
              }
            },
          ),
        ],
      );
    },
  );
}