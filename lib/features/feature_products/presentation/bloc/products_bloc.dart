import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:shopyar/core/params/products_params.dart';
import 'package:shopyar/features/feature_products/domain/entities/product_entity.dart';
import 'package:shopyar/features/feature_products/presentation/bloc/products_status.dart';
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

  ProductsBloc(this.productsGetStringDataUseCase, this.getProductsUseCase)
      : super(ProductsState(
            productsStatus: ProductsLoadingStatus(), isLoadingMore: false)) {
    on<LoadProductsData>((event, emit) async {
      final isInitial = StaticValues.staticProducts.isEmpty &&
          !event.productsParams.isLoadMore;
      print(StaticValues.staticProducts);

      if (StaticValues.staticProducts.isEmpty ||
          event.productsParams.isSearch ||
          event.productsParams.isLoadMore) {

        if (event.productsParams.isSearch || event.productsParams.isRefresh) {
          StaticValues.staticProducts.clear();
          emit(state.copyWith(newProductsStatus: ProductsLoadingStatus()));
        }
        if (event.productsParams.isLoadMore) {
          emit(state.copyWith(newIsLoadingMore: true));
        }
        if (isInitial) {
          emit(state.copyWith(newProductsStatus: ProductsLoadingStatus()));
        }

        try {
          String perPage = '10';
          print("7");
          if (event.productsParams.productCount.isNotEmpty) {
            perPage = event.productsParams.productCount;
          }
          final dataState = await getProductsUseCase(event.productsParams);
          print("dataState in product screen");
          print(dataState);
          if (dataState is OrderDataSuccess) {

            final fetched = dataState.data!.cast<ProductEntity>();

            if (event.productsParams.isLoadMore &&
                StaticValues.staticProducts.isNotEmpty) {
              StaticValues.staticProducts = fetched;
            } else {
              StaticValues.staticProducts = fetched;
            }
            emit(state.copyWith(newProductsStatus: ProductsLoadedStatus()));
          } else {
            emit(state.copyWith(newProductsStatus: ProductsErrorStatus()));
          }
        } catch (e) {
          emit(state.copyWith(newProductsStatus: ProductsErrorStatus()));
        } finally {
          // 👇 حتماً خاموش کن تا دکمه از لودینگ خارج شه
          if (event.productsParams.isLoadMore) {
            emit(state.copyWith(newIsLoadingMore: false));
          }
        }
/*

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
      */
      }else if(StaticValues.staticProducts.isNotEmpty){
        emit(state.copyWith(newProductsStatus: ProductsLoadedStatus()));

      }
    });

    on<RefreshProductsData>((event, emit) async {
      // اختیاری: دوست داری حین رفرش اسپینر هم داشته باشی
      emit(state.copyWith(newProductsStatus: ProductsLoadingStatus()));

      try {
        // لیست محلی را خالی می‌کنیم (اختیاری)
        StaticValues.staticProducts.clear();

        // ❗️ مهم: perPage را '10' بده (مثل لود اولیه)
        final dataState = await getProductsUseCase(
          InfParams(
            '10',
            false,
            '',
            false,
          ),
        );

        if (dataState is OrderDataSuccess) {
          // ⭐️ خیلی مهم: لیست را با دادهٔ جدید پر کن
          StaticValues.staticProducts = dataState.data!.cast<ProductEntity>();

          emit(state.copyWith(newProductsStatus: ProductsLoadedStatus()));
        } else {
          emit(state.copyWith(newProductsStatus: ProductsErrorStatus()));
        }
      } catch (e) {
        emit(state.copyWith(newProductsStatus: ProductsErrorStatus()));
      } finally {
        // ⭐️ همیشه complete کن تا RefreshIndicator بسته شود
        event.completer?.complete();
      }
    });
  }
}
