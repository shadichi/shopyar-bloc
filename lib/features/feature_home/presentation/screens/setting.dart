import 'package:flutter/material.dart';
import 'package:shapyar_bloc/core/config/app-colors.dart';
import 'package:flutter_advanced_switch/flutter_advanced_switch.dart';
import 'package:shapyar_bloc/core/widgets/progress-bar.dart';
import 'package:shapyar_bloc/core/widgets/snackBar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingPage extends StatefulWidget {
  SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  List<ValueNotifier<bool>> controllers = [
    ValueNotifier<bool>(false),
    ValueNotifier<bool>(false),
    ValueNotifier<bool>(false),
    ValueNotifier<bool>(false),
    ValueNotifier<bool>(false),
    ValueNotifier<bool>(false),
    ValueNotifier<bool>(false),
    ValueNotifier<bool>(false),
    ValueNotifier<bool>(false),
  ];

  Map<int,dynamic> receivedFactorData = {};

  Map<int,dynamic> factorData = {};

  List<String> buttonText = [
    'نمایش شماره تماس فروشنده',
    'نمایش نشانی فروشنده',
    'نمایش کد پستی فروشنده',
    'نمایش ایمیل فروشنده',
    'نمایش شماره تماس خریدار',
    'نمایش نشانی خریدار',
    'نمایش کد پستی',
    'نمایش ایمیل خریدار',
    'نمایش توضیحات ',
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getFactorData();
  }
  Future<bool> getFactorData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    for( int i = 0 ; i< 9 ; i++){
      if(prefs.containsKey('factor-data-$i')){
        bool? value = prefs.getBool('factor-data-$i');
        receivedFactorData[i] = value;
        print('receivedFactorData[i]');
        print(receivedFactorData[i]);
      }else{
        receivedFactorData[i] = false;
      }

    }
    print(receivedFactorData);
    print(receivedFactorData[0].runtimeType);

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'تنظیمات نمایش فاکتور',
            style: TextStyle(
                fontSize: AppConfig.calFontSize(context, 4),
                color: Colors.white),
          ),
          backgroundColor: AppConfig.background,
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
        ),
        backgroundColor: AppConfig.background,
        body: FutureBuilder(future: getFactorData(), builder: (BuildContext context, AsyncSnapshot<bool> snapshot){
          if(snapshot.hasData){
            return Stack(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: AppConfig.calHeight(context, 4)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        height: AppConfig.calHeight(context, 68),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: List.generate(buttonText.length, (generator) {
                              return makeRow(
                                  context,
                                  buttonText[generator],
                                  generator == 8 ? false : true,
                                  controllers[generator],
                                  generator,receivedFactorData[generator]);
                            }),
                          ),
                        ),
                      ),
                      Container(width: AppConfig.calWidth(context, 40),height: AppConfig.calHeight(context, 8),
                        child: ElevatedButton(
                            onPressed: () async {
                              SharedPreferences prefs = await SharedPreferences.getInstance();
                              factorData.forEach((key, value){
                                prefs.setBool('factor-data-${key.toString()}', value);
                              });
                              showSnack(context, 'تنظیمات با موفقیت ذخیره شد.');
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: AppConfig.secondaryColor,
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(5)), side: BorderSide(width: 1, color: Colors.grey[300]!),)),
                            child: Text(
                              'ذخیره',
                              style: TextStyle(color: Colors.white),
                            )),
                      )
                    ],
                  ),
                ),
              ],
            );
          }else{
            return ProgressBar();
          }
        }));
  }

  Widget makeRow(context, String text, isShowDivider, controller, index, bool initialValue) {
    return Container(
      height: AppConfig.calHeight(context, 12),
      padding: EdgeInsets.symmetric(vertical: AppConfig.calHeight(context, 1)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                width: AppConfig.calWidth(context, 40),
                child: Text(
                  text,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: AppConfig.calFontSize(context, 3.3)),
                ),
              ),
              Container(
                child: AdvancedSwitch(initialValue: initialValue,
                  onChanged: (value) async {
                    print(value);
                    print(index);
                    factorData[index] = value;

                  },
                  controller: controller,
                  activeColor: AppConfig.piChartSection5,
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
          if (isShowDivider)
            Container(
                margin: EdgeInsets.all(AppConfig.calWidth(context, 2)),
                width: AppConfig.calWidth(context, 80),
                height: 0.5,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                  colors: [
                    AppConfig.firstLinearColor,
                    AppConfig.secondLinearColor
                  ],
                )))
        ],
      ),
    );
  }
}
