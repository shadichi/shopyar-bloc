import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shopyar/core/utils/static_values.dart';
import 'package:shopyar/core/widgets/alert_dialog.dart';
import 'package:shopyar/extension/persian_digits.dart';
import 'package:shopyar/features/feature_home/presentation/bloc/home_bloc.dart';
import 'package:shopyar/features/feature_home/presentation/screens/setting.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shopyar/features/feature_orders/presentation/screens/enter_inf_data.dart';
import '../../../../core/config/app-colors.dart';
import '../../../feature_orders/data/models/store_info.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';

class HomeDrawer extends StatefulWidget {
  @override
  State<HomeDrawer> createState() => _HomeDrawerState();
}

class _HomeDrawerState extends State<HomeDrawer> {

  String _version = "";
  StoreInfo storeInfo =  StoreInfo(storeName: '', storeAddress: '', phoneNumber: '', instagram: '', postalCode: '', website: '', storeIcon: '',storeSenderName: '',storeNote: '');

  final List<String> icons = [
    'assets/images/icons/setting.svg',
    'assets/images/icons/mail.svg',
    'assets/images/icons/logout.svg',
  ];

  final List<String> title = [
    'تنظیمات نمایش فاکتور',
    'برچسب پستی',
    'خروج از حساب',
  ];

  Future<void> getHiveData() async {
    final box = await Hive.openBox<StoreInfo>('storeBox');
    final stored = box.get('storeInfo');
    if (stored != null) {
      storeInfo = stored;
    } else {
      // اگر انتظار داشتی حتما داده باشه، اینجا می‌تونی مقدار پیش‌فرض یا لاگ بذاری
      storeInfo = StoreInfo(
          storeName: '',
          storeAddress: '',
          phoneNumber: '',
          instagram: '',
          postalCode: '',
          website: '',
          storeIcon: '',
          storeSenderName: '',
          storeNote: ''
      );
    }
    //  await box.close();
    setState(() {}); // اگه می‌خوای UI تغییر کنه
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getHiveData();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    StaticValues.isDrawerOpen = !StaticValues.isDrawerOpen;

    List<void Function()?> onTap = [
      () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => SettingPage()));
      },
      () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => EnterInfData(isFromDrawer: true,)));
      },
      () async {
        final navigator = Navigator.of(context);
        final bloc = context.read<HomeBloc>();

        final result = await alertDialogScreen(
            context, 'آیا از حساب کاربری خود خارج می شوید؟', 2, true,
            isExit: true);

        if (!context.mounted) return;

        if (result == true) {

          bloc.add(AccountExit());

        } else {

          if (navigator.canPop()) Navigator.pop(context);
        }

      }
    ];

    return Drawer(
      child: Container(
        height: height,
        width: width,
        color: AppConfig.secondaryColor,
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: height * 0.13),
              alignment: Alignment.center,
              width: width * 0.6,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    //color: Colors.green,
                    width: width * 0.2,
                    height: height*0.2,
                    child: Builder(
                      builder: (context) {
                        // اگر خالی بود → بزار روی shopyar-icon.svg
                        if (storeInfo.storeIcon.isEmpty) {
                          return SvgPicture.asset(
                            'assets/images/icons/shopyar-icon.svg',
                            fit: BoxFit.contain,
                          );
                        }

                        final iconPath = storeInfo.storeIcon;

                        if (iconPath.startsWith('assets/')) {
                          if (iconPath.toLowerCase().endsWith('.svg')) {
                            return SvgPicture.asset(iconPath, fit: BoxFit.contain);
                          } else {
                            return Image.asset(iconPath, fit: BoxFit.contain);
                          }
                        }

                        // اگر فایل از حافظه لوکال باشه
                        if (iconPath.toLowerCase().endsWith('.svg')) {
                          return SvgPicture.file(File(iconPath), fit: BoxFit.contain);
                        } else {
                          return Image.file(File(iconPath), fit: BoxFit.contain);
                        }
                      },
                    ),
                  )
                  ,
                  Container(
                    width: width * 0.3,
                    height: height*0.1,
                    child: Column(
                      spacing: 0,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: Container(
                            alignment: Alignment.center,
                            child: Text(
                              StaticValues.shopName,maxLines: 1,
                              style: TextStyle(
                                  color: Colors.white, fontSize: width * 0.06),
                            ),
                          ),
                        ),
                        SizedBox(height: height*0.003,),
                        Expanded(
                          child: Container(
                            alignment: Alignment.center,
                            child: Text(
                              StaticValues.userName,maxLines: 1,
                              style: TextStyle(
                                  color: Colors.grey, fontSize: width * 0.055),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Flexible(
              child: Container(
                  padding: EdgeInsets.all(width * 0.02),
                  alignment: Alignment.bottomCenter,
                  margin: EdgeInsets.only(top: height * 0.12),
                  decoration: BoxDecoration(
                      color: AppConfig.backgroundColor,
                      borderRadius: BorderRadius.all(Radius.circular(15))),
                  child: Column(
                    children: List.generate(3, (index) {
                      return _buildDrawerItem(
                          icons[index],
                          title[index],
                          context,
                          onTap[index],
                          index == 2 ? false : true,
                          width * 0.7);
                    }),
                  )),
            ),
            Padding(
              padding:  EdgeInsets.symmetric(vertical: width*0.02),
              child: Text(
                'نسخه ${StaticValues.packageInfoVersionNo.toString().stringToPersianDigits()}',
                style: TextStyle(
                  color: AppConfig.progressBarColor,
                  fontSize: AppConfig.calWidth(context, 3.2),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildDrawerItem(String svgPic, String title, BuildContext context,
    void Function()? onTap, bool isDivider, double size) {
  return Column(
    children: [
      ListTile(
        leading: SizedBox(
            width: size * 0.065,
            child: CircleAvatar(
              backgroundColor: AppConfig.backgroundColor,
              child: SvgPicture.asset(svgPic),
            )),
        title: Text(title,
            style: TextStyle(fontSize: size * 0.058, color: AppConfig.white)),
        onTap: onTap,
      ),
      isDivider
          ? SizedBox(
              width: size,
              child: Container(
                  margin: EdgeInsets.all(AppConfig.calWidth(context, 2)),
                  width: AppConfig.calWidth(context, 40),
                  height: 0.5,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                    colors: [
                      AppConfig.firstLinearColor,
                      AppConfig.secondLinearColor
                    ],
                  ))),
            )
          : SizedBox()
    ],
  );
}
