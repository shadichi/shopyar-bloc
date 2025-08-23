import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:shapyar_bloc/core/params/products_params.dart';
import 'package:shapyar_bloc/core/params/selected_products-params.dart';
import 'package:shapyar_bloc/core/utils/static_values.dart';
import 'package:shapyar_bloc/features/feature_add_edit_order/domain/entities/add_order_orders_entity.dart';
import 'package:shapyar_bloc/features/feature_add_edit_order/presentation/screens/product_form_screen.dart';
import '../../../../core/params/add_order_data_state.dart';
import '../../../../core/params/home_user_data_params.dart';
import '../../../../core/params/setOrderPArams.dart';
import '../../../../core/resources/order_data_state.dart';
import '../../../feature_orders/data/models/orders_model.dart';
import '../../../feature_orders/domain/entities/orders_entity.dart';
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
            ProductsParams('10',false,''));

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


    on<HydrateCartFromOrder>((event, emit) {
      final cart = <int,int>{};
      for (final li in event.order.lineItems ?? const <LineItem>[]) {
        final id = (li.variationId == null || li.variationId == 0)
            ? li.productId
            : li.variationId!;
        if (id != null && li.quantity != null) {
          cart[id] = li.quantity!;
        }
      }

      // رفرنس‌های جدید بساز
      final newCart = Map<int,int>.from(cart);

      emit(state.copyWith(
        newCount: Map.unmodifiable(newCart),
        newAddOrderCardProductStatus: AddOrderCardProductLoaded(Map.unmodifiable(newCart)),
        newAddOrderStatus: AddOrderProductsLoadedStatus(Map.unmodifiable(newCart), const {}),
      ));
    });

    on<ClearCart>((event, emit) {
      const empty = <int,int>{};

      emit(state.copyWith(
        newCount: const {},
        newAddOrderCardProductStatus: AddOrderCardProductLoaded(const {}),
        newAddOrderStatus: AddOrderProductsLoadedStatus(const {}, const {}),
      ));
    });



    on<AddOrderAddProduct>((event, emit) async {

      AddOrderProductsLoadedStatus addOrderProductsLoadedStatus =
      state.addOrderStatus as AddOrderProductsLoadedStatus;
      final loadedState = addOrderProductsLoadedStatus;
      final cart = loadedState.cart;
      cart[event.product.id!.toInt()] =
          (cart[event.product.id!.toInt()] ?? 0) + 1;

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

      if (cart[event.product.id!.toInt()] != null &&
          cart[event.product.id!.toInt()]! > 0) {
        cart[event.product.id!.toInt()] = cart[event.product.id!.toInt()]! - 1;
        if(cart[event.product.id!.toInt()] == 0){
          cart.remove(event.product.id!.toInt());
        }
      }
      emit(
          state.copyWith(newAddOrderStatus: AddOrderProductsLoadingStatus()));
      emit(state.copyWith(
          newAddOrderCardProductStatus: AddOrderCardProductLoaded( cart),
          newAddOrderStatus: AddOrderProductsLoadedStatus( cart, {})));
    });

    on<SetOrderEvent>((event, emit) async {
      emit(state.copyWith(
          newAddOrderStatus: AddOrderLoadingStatus()));
      bool dataState = await addOrderSetOrderUseCase(event.setOrderParams);
      print(dataState);
      print(state);

      if (dataState == true || dataState) {
        emit(state.copyWith(
            newAddOrderStatus: AddOrderSuccessStatus()));
      }
      if (!dataState) {
        emit(state.copyWith(
            newAddOrderStatus: AddOrderErrorStatus()));
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

    Map<int, int> cartFromLineItems(List<LineItem> items) {
      final cart = <int, int>{};
      for (final li in items) {
        final key = (li.variationId != null && li.variationId! > 0)
            ? li.variationId!
            : (li.productId ?? 0);
        if (key == 0) continue;

        final qty = li.quantity ?? 0;
        if (qty <= 0) continue;

        cart.update(key, (old) => old + qty, ifAbsent: () => qty);
      }
      return cart;
    }


  /*  on<addLineItemProducts>((event, emit) async {

      if(event.productFormMode == ProductFormMode.create){
        emit(state.copyWith(
            newCount: {}));
        return;
      }else{
        Map<int, int> makeCart = {};

        for(final m in event.lineItem){
          makeCart[m.id!.toInt()] = m.quantity;
        }

        emit(state.copyWith(
            newCount: makeCart));
        print('makeCart');
        print(makeCart);
      }

    });*/

  }

}/*List<TextEditingController> textEditing = [
  step1CustomerFNBill,
  step1CustomerLNBill,
  step1AddressBill,
  step1CityBill,
  step1PostalCodeBill,
  step1EmailBill,
  step1PhoneBill,
  step1ShipPrice,
]
;


TextEditingController step1CustomerFNBill = TextEditingController();
TextEditingController step1CustomerLNBill = TextEditingController();
TextEditingController step1AddressBill = TextEditingController();
TextEditingController step1CityBill = TextEditingController();
TextEditingController step1PostalCodeBill = TextEditingController();
TextEditingController step1EmailBill = TextEditingController();
TextEditingController step1PhoneBill = TextEditingController();
TextEditingController step1ShipPrice = TextEditingController();*/
