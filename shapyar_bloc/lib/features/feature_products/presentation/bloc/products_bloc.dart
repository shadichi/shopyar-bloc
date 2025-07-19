import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:shapyar_bloc/core/params/products_params.dart';
import 'package:shapyar_bloc/features/feature_products/domain/entities/product_entity.dart';
import 'package:shapyar_bloc/features/feature_products/presentation/bloc/products_status.dart';
import '../../../../core/resources/order_data_state.dart';
import '../../../../core/utils/static_values.dart';
import '../../domain/use_cases/get_products_use_case.dart';
import '../../domain/use_cases/products_get_user_data_use_case.dart';
import 'package:shared_preferences/shared_preferences.dart';
part 'products_event.dart';

part 'products_state.dart';

class ProductsBloc extends Bloc<ProductsEvent, ProductsState> {
  final ProductsGetStringDataUseCase productsGetStringDataUseCase;
  final GetProductsUseCase getProductsUseCase;

  ProductsBloc(this.productsGetStringDataUseCase,this.getProductsUseCase)
      : super(ProductsState(productsStatus: ProductsLoadingStatus())) {

    /*on<LoadData>((event, emit) async {
      ProductsLoadedStatus productsLoadedStatus;
      emit(state.copyWith(newProductsStatus: ProductsLoadingStatus()));
      final ProductsParams productsParams =
      await productsGetStringDataUseCase();
      if (productsParams.webService != '' &&
          productsParams.consumerKey != '' &&
          productsParams.productCount != '') {
        emit(state.copyWith(newProductsStatus: pUserLoadedStatus(productsParams)));
      } else {
        //  emit(UserDataErrorState()); // No data found, stay in loading state
        emit(state.copyWith(newProductsStatus: pUserLoadedStatus(productsParams)));
      }
    });*/
    on<LoadProductsData>((event, emit) async {
      if (StaticValues.staticProducts.isEmpty || event.productsParams.isSearch) {
        print('1');

        if (event.productsParams.isSearch) {
          StaticValues.staticProducts.clear();
          emit(state.copyWith(newProductsStatus: ProductsLoadingStatus()));
        }

        if (StaticValues.webService == '' || StaticValues.passWord == '') {
          final prefs = await SharedPreferences.getInstance();
          StaticValues.webService = prefs.getString("webService") ?? '';
          StaticValues.passWord = prefs.getString("passWord") ?? '';
        }

        if (StaticValues.webService == '' && StaticValues.passWord == '') {
          print('3');
          emit(state.copyWith(newProductsStatus: ProductsErrorStatus()));
          return;  // جلوگیری از ادامه اجرا در صورت نبود اطلاعات لاگین
        }

        emit(state.copyWith(newProductsStatus: ProductsLoadingStatus()));

        dynamic dataState = await getProductsUseCase(event.productsParams);

        print('dataState.data: $dataState');

        if (dataState is OrderDataSuccess && dataState.data!.isNotEmpty) {
          StaticValues.staticProducts = dataState.data!.cast<ProductEntity>();
          emit(state.copyWith(newProductsStatus: ProductsLoadedStatus()));
        } else {
          // اینجا دیگه مستقیم خطا ارسال نمیشه، فقط اگه واقعاً داده‌ای نبود
          print("هیچ محصولی پیدا نشد");
          emit(state.copyWith(newProductsStatus: ProductsSearchFailedStatus()));

        }
      } else {
        emit(state.copyWith(newProductsStatus: ProductsLoadedStatus()));
      }
    });




  }
}
