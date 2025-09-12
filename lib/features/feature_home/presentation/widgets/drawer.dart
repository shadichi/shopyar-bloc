import 'package:flutter/material.dart';
import 'package:shapyar_bloc/core/utils/static_values.dart';
import 'package:shapyar_bloc/core/widgets/alert_dialog.dart';
import 'package:shapyar_bloc/features/feature_home/presentation/bloc/home_bloc.dart';
import 'package:shapyar_bloc/features/feature_home/presentation/screens/setting.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shapyar_bloc/features/feature_orders/presentation/screens/enter_inf_data.dart';
import '../../../../core/config/app-colors.dart';
import '../../../../core/params/whole_user_data_params.dart';
import '../../../feature_log_in/presentation/bloc/log_in_bloc.dart';
import '../../../feature_orders/presentation/widgets/show_post_label.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeDrawer extends StatelessWidget {
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
            MaterialPageRoute(builder: (context) => EnterInfData()));
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
                  SizedBox(
                    width: width * 0.1,
                    child: Image.asset('assets/images/icons/shopyar-icon.png'),
                  ),
                  Container(
                    width: width * 0.3,
                    height: height*0.08,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          width: width * 0.3,
                          alignment: Alignment.center,
                          child: Text(
                            StaticValues.shopName,maxLines: 1,
                            style: TextStyle(
                                color: Colors.white, fontSize: width * 0.045),
                          ),
                        ),
                        Container(
                          width: width * 0.3,
                          alignment: Alignment.center,
                          child: Text(
                            StaticValues.userName,maxLines: 1,
                            style: TextStyle(
                                color: Colors.grey, fontSize: width * 0.045),
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
            style: TextStyle(fontSize: size * 0.045, color: AppConfig.white)),
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
