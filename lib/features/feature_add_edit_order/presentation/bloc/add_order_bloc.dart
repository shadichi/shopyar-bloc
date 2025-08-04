import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:shapyar_bloc/core/params/products_params.dart';
import 'package:shapyar_bloc/core/params/selected_products-params.dart';
import 'package:shapyar_bloc/core/utils/static_values.dart';
import 'package:shapyar_bloc/features/feature_add_edit_order/domain/entities/add_order_orders_entity.dart';
import '../../../../core/params/add_order_data_state.dart';
import '../../../../core/params/home_user_data_params.dart';
import '../../../../core/params/setOrderPArams.dart';
import '../../../../core/resources/order_data_state.dart';
import '../../../feature_products/domain/entities/product_entity.dart';
import '../../domain/entities/add_order_data_entity.dart';
import '../../domain/entities/add_order_product_entity.dart';
import '../../domain/use_cases/add_order_get_products_use_case.dart';
import '../../domain/use_cases/add_order_set_order_use_case.dart';
import '../../domain/use_cases/add_order_get_selected_products_use_case.dart';
import 'add_order_card_product_status.dart';
import 'add_order_set_order_status.dart';
import 'add_order_status.dart';

part 'add_order_event.dart';

part 'add_order_state.dart';

class AddOrderBloc extends Bloc<AddOrderEvent, AddOrderState> {
  final AddOrderGetProductsUseCase getProductsUseCase;
  final AddOrderGetSelectedProductsUseCase addOrderGetSelectedProductsUseCase;
  final AddOrderSetOrderUseCase addOrderSetOrderUseCase;

  //final GetOrdersUseCase getOrdersUseCase;

  AddOrderBloc(this.getProductsUseCase,
      this.addOrderGetSelectedProductsUseCase, this.addOrderSetOrderUseCase)
      : super(
          AddOrderState(
              addOrderStatus: AddOrderProductsLoadingStatus(),
              addOrderCardProductStatus: AddOrderChooseLoadingStatus(),
              addOrderSetOrderStatus: AddOrderSetOrderInitialStatus(),count: {},isFirstTime: {}),
        ) {
    on<AddOrderEvent>((event, emit) {
      // TODO: implement event handler
    });

    on<LoadAddOrderProductsData>((event, emit) async {
      if(StaticValues.staticProducts.isEmpty){
        OrderDataState dataState = await getProductsUseCase(
            ProductsParams(10,false,''));

        if (dataState is OrderDataSuccess) {

          emit(state.copyWith(
              newAddOrderStatus: AddOrderProductsLoadedStatus({}, {}),
              newAddOrderCardProductStatus: AddOrderCardProductLoaded( {}),
              newAddOrderSetOrderStatus: AddOrderSetOrderInitialStatus()));
          StaticValues.staticProducts = dataState.data!.cast<ProductEntity>();

        }

        if (dataState is OrderDataFailed) {
          emit(
              state.copyWith(newAddOrderStatus: AddOrderProductsErrorStatus()));
        }
      }else{
        emit(state.copyWith(
            newAddOrderStatus: AddOrderProductsLoadedStatus({}, {}),
            newAddOrderCardProductStatus: AddOrderCardProductLoaded( {}),
            newAddOrderSetOrderStatus: AddOrderSetOrderInitialStatus()));
      }
    });

    on<AddOrderAddProduct>((event, emit) async {

      AddOrderProductsLoadedStatus addOrderProductsLoadedStatus =
          state.addOrderStatus as AddOrderProductsLoadedStatus;
      final loadedState = addOrderProductsLoadedStatus;
      final cart = loadedState.cart;
      cart[event.product.id!.toInt()] =
          (cart[event.product.id!.toInt()] ?? 0) + 1;

      print('fsdfsdfsdfsddsfsfsdfsvbsfdgv');
      print(cart[event.product.id!.toInt()]);
      print('object');
      print(cart);
      print('cart');

      emit(
          state.copyWith(newCount: cart));
      emit(
          state.copyWith(newAddOrderStatus: AddOrderProductsLoadingStatus()));
      emit(
          state.copyWith( newAddOrderCardProductStatus: AddOrderChooseLoadingStatus()));
      emit(state.copyWith(
          newAddOrderCardProductStatus: AddOrderCardProductLoaded( cart),

          newAddOrderStatus: AddOrderProductsLoadedStatus(cart, {})));
    });

    on<DecreaseProductCount>((event, emit) async {
      AddOrderProductsLoadedStatus addOrderProductsLoadedStatus =
          state.addOrderStatus as AddOrderProductsLoadedStatus;
      final loadedState = addOrderProductsLoadedStatus;
      final cart = loadedState.cart;
      print(loadedState);

      if (cart[event.product.id!.toInt()] != null &&
          cart[event.product.id!.toInt()]! > 0) {
        cart[event.product.id!.toInt()] = cart[event.product.id!.toInt()]! - 1;
      }
     /* if(cart[event.product.id!.toInt()]! == 0){
        cart.remove(event.product.id!.toInt());
      }*/
      emit(
          state.copyWith(newAddOrderStatus: AddOrderProductsLoadingStatus()));
      emit(state.copyWith(
          newAddOrderCardProductStatus: AddOrderCardProductLoaded( cart),
          newAddOrderStatus: AddOrderProductsLoadedStatus( cart, {})));
    });

    on<SetOrder>((event, emit) async {
    /*  AddOrderProductsLoadedStatus addOrderProductsLoadedStatus =
      state.addOrderStatus as AddOrderProductsLoadedStatus;
      final loadedState = addOrderProductsLoadedStatus;
      final cart = loadedState.cart;
      print(cart);*/
      emit(state.copyWith(
          newAddOrderSetOrderStatus: AddOrderSetOrderLoadingStatus()));
      bool dataState = await addOrderSetOrderUseCase(event.setOrderParams);
      print(dataState);
      print(state);

      if (dataState == true || dataState) {
        emit(state.copyWith(
            newAddOrderSetOrderStatus: AddOrderSetOrderSuccess()));
      }
      if (!dataState) {
        emit(state.copyWith(
            newAddOrderSetOrderStatus: AddOrderSetOrderFailed()));
      }
    });

    on<addCurrentProducts>((event, emit) async {
      AddOrderProductsLoadedStatus addOrderProductsLoadedStatus =
      state.addOrderStatus as AddOrderProductsLoadedStatus;
      final loadedState = addOrderProductsLoadedStatus;
      final cart = loadedState.cart;
      cart[event.product.id!.toInt()] =event.count;
      emit(state.copyWith(
          newCount: cart));
    });
  }
}
