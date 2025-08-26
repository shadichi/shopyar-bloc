import 'package:flutter/material.dart';

class NoConnectionScreen extends StatelessWidget {
  const NoConnectionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Container(width: width,height: height,color: Colors.blueGrey,child: SizedBox(
      width: width*0.7,height: height*0.5,
      child: Column(
        children: [
          Text("لطفا اتصال اینترنت خود را بررسی کنید"),
        ],
      ),
    ),);
  }
}
