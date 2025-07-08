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
      : super(OrdersState(ordersStatus: OrdersLoadingStatus(), showFilter: false, editStatus: EditOrderInitialStatus())) {
    on<OrdersEvent>((event, emit) {
      // TODO: implement event handler
    });
    on<LoadOrdersData>((event, emit) async {


      if (StaticValues.staticOrders.isEmpty || event.isSearch || event.isFilter) {
        print('1');
        if(event.isSearch || event.isFilter){
          StaticValues.staticOrders.clear();
          emit(state.copyWith(
              newOrdersStatus: OrdersLoadingStatus()));
        }
        if(event.isSearch && StaticValues.staticOrders.isEmpty){

          emit(state.copyWith(
              newOrdersStatus: OrdersSearchFailedStatus()));

        }
        if(event.isFilter && StaticValues.staticOrders.isEmpty){

          emit(state.copyWith(
              newOrdersStatus: OrdersSearchFailedStatus()));

        }
        if (StaticValues.webService != '' ||
            StaticValues.passWord != '' ||
            StaticValues.shopName.isNotEmpty ||
            StaticValues.shippingMethods.isNotEmpty ||
            StaticValues.paymentMethods.isNotEmpty ||
            StaticValues.status.isNotEmpty) {
          emit(state.copyWith(
              newOrdersStatus: OrdersLoadingStatus()));
          String perPage='10';
          if(event.perPage.isNotEmpty){
            perPage=event.perPage;
          }
          OrderDataState dataState =
              await getOrdersUseCase(OrdersParams(10, "", {}, event.search, perPage, event.status));
          StaticValues.staticOrders = dataState.data!.cast<OrdersEntity>();
          print('StaticValues.staticOrders');
          print(StaticValues.staticOrders);

          if (dataState is OrderDataSuccess) {
            try {
              print("OrdersLoadedStatus");
              emit(state.copyWith(
                  newOrdersStatus: OrdersLoadedStatus()));
              print(state.ordersStatus);
            } catch (error) {
              print("OrdersErrorStatus");
              emit(state.copyWith(newOrdersStatus: OrdersErrorStatus()));
            }
          } else {
            emit(state.copyWith(newOrdersStatus: OrdersErrorStatus()));
          }
        } else {
          emit(state.copyWith(newOrdersStatus: UserErrorStatus()));
        }
      } else {
        print('2');
        emit(state.copyWith(
            newOrdersStatus: OrdersLoadedStatus()));
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
