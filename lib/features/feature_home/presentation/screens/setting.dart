import 'package:flutter/material.dart';
import 'package:shapyar_bloc/core/config/app-colors.dart';
import 'package:flutter_advanced_switch/flutter_advanced_switch.dart';

class SettingPage extends StatelessWidget {
  SettingPage({super.key});

  final _controller = ValueNotifier<bool>(false);

  List<String> buttonText = [
    'نمایش آدرس',
    'نمایش آدرس',
    'نمایش آدرس',
    'نمایش آدرس',
    'نمایش آدرس',
    'نمایش آدرس',
    'نمایش آدرس',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('تنظیمات نمایش فاکتور',style: TextStyle(fontSize: AppConfig.calFontSize(context, 4),color: Colors.white),),
        backgroundColor: AppConfig.background,
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
      ),
        backgroundColor: AppConfig.background,
        body: Stack(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: AppConfig.calHeight(context, 4)),
                            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(

                    height: AppConfig.calHeight(context, 68),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: List.generate(7, (generator) {
                          return makeRow(context, buttonText[generator],generator==6?false:true);
                        }),
                      ),
                    ),
                  ),
                  Container(
                      child:
                          ElevatedButton(onPressed: () {},style: ElevatedButton.styleFrom(
                      backgroundColor: AppConfig.secondaryColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5)))), child: Text('ذخیره',style: TextStyle(color: Colors.white),))
                  )],
              ),
            ),
          ],
        ));
  }

  Widget makeRow(context, String text, isShowDivider) {
    return Container(height: AppConfig.calHeight(context, 12),
      padding: EdgeInsets.symmetric(vertical: AppConfig.calHeight(context,1)),
      child: Column(mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                child: Text(
                  text,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: AppConfig.calFontSize(context, 3.3)),
                ),
              ),
              Container(
                child: AdvancedSwitch(
                  controller: _controller,
                  activeColor: Colors.green,
                  inactiveColor: Colors.grey,
                  //  activeChild: Text('ON'),
                  //    inactiveChild: Text('OFF'),
                  //  activeImage: AssetImage('assets/images/on.png'),
                  //  inactiveImage: AssetImage('assets/images/off.png'),
                  borderRadius: BorderRadius.all(const Radius.circular(15)),
                  width: 50.0,
                  height: 30.0,
                  enabled: true,
                  disabledOpacity: 0.5,
                ),
              ),
            ],
          ),
          if(isShowDivider)   Container(
              margin: EdgeInsets.all(AppConfig.calWidth(context, 2)),
              width: AppConfig.calWidth(context, 80),
              height: 0.5,
              decoration: BoxDecoration(
                  gradient:LinearGradient(
                    colors: [
                      Colors.red,
                      Colors.blue,
                    ],)
              )
          )
        ],
      ),
    );
  }
}
