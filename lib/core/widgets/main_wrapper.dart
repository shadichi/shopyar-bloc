import 'package:flutter/material.dart';
import 'package:shapyar_bloc/features/feature_home/presentation/screens/home-screen.dart';
import 'package:shapyar_bloc/features/feature_orders/presentation/screens/orders_screen.dart';
import 'package:shapyar_bloc/features/feature_products/presentation/screens/products_screen.dart';
import '../colors/app-colors.dart';
import '../config/app-colors.dart';
import 'bottom_nav.dart';

class MainWrapper extends StatefulWidget {
  @override
  State<MainWrapper> createState() => _MainWrapperState();
}

class _MainWrapperState extends State<MainWrapper> {
  final PageController pageController = PageController(initialPage: 1);
  final ValueNotifier<bool> isDrawerOpen = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;

    List<Widget> pageViewWidget = [
      OrdersScreen(),
      HomeScreen(
        onDrawerStatusChange: (open) {
          isDrawerOpen.value = open;
        },
      ),
      ProductsScreen(),
    ];

    return Scaffold(
      backgroundColor: AppConfig.background,
      body: Stack(
        children: [
          PageView(
            controller: pageController,
            physics: NeverScrollableScrollPhysics(),
            children: pageViewWidget,
          ),
          Positioned(
            top: height * 0.87,
            left: 0,
            right: 0,
            child: ValueListenableBuilder<bool>(
              valueListenable: isDrawerOpen,
              builder: (context, drawerOpen, _) {
                return AnimatedOpacity(
                  duration: Duration(milliseconds: 400),
                  opacity: drawerOpen ? 0.0 : 1.0,
                  child: IgnorePointer(
                    ignoring: drawerOpen,
                    child: Padding(
                      padding:  EdgeInsets.symmetric(horizontal: AppConfig.calWidth(context, 10), vertical:  AppConfig.calWidth(context, 2)),
                      child: MyBottomNavigationBar(
                        onChange: (index) {
                          pageController.animateToPage(
                            index,
                            duration: Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}


