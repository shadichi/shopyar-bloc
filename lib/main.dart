import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shapyar_bloc/features/feature_home/presentation/screens/home-screen.dart';
import 'package:shapyar_bloc/features/feature_log_in/presentation/screens/log_in_screen.dart';
import 'package:shapyar_bloc/features/feature_orders/presentation/screens/orders_screen.dart';
import 'package:shapyar_bloc/features/feature_products/presentation/bloc/products_bloc.dart';
import 'package:shapyar_bloc/features/feature_start/presentation/bloc/start_bloc.dart';
import 'package:shapyar_bloc/features/feature_start/presentation/screens/start_screen.dart';
import 'features/feature_orders/presentation/widgets/show_pdf.dart';
import 'features/feature_orders/presentation/widgets/show_post_label.dart';
import 'features/feature_add_edit_order/presentation/bloc/add_order_bloc.dart';
import 'features/feature_add_edit_order/presentation/screens/add_order.dart';
import 'features/feature_home/presentation/bloc/home_bloc.dart';
import 'features/feature_log_in/presentation/bloc/log_in_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'features/feature_orders/presentation/bloc/orders_bloc.dart';
import 'features/feature_orders/presentation/screens/enter_inf_data.dart';
import 'features/feature_products/presentation/screens/products_screen.dart';
import 'features/feature_orders/data/models/store_info.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'locator.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  Hive.registerAdapter(StoreInfoAdapter()); // ثبت مدل
  // await Hive.openBox<StoreInfo>('storeBox'); // باز کردن باکس مخصوص فروشگاه اما چون گهگاهی میخایمش ازینجا بازش نمیکنم

  await setup();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      //Wrapping the MaterialApp ensures all BLoCs are available throughout the widget tree, including all routes and screens.
      providers: [
        BlocProvider(create: (_) => locator<LogInBloc>()),
        BlocProvider(create: (_) => locator<HomeBloc>()),
        BlocProvider(create: (_) => locator<OrdersBloc>()),
        BlocProvider(create: (_) => locator<ProductsBloc>()),
        BlocProvider(create: (_) => locator<AddOrderBloc>()),
        BlocProvider(create: (_) => locator<StartBloc>()),
      ],
      child: MaterialApp(
        themeMode: ThemeMode.light,
        theme: ThemeData(fontFamily: 'IRANSansWeb'),
        initialRoute: "/",
        locale: const Locale("fa", ""),
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale("en", ""),
          Locale("fa", ""),
        ],
        debugShowCheckedModeBanner: false,
        home: StartScreen(),
        routes: {
          HomeScreen.routeName: (context) => HomeScreen(),
          LogInScreen.routeName: (context) => LogInScreen(),
          OrdersScreen.routeName: (context) => OrdersScreen(),
          ProductsScreen.routeName: (context) => ProductsScreen(),
          AddOrder.routeName: (context) => AddOrder(),
          EnterInfData.routeName: (context) => EnterInfData(),
          PdfViewerScreen.routeName: (context) => PdfViewerScreen(),
          ShowPDF.routeName: (context) => ShowPDF(),
          // Uncomment and adjust other routes if needed
          // OrderDetailScreen.routeName: (context) => OrderDetailScreen(),
          // EditOrder.routeName: (context) => EditOrder(),
        },
      ),
    );
  }
}



