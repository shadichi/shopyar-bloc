import 'package:flutter/material.dart';
import 'package:shapyar_bloc/core/utils/static_values.dart';
import 'package:shapyar_bloc/core/colors/test3.dart';
import '../../../../core/widgets/snackBar.dart';
import '../../../feature_log_in/presentation/screens/log_in_screen.dart';
import '../../../feature_orders/presentation/screens/orders_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/home_bloc.dart';

class HomeDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Drawer(
      child: Container(
        color: AppColors.background,
        child: Column(
       //   mainAxisAlignment: MainAxisAlignment.start,
          // padding: EdgeInsets.zero,
          children: [
            SizedBox(height: height*0.03,),
            Container(
              height: height * 0.2,//color: Colors.yellow,
              child: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                   // color: Colors.green,
                    width: width * 0.7,
                    child: Text(StaticValues.shopName,style: TextStyle(fontSize: width*0.05,color: AppColors.white),),
                  ),
                  Container(
                 //   color: Colors.green,
                    width: width * 0.7,
                    child: Text(StaticValues.userName,style: TextStyle(fontSize: width*0.03,color: AppColors.white)),
                  ),
                  SizedBox(
                    width: width * 0.7,
                    child: Divider(),
                  ),
                ],
              ),
            ),
         //   _buildDrawerItem(Icons.home, "سفارشات", context, (){}),
            Container(height: height*0.4,
              child: Column(
                children: [
                  _buildDrawerItem(Icons.settings, "تنظیمات", context,(){}),
                  _buildDrawerItem(Icons.local_post_office_rounded, "ثبت و تغییر اطلاعات برچسب پستی", context,(){}),
                  _buildDrawerItem(Icons.exit_to_app, "خروج از حساب کاربری", context,(){}),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

Widget _buildDrawerItem(IconData icon, String title, BuildContext context, Function onTap) {
  return ListTile(
    leading: Icon(icon, color: AppColors.white70),
    title: Text(title, style: TextStyle(fontSize: 16, color: AppColors.white)),
    onTap: () {
      Navigator.pop(context); // بستن دراور
    },
  );
}
