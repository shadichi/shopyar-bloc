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

      // برای سرچ/فیلتر: لیست رو خالی و لودینگ صفحه‌ای
      if (event.isSearch || event.isFilter) {
        StaticValues.staticOrders.clear();
        emit(state.copyWith(newOrdersStatus: OrdersLoadingStatus()));
      }

      // 👇 شروع لود بیشتر: فقط فلگ دکمه رو روشن کن، نه لودینگ کل صفحه
      if (event.isLoadMore) {
        emit(state.copyWith(newIsLoadingMore: true));
      } else if (isInitial) {
        emit(state.copyWith(newOrdersStatus: OrdersLoadingStatus()));
      }

      try {
        // perPage محاسبه
        String perPage = '10';
        if (event.perPage.isNotEmpty) perPage = event.perPage;

        // فراخوانی
        final dataState = await getOrdersUseCase(
          OrdersParams(10, "", {}, event.search, perPage, event.status),
        );

        if (dataState is OrderDataSuccess) {
          final fetched = dataState.data!.cast<OrdersEntity>();

          // 👇 اگر isLoadMore داری و API صفحه‌بندی‌ات «تجمعی» نیست،
          // یا append کن یا کل لیست رو با fetched جایگزین کن. پیشنهاد:
          if (event.isLoadMore && StaticValues.staticOrders.isNotEmpty) {
            // اگر API فقط همون perPage آخر رو می‌ده، این خط گزینه امن‌تره:
            StaticValues.staticOrders = fetched;
            // یا اگر API واقعاً «صفحه بعدی» رو می‌ده، از این استفاده کن:
            // StaticValues.staticOrders.addAll(fetched);
          } else {
            StaticValues.staticOrders = fetched;
          }

          // حالت صفحه: Loaded باقی بمونه
          emit(state.copyWith(newOrdersStatus: OrdersLoadedStatus()));
        } else {
          emit(state.copyWith(newOrdersStatus: OrdersErrorStatus()));
        }
      } catch (_) {
        emit(state.copyWith(newOrdersStatus: OrdersErrorStatus()));
      } finally {
        // 👇 حتماً خاموش کن تا دکمه از لودینگ خارج شه
        if (event.isLoadMore) {
          emit(state.copyWith(newIsLoadingMore: false));
        }
      }
    });

    on<RefreshOrdersData>((event, emit) async {
      emit(state.copyWith(newOrdersStatus: OrdersLoadingStatus()));
      OrderDataState dataState =
          await getOrdersUseCase(OrdersParams(10, "", {}, '','',''));
      if (dataState is OrderDataSuccess) {
        try {
          print("OrdersLoadedStatus");
          emit(state.copyWith(
              newOrdersStatus:
                  OrdersLoadedStatus()));
        } catch (error) {
          print("OrdersErrorStatus");
          emit(state.copyWith(newOrdersStatus: OrdersErrorStatus()));
        }
      }
    });

    on<ShowFilter>((event, emit) async {
      event.showFilter = !event.showFilter;

      emit(state.copyWith(newShowFilter: event.showFilter));

    });

    on<ShowFilterOff>((event, emit) async {
      event.showFilter = false;

      emit(state.copyWith(newShowFilter: event.showFilter));

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
        } catch (error) {
          emit(state.copyWith(newEditStatus: EditOrderFailedStatus()));
        }
      }else{
        emit(state.copyWith(newEditStatus: EditOrderFailedStatus()));
      }


    });
  }
}
