import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopyar/core/config/app-colors.dart';
import 'package:shopyar/features/feature_add_edit_product/presentation/bloc/add_product_bloc.dart';
import 'package:shopyar/features/feature_home/presentation/screens/home-screen.dart';
import 'package:shopyar/features/feature_log_in/presentation/screens/log_in_screen.dart';
import 'package:shopyar/features/feature_orders/domain/entities/orders_entity.dart';
import 'package:shopyar/features/feature_orders/presentation/screens/orders_screen.dart';
import 'package:shopyar/features/feature_products/presentation/bloc/products_bloc.dart';
import 'package:shopyar/features/feature_start/presentation/bloc/start_bloc.dart';
import 'package:shopyar/features/feature_start/presentation/screens/start_screen.dart';
import 'core/utils/static_values.dart';
import 'features/feature_add_edit_order/presentation/screens/product_form_screen.dart';
import 'features/feature_add_edit_order/presentation/bloc/add_order_bloc.dart';
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
import 'package:package_info_plus/package_info_plus.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final packageInfo = await PackageInfo.fromPlatform();
  StaticValues.packageInfoVersionNo = packageInfo.version;
  await Hive.initFlutter();

  Hive.registerAdapter(StoreInfoAdapter()); // ثبت مدل
  // await Hive.openBox<StoreInfo>('storeBox'); // باز کردن باکس مخصوص فروشگاه اما چون گهگاهی میخایمش ازینجا بازش نمیکنم
  await Hive.openBox<StoreInfo>('storeBox');

  await setup();

  // فقط حالت portrait رو فعال می‌کنیم (از چرخش جلوگیری می‌کنه)
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    // اگر می‌خواید حالت برعکس هم مجاز باشه (سر-پا وارونه) این خط رو باز کنید:
    // DeviceOrientation.portraitDown,
  ]);


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
        BlocProvider(create: (_) => locator<AddProductBloc>()),
      ],
      child: MaterialApp(
        //themeMode: ThemeMode.light,
        theme: ThemeData(
          useMaterial3: true,
          fontFamily: 'IRANSansWeb',

          appBarTheme: AppBarTheme(actionsPadding: EdgeInsets.only( left: AppConfig.calWidth(context, 2)),
              color: AppConfig.backgroundColor,
              iconTheme: IconThemeData(
                color: Colors.white,
              )),
          colorScheme: ColorScheme.fromSeed(
            seedColor: AppConfig.firstLinearColor,
            brightness: Brightness.light,
          ),
          scaffoldBackgroundColor: AppConfig.backgroundColor,
          elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(AppConfig.calWidth(context, 2))),
            backgroundColor: AppConfig.secondaryColor,
            textStyle: TextStyle(fontSize: AppConfig.calFontSize(context, 2), fontFamily: 'IRANSansWeb'),
          )),

        ),
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
          EnterInfData.routeName: (context) => EnterInfData(),
         // PdfViewerScreen.routeName: (context) => PdfViewerScreen(),
        },
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case AddOrderProductFormScreen.createRoute:
              return MaterialPageRoute(
                builder: (_) => AddOrderProductFormScreen.create(),
              );

            case AddOrderProductFormScreen.editRoute:
              final entity = settings.arguments as OrdersEntity;
              return MaterialPageRoute(
                builder: (_) => AddOrderProductFormScreen.edit(ordersEntity: entity),
              );
          }
        },
      ),
    );
  }
}
