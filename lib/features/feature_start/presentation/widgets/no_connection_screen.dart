import 'package:flutter/material.dart';
import 'package:shopyar/core/config/app-colors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/start_bloc.dart';

class NoConnectionScreen extends StatelessWidget {
  const NoConnectionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: width * 0.08),
        child: Center(
            child: Container(
              height: height*0.14,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
              Text(
                "لطفا اتصال اینترنت خود را بررسی کنید!",
                style: TextStyle(fontSize: width * 0.05, color: AppConfig.white),
                textAlign: TextAlign.center,
              ),
              IconButton(
                  onPressed: () {
                    context.read<StartBloc>().add(CheckConnectionEvent());
                  },
                  icon: Icon(Icons.refresh, color: Colors.grey,))
                        ],
                      ),
            )),
      ),
    );
  }
}
