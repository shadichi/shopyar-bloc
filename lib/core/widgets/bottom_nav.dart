import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:shapyar_bloc/core/colors/test3.dart';

class BottomNav extends StatelessWidget {
  PageController Controller;
  BottomNav({Key? key, required this.Controller}) : super(key: key);

  int _selectedIndex = 1; // Set to match the initialPage of PageController

  @override
  Widget build(BuildContext context) {

    var primaryColor = Theme.of(context).primaryColor;
    TextTheme textTheme = Theme.of(context).textTheme;

    return Container(

      height: 60
      //width: 50
      ,
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            blurRadius: 20,
            color: Colors.black.withOpacity(.1),
          )
        ],
        borderRadius: const BorderRadius.only(topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0)),
      ),
      child: SafeArea(
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
            child: GNav(
                selectedIndex: _selectedIndex, // Set the selected index

                //  rippleColor: Colors.red, // tab button ripple color when pressed
             // hoverColor: Colors.grey, // tab button hover color
              haptic: true, // haptic feedback
             // tabBorderRadius: 15,
             // tabActiveBorder: Border.all(color: Colors.black, width: 1), // tab button border
             // tabBorder: Border.all(color: Colors.grey, width: 1), // tab button border
             // tabShadow: [BoxShadow(color: Colors.grey.withOpacity(0.5), blurRadius: 8)], // tab button shadow
              curve: Curves.linear, // tab animation curves
              duration: Duration(milliseconds: 100), // tab animation duration
              gap: 8, // the tab button gap between icon and text
             // color: Colors.grey[800], // unselected icon color
             // activeColor: Colors.purple, // selected icon and text color
              iconSize: 24, // tab button icon size
             // tabBackgroundColor: Colors.purple.withOpacity(0.1), // selected tab background color
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12), // navigation bar padding
               // gap: 8,
                tabBackgroundColor: Color(0xffE2EAFC),
                onTabChange: (index){
                  _selectedIndex = index;
                  switch(index){
                    case 0:
                      Controller.animateToPage(0, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
                    case 1:
                      Controller.animateToPage(1, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
                    case 2:
                      Controller.animateToPage(2, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);

                  }
                },
                tabs: [
                  GButton(
                    icon: Icons.list_alt,iconSize: 20,textSize: 20,
                    text: 'سفارشات',iconActiveColor:AppColors.background,textColor: AppColors.background,
                  ),
                  GButton(
                    icon: Icons.home,
                    text: 'خانه',iconActiveColor:AppColors.background,textColor: AppColors.background,
                  ),
                  GButton(
                    icon: Icons.production_quantity_limits,iconActiveColor:AppColors.background,textColor: AppColors.background,
                    text: 'محصولات',
                  )
                ]
            )
        ),
      ),
    );
  }
}