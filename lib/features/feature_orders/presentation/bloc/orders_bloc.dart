import 'dart:async';
import 'package:equatable/equatable.dart';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:shapyar_bloc/features/feature_orders/domain/entities/orders_entity.dart';
import 'package:shapyar_bloc/features/feature_orders/domain/use_cases/get_orders_use_case.dart';
import 'package:shapyar_bloc/features/feature_orders/presentation/bloc/orders_status.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/params/orders_edit_status.dart';
import '../../../../core/params/orders_params.dart';
import '../../../../core/resources/data_state.dart';
import '../../../../core/resources/order_data_state.dart';
import '../../../../core/utils/static_values.dart';
import '../../domain/use_cases/edit_status_orders_use_case.dart';

part 'orders_event.dart';

part 'orders_state.dart';

class OrdersBloc extends Bloc<OrdersEvent, OrdersState> {
  final GetOrdersUseCase getOrdersUseCase;
  final EditOrdersStatusUseCase editOrdersStatusUseCase;

  OrdersBloc(this.getOrdersUseCase, this.editOrdersStatusUseCase)
      : super(OrdersState(ordersStatus: OrdersLoadingStatus(), showFilter: false, editStatus: EditOrderInitialStatus(), isLoadingMore: false)) {
    on<OrdersEvent>((event, emit) {
      // TODO: implement event handler
    });
    on<LoadOrdersData>((event, emit) async {
      final isInitial = StaticValues.staticOrders.isEmpty && !event.isLoadMore;

      // اگر سرچ یا فیلتره، لیست رو صفر کن و لودینگ تمام‌صفحه بده
      if (event.isSearch || event.isFilter) {
        StaticValues.staticOrders.clear();
        emit(state.copyWith(newOrdersStatus: OrdersLoadingStatus()));
      }

      // اگر load more هست فقط فلگ دکمه رو روشن کن
      if (event.isLoadMore) {
        emit(state.copyWith(newIsLoadingMore: true));
      } else if (isInitial) {
        emit(state.copyWith(newOrdersStatus: OrdersLoadingStatus()));
      }

      try {
        // perPage
        String perPage = '10';
        if (event.perPage.isNotEmpty) perPage = event.perPage;

        final dataState = await getOrdersUseCase(
          OrdersParams(
            10,          // page یا offset اگر داری، اینجا تنظیم کن (الان ثابت گذاشتی)
            "",          // query
            {},          // فیلترها
            event.search, // متن سرچ
            perPage,
            event.status,
          ),
        );

        if (dataState is OrderDataSuccess) {
          final fetched = dataState.data!.cast<OrdersEntity>();

          // چون دکمه Load More توی UI تعداد perPage رو زیاد می‌کنه،
          // منطقیه کل لیست رو با fetched جایگزین کنیم (تجمعی).
          StaticValues.staticOrders = fetched;

          emit(state.copyWith(newOrdersStatus: OrdersLoadedStatus()));
        } else {
          emit(state.copyWith(newOrdersStatus: OrdersErrorStatus()));
        }
      } catch (_) {
        emit(state.copyWith(newOrdersStatus: OrdersErrorStatus()));
      } finally {
        // خاموش کردن لودینگ load more
        if (event.isLoadMore) {
          emit(state.copyWith(newIsLoadingMore: false));
        }
      }
    });


    on<RefreshOrdersData>((event, emit) async {
      // اختیاری: دوست داری حین رفرش اسپینر هم داشته باشی
      emit(state.copyWith(newOrdersStatus: OrdersLoadingStatus()));

      try {
        // لیست محلی را خالی می‌کنیم (اختیاری)
        StaticValues.staticOrders.clear();

        // ❗️ مهم: perPage را '10' بده (مثل لود اولیه)
        final dataState = await getOrdersUseCase(
          OrdersParams(10, "", {}, /*search*/ '', /*perPage*/ '10', /*status*/ ''),
        );

        if (dataState is OrderDataSuccess) {
          // ⭐️ خیلی مهم: لیست را با دادهٔ جدید پر کن
          StaticValues.staticOrders = dataState.data!.cast<OrdersEntity>();

          emit(state.copyWith(newOrdersStatus: OrdersLoadedStatus()));
        } else {
          emit(state.copyWith(newOrdersStatus: OrdersErrorStatus()));
        }
      } catch (e) {
        emit(state.copyWith(newOrdersStatus: OrdersErrorStatus()));
      } finally {
        // ⭐️ همیشه complete کن تا RefreshIndicator بسته شود
        event.completer?.complete();
      }
    });



    on<ShowFilter>((event, emit) async {
      // به جای تغییر event، از state بخون و برعکسش کن
      emit(state.copyWith(newShowFilter: !state.showFilter));
    });

    on<ShowFilterOff>((event, emit) async {
      emit(state.copyWith(newShowFilter: false));
    });

    on<EditStatus>((event, emit) async {

      emit(state.copyWith(newEditStatus: EditOrderLoadingStatus()));
      DataState dataState =
      await editOrdersStatusUseCase(OrdersEditStatus(event.ordersEditStatus.orderId, event.ordersEditStatus.status));
      if (dataState is DataSuccess) {
        ;
        try {

          emit(state.copyWith(
              newEditStatus:
              EditOrderSuccessStatus()));
          emit(state.copyWith(
              newEditStatus:
              EditOrderInitialStatus()));

        } catch (error) {
          emit(state.copyWith(newEditStatus: EditOrderFailedStatus()));
        }
      }else{
        emit(state.copyWith(newEditStatus: EditOrderFailedStatus()));
      }


    });
  }
}
