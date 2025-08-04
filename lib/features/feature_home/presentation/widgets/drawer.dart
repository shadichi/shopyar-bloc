import 'package:flutter/material.dart';
import 'package:shapyar_bloc/core/utils/static_values.dart';
import '../../../../core/colors/app-colors.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/config/app-colors.dart';

class HomeDrawer extends StatelessWidget {
  final List<String> icons = [
    'assets/images/icons/setting.svg',
    'assets/images/icons/mail.svg',
    'assets/images/icons/logout.svg',
  ];
  final List<String> title = [
    'تنظیمات',
    'برچسب پستی',
    'خروج از حساب',
  ];

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    StaticValues.isDrawerOpen = !StaticValues.isDrawerOpen;

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
                    child: Image.asset('assets/images/icons/shopyar-icon.png'),
                    width: width * 0.1,
                  ),
                  Container(
                    width: width * 0.3,
                    child: Column(
                      children: [
                        Container(
                          child: Text(
                            'شاپ یار',
                            style: TextStyle(
                                color: Colors.white, fontSize: width * 0.05),
                          ),
                          width: width * 0.3,
                          alignment: Alignment.center,
                        ),
                        Container(
                          child: Text(
                            'شادی مرادیان',
                            style: TextStyle(
                                color: Colors.grey, fontSize: width * 0.04),
                          ),
                          width: width * 0.3,
                          alignment: Alignment.center,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Flexible(
              child: Container(
                  padding: EdgeInsets.all(width*0.02),
                  alignment: Alignment.bottomCenter,
                  margin: EdgeInsets.only(top: height * 0.12),
                  decoration: BoxDecoration(
                      color: AppConfig.background,
                      borderRadius: BorderRadius.all(Radius.circular(15))),
                  child: Column(
                    children: List.generate(3, (index) {
                      return _buildDrawerItem(
                          icons[index], title[index], context, () {},index==2?false:true, width*0.7);
                    }),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildDrawerItem(
    String svgPic, String title, BuildContext context, Function onTap, bool isDivider, double size) {
  return Container(

    child: Column(
      children: [
        ListTile(
          leading: Container(
            width: size*0.065,
              child: CircleAvatar(
            backgroundColor: AppConfig.background,
            child: SvgPicture.asset(svgPic),
          )),
          title:
              Text(title, style: TextStyle(fontSize: size*0.045, color: AppConfig.white)),
          onTap: () {
            Navigator.pop(context); // بستن دراور
          },
        ),isDivider?Container(child: Divider(),width: size,):SizedBox()
      ],
    ),
  );
}
