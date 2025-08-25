import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../colors/app-colors.dart';
import '../config/app-colors.dart';

// Main widget for the bottom navigation bar, defines its stateful behavior
class MyBottomNavigationBar extends StatefulWidget {
  final Function(int active)? onChange;

  const MyBottomNavigationBar({super.key, this.onChange});

  @override
  State<MyBottomNavigationBar> createState() => _MyBottomNavigationBarState();
}

class _MyBottomNavigationBarState extends State<MyBottomNavigationBar> {
  late int activePage;

  final List<String> items = [
    'assets/images/icons/order-screen.svg',
    'assets/images/icons/home-screen.svg',
    'assets/images/icons/product-screen.svg',
    'assets/images/icons/order-screen-selected.svg',
    'assets/images/icons/home-screen-selected.svg',
    'assets/images/icons/product-screen-selected.svg',
  ];

  int selectedIndex = 1;

  @override
  void initState() {
    activePage = 0;
    super.initState();
  }

  @override
  void didUpdateWidget(MyBottomNavigationBar oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  final labels = ['سفارشات', 'داشبورد', 'محصولات'];

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: width * 0.01),
      height: height * 0.1,
      width: width * 0.9,
      constraints: const BoxConstraints(maxHeight: 76.5),
      decoration: BoxDecoration(
          color: AppConfig.secondaryColor.withOpacity(0.8), // Background color
          borderRadius: BorderRadius.circular(width * 0.02),
          border:
              Border.all(color: AppConfig.borderColor, width: 0.4) // Rounded corners
          ),
      child:
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(3, (index) {
          final isSelected = index == selectedIndex;

          return InkWell(
            borderRadius: BorderRadius.circular(AppConfig.calBorderRadiusSize(context)),
            onTap: () {
              setState(() => selectedIndex = index);
              widget.onChange?.call(index);
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // ICON: fixed slot width + centered
                Container(
                  width: AppConfig.calWidth(context, 20), //
                  height: AppConfig.calHeight(context, 3),
                  child: Center(
                    child: AnimatedScale(
                      scale: isSelected ? 1.15 : 1.0,
                      duration: const Duration(milliseconds: 200),
                      child: SvgPicture.asset(
                        isSelected ? items[index + 3] : items[index],
                        width: AppConfig.calWidth(context, 20),
                        height: AppConfig.calWidth(context, 20),
                        alignment: Alignment.center, // extra safety
                        fit: BoxFit.scaleDown,
                      ),
                    ),
                  ),
                ),

                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  transitionBuilder: (child, anim) =>
                      SizeTransition(sizeFactor: anim, axisAlignment: -1, child: child),
                  child: isSelected
                      ? Container(
                    padding: EdgeInsets.only(top: AppConfig.calWidth(context, 2)),
                        width: AppConfig.calWidth(context, 20), //
                        child: Text(
                          labels[index],
                          key: ValueKey(index),
                          textAlign: TextAlign.center,
                          style:  TextStyle(fontSize: AppConfig.calFontSize(context, 2.4), fontWeight: FontWeight.w600, color: isSelected?AppConfig.firstLinearColor:Colors.white),
                        ),
                      )
                      : const SizedBox.shrink(),
                ),
              ],
            ),
          );
        }),
      )


    );
  }
}
