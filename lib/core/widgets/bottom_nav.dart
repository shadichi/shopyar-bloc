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
    'assets/images/icons/product-screen.svg',
    'assets/images/icons/home-screen.svg',
    'assets/images/icons/order-screen.svg',
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
              Border.all(color: Color(0xff697C9D), width: 1) // Rounded corners
          ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: width * 0.01),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(items.length, (index) {
              bool isSelected = index == selectedIndex;
              return AnimatedContainer(
                duration: Duration(milliseconds: 250),
                curve: Curves.easeIn,
                height: isSelected ? width * 0.065 : width * 0.055,
                width: width * 0.2,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedIndex = index;
                    });
                    widget.onChange?.call(index);
                  },
                  child: SvgPicture.asset(
                    items[index],
                    /*   colorFilter: ColorFilter.mode(
                          activePage == itemIndex
                              ? const Color.fromRGBO(94, 96, 89, 1)
                              : AppColors.cardBackground,
                          // Color based on active state
                          BlendMode.srcIn,
                        ),*/
                    // Icon width
                  ),
                ),
              );
            })),
      ),
    );
  }
}
