import 'package:flutter/material.dart';
import 'package:shapyar_bloc/core/widgets/main_wrapper.dart';

Future<void> alertDialog(context, String text, index, pop) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('هشدار',
            style: TextStyle(
                fontSize: MediaQuery.of(context).size.height * 0.02,
                color: Colors.red)),
        content: SingleChildScrollView(
          child: Center(
              child: Text(
                text,
                style:
                TextStyle(fontSize: MediaQuery.of(context).size.height * 0.02),
              )),
        ),
        actions: <Widget>[
          TextButton(
            child: Text(
              'باشه',
              style: TextStyle(color: Colors.blueGrey),
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