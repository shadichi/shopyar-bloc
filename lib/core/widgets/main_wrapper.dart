import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shapyar_bloc/features/feature_home/presentation/bloc/home_bloc.dart';
import 'package:shapyar_bloc/features/feature_home/presentation/screens/home-screen.dart';
import 'package:shapyar_bloc/features/feature_orders/presentation/screens/orders_screen.dart';
import 'package:shapyar_bloc/features/feature_products/presentation/screens/products_screen.dart';
import 'package:shapyar_bloc/locator.dart';

import '../../features/feature_log_in/presentation/screens/log_in_screen.dart';
import '../../features/feature_orders/presentation/bloc/orders_bloc.dart';
import '../../features/feature_products/presentation/bloc/products_bloc.dart';
import '../colors/test3.dart';
import 'bottom_nav.dart';

class MainWrapper extends StatelessWidget {
  MainWrapper({Key? key}) : super(key: key);

  final PageController pageController = PageController(initialPage: 1);

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    List<Widget> pageViewWidget = [
      BlocProvider(
        create: (context) => OrdersBloc(locator(),locator()),
        child: OrdersScreen(),
      ),
      BlocProvider(
        create: (context) => HomeBloc(locator()),
        child: HomeScreen(),
      ),
      BlocProvider(
        create: (context) => ProductsBloc(locator(), locator()),
        child: ProductsScreen(),
      ),
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      //   extendBody: true,//میگه body بره زیرمجموعه bottomnav
      bottomNavigationBar: BottomNav(
        Controller: pageController,
      ),
      body: PageView(
        controller: pageController,
        children: pageViewWidget,
      ),
    );
  }
}
