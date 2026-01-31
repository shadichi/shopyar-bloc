import 'package:flutter/material.dart';
import 'package:shopyar/core/widgets/snackBar.dart';
import 'package:shopyar/features/feature_home/presentation/screens/home-screen.dart';
import 'package:shopyar/features/feature_orders/presentation/screens/orders_screen.dart';
import 'package:shopyar/features/feature_products/presentation/screens/products_screen.dart';
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

  // ← فلگ آماده‌شدن Home (فقط این رو اضافه کردیم)
  final ValueNotifier<bool> homeReady = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;

    List<Widget> pageViewWidget = [
      OrdersScreen(),
      HomeScreen(
        onDrawerStatusChange: (open) {
          isDrawerOpen.value = open;
        },
        // وقتی Home آماده شد اینو صدا بزن (هر جا لودت کامل شد)
        onReady: () {
          homeReady.value = true;
        },
      ),
      ProductsScreen(),
    ];

    return Scaffold(
      backgroundColor: AppConfig.backgroundColor,
      body: Stack(
        children: [
          PageView(
            controller: pageController,
            physics: const NeverScrollableScrollPhysics(),
            children: pageViewWidget,
          ),
          Positioned(
            top: height * 0.87, // ← همون اندازه‌ی خودت
            left: 0,
            right: 0,
            child: ValueListenableBuilder<bool>(
              valueListenable: isDrawerOpen,
              builder: (context, drawerOpen, _) {
                return AnimatedOpacity(
                  duration: const Duration(milliseconds: 400),
                  opacity: drawerOpen ? 0.0 : 1.0,
                  child: IgnorePointer(
                    ignoring: drawerOpen,
                    child: Padding(
                      // ← همون پدینگ خودت؛ دست‌نخورده
                      padding: EdgeInsets.symmetric(
                        horizontal: AppConfig.calWidth(context, 10),
                        vertical: AppConfig.calWidth(context, 2),
                      ),
                      // فقط این ValueListenableBuilder اضافه شد که overlay رو کنترل کنه
                      child: ValueListenableBuilder<bool>(
                        valueListenable: homeReady,
                        builder: (context, ready, __) {
                          return Stack(
                            children: [
                              // خود BottomNav با همون سایز و جای قبلی
                              MyBottomNavigationBar(
                                onChange: (index) {
                                  // تا وقتی Home آماده نشده فقط تب وسط مجازه
                                  if (!ready && index != 1) return;
                                  pageController.animateToPage(
                                    index,
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeInOut,
                                  );
                                },
                              ),
                              if (!ready)
                                Positioned.fill(
                                  child: Row(
                                    children: [
                                      // تب سمت چپ
                                      Expanded(
                                        child: GestureDetector(
                                          behavior: HitTestBehavior.opaque,
                                          onTap: () {
                                            showSnack(context, 'لطفا صبر کنید!');
                                          },
                                          child: const SizedBox.expand(),
                                        ),
                                      ),

                                      // تب وسط (Home) آزاد
                                      Expanded(
                                        child: IgnorePointer(
                                          child: Container(),
                                        ),
                                      ),

                                      // تب سمت راست
                                      Expanded(
                                        child: GestureDetector(
                                          behavior: HitTestBehavior.opaque,
                                          onTap: () {
                                            showSnack(context, 'لطفا صبر کنید!');
                                          },
                                          child: const SizedBox.expand(),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                            ],
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
