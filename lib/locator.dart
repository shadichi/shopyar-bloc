import 'package:get_it/get_it.dart';
import 'package:shapyar_bloc/features/feature_home/data/repository/home_repositoryImpl.dart';
import 'package:shapyar_bloc/features/feature_home/presentation/bloc/home_bloc.dart';
import 'package:shapyar_bloc/features/feature_log_in/data/data_source/remote/api_provider.dart';
import 'package:shapyar_bloc/features/feature_log_in/data/repository/log_in_repositoryImpl.dart';
import 'package:shapyar_bloc/features/feature_log_in/domain/repository/log_in_repository.dart';
import 'package:shapyar_bloc/features/feature_log_in/domain/use_cases/get_login_data.dart';
import 'package:shapyar_bloc/features/feature_log_in/domain/use_cases/set_string_usecase.dart';
import 'package:shapyar_bloc/features/feature_log_in/presentation/bloc/log_in_bloc.dart';
import 'package:shapyar_bloc/features/feature_orders/domain/use_cases/get_orders_use_case.dart';
import 'package:shapyar_bloc/features/feature_home/domain/use_cases/get_user_data_use_case.dart';
import 'package:shapyar_bloc/features/feature_products/data/repository/product_repositoryImpl.dart';
import 'package:shapyar_bloc/features/feature_products/presentation/bloc/products_bloc.dart';
import 'package:shapyar_bloc/features/feature_start/domain/use_cases/check-connectivity-use-case.dart';
import 'package:shapyar_bloc/features/feature_start/presentation/bloc/start_bloc.dart';

import 'features/feature_add_edit_order/data/data_source/remote/add_order_products_api_provider.dart';
import 'features/feature_add_edit_order/data/repository/add_order_repositoryImpl.dart';
import 'features/feature_add_edit_order/domain/repository/add_order_repository.dart';
import 'features/feature_add_edit_order/domain/use_cases/add_order_get_products_use_case.dart';
import 'features/feature_add_edit_order/domain/use_cases/add_order_set_order_use_case.dart';
import 'features/feature_add_edit_order/domain/use_cases/add_order_get_selected_products_use_case.dart';
import 'features/feature_add_edit_order/presentation/bloc/add_order_bloc.dart';
import 'features/feature_home/data/data_source/remote/home_api_provider.dart';
import 'features/feature_home/domain/repository/home_repository.dart';
import 'features/feature_orders/data/data_source/remote/orders_api_provider.dart';
import 'features/feature_orders/data/repository/orders_repositoryImpl.dart';
import 'features/feature_orders/domain/repository/orders_repository.dart';
import 'features/feature_orders/domain/use_cases/edit_status_orders_use_case.dart';
import 'features/feature_orders/presentation/bloc/orders_bloc.dart';
import 'features/feature_products/data/data_source/remote/products_api_provider.dart';
import 'features/feature_products/domain/repository/product_repository.dart';
import 'features/feature_products/domain/use_cases/get_products_use_case.dart';
import 'features/feature_products/domain/use_cases/products_get_user_data_use_case.dart';
import 'features/feature_start/data/repository/start_repositoryImpl.dart';
import 'features/feature_start/domain/repository/start_repository.dart';
import 'features/feature_start/domain/use_cases/get_string_use_case.dart';

//ساخت یک شی از getit
GetIt locator = GetIt.instance;
//در واقع با اینکار ما میتونیم هرکدام از این لوکیترهای پایین رو تزریق بکنیم به تمام کلاس های اپلیکیشن

setup() async {
  // Register dependencies
  locator.registerSingleton<ApiProvider>(ApiProvider());
  locator.registerSingleton<HomeApiProvider>(HomeApiProvider());
  locator.registerSingleton<OrdersApiProvider>(OrdersApiProvider());
  locator.registerSingleton<ProductsApiProvider>(ProductsApiProvider());
  locator.registerSingleton<AddOrderProductsApiProvider>(AddOrderProductsApiProvider());

 ///repositories
  locator.registerSingleton<LogInRepository>(LogInRepositoryImpl(locator()));
  locator.registerSingleton<HomeRepository>(HomeRepositoryImpl(locator()));
  locator.registerSingleton<OrdersRepository>(OrdersRepositoryImpl(locator()));
  locator.registerSingleton<ProductRepository>(ProductRepositoryImpl(locator()));
  locator.registerSingleton<AddOrderRepository>(AddOrderRepositoryImpl(locator()));
  locator.registerSingleton<StartRepository>(StartRepositoryImpl());

 ///usecases
  locator.registerSingleton<GetLoginDataUseCase>(GetLoginDataUseCase(locator()));
  locator.registerSingleton<GetStringUseCase>(GetStringUseCase(locator()));
  locator.registerSingleton<SetStringUseCase>(SetStringUseCase(locator()));
  locator.registerSingleton<CheckConnectivityUseCase>(CheckConnectivityUseCase(locator()));
  locator.registerSingleton<GetMainDataUseCase>(GetMainDataUseCase(locator()));
  locator.registerSingleton<GetOrdersUseCase>(GetOrdersUseCase(locator()));
  locator.registerSingleton<EditOrdersStatusUseCase>(EditOrdersStatusUseCase(locator()));

  locator.registerSingleton<GetProductsUseCase>(GetProductsUseCase(locator()));
  locator.registerSingleton<ProductsGetStringDataUseCase>(ProductsGetStringDataUseCase(locator()));

  locator.registerSingleton<AddOrderGetProductsUseCase>(AddOrderGetProductsUseCase(locator()));
  locator.registerSingleton<AddOrderGetSelectedProductsUseCase>(AddOrderGetSelectedProductsUseCase(locator()));
  locator.registerSingleton<AddOrderSetOrderUseCase>(AddOrderSetOrderUseCase(locator()));

 ///bloc
  locator.registerSingleton<LogInBloc>(LogInBloc(locator(), locator()));
  locator.registerSingleton<HomeBloc>(HomeBloc(locator()));
  locator.registerSingleton<OrdersBloc>(OrdersBloc(locator(), locator()));
  locator.registerSingleton<ProductsBloc>(ProductsBloc(locator(), locator()));
  locator.registerSingleton<AddOrderBloc>(AddOrderBloc( locator(), locator(), locator()));
  locator.registerSingleton<StartBloc>(StartBloc( locator(), locator()));

}
