import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:shopyar/core/params/products_params.dart';
import 'package:shopyar/core/params/selected_products-params.dart';
import 'package:shopyar/core/utils/static_values.dart';
import 'package:shopyar/features/feature_add_edit_order/domain/entities/add_order_orders_entity.dart';
import 'package:shopyar/features/feature_add_edit_order/presentation/screens/product_form_screen.dart';
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
import 'package:stream_transform/stream_transform.dart';

part 'add_order_event.dart';

part 'add_order_state.dart';

class AddOrderBloc extends Bloc<AddOrderEvent, AddOrderState> {
  final AddOrderGetProductsUseCase getProductsUseCase;
  final AddOrderSetOrderUseCase addOrderSetOrderUseCase;

  AddOrderBloc(this.getProductsUseCase, this.addOrderSetOrderUseCase)
      : super(
    AddOrderState(
      addOrderStatus: AddOrderProductsLoadingStatus(),
      addOrderCardProductStatus: AddOrderChooseLoadingStatus(),
      addOrderSetOrderStatus: AddOrderSetOrderInitialStatus(),
      count: const {},
      isFirstTime: const {},
      visibleProducts: const [],
    ),
  ) {
    // --- Load products
    on<LoadAddOrderProductsData>((event, emit) async {
      if (StaticValues.staticProducts.isEmpty) {
        final dataState = await getProductsUseCase(ProductsParams('10', false, '', false));

        if (dataState is OrderDataSuccess) {
          StaticValues.staticProducts = dataState.data!.cast<ProductEntity>();
          final existing = Map<int, int>.unmodifiable(state.count);
          emit(
            state.copyWith(
              newAddOrderStatus: AddOrderProductsLoadedStatus(const {}, const {}),
              newAddOrderCardProductStatus: AddOrderCardProductLoaded(existing),
              newAddOrderSetOrderStatus: AddOrderSetOrderInitialStatus(),
              newVisibleProducts: StaticValues.staticProducts,
            ),
          );
        } else {
          emit(state.copyWith(newAddOrderStatus: AddOrderProductsErrorStatus()));
        }
      } else {
        final existing = Map<int, int>.unmodifiable(state.count);
        emit(
          state.copyWith(
            newAddOrderStatus: AddOrderProductsLoadedStatus(const {}, const {}),
            newAddOrderCardProductStatus: AddOrderCardProductLoaded(existing),
            newAddOrderSetOrderStatus: AddOrderSetOrderInitialStatus(),
            newVisibleProducts: StaticValues.staticProducts,
          ),
        );
      }
    });

    // --- Debounced search
    EventTransformer<E> debounce<E>(Duration d) => (events, mapper) => events.debounce(d).switchMap(mapper);
    String _norm(String? s) => (s ?? '').toLowerCase().replaceAll('ي', 'ی').replaceAll('ك', 'ک').trim();

    on<LoadOnChangedAddOrderProductsData>(
          (event, emit) {
        final q = _norm(event.query);
        if (q.isEmpty) {
          emit(state.copyWith(newVisibleProducts: StaticValues.staticProducts));
          return;
        }

        final results = StaticValues.staticProducts.where((p) {
          final name = _norm(p.name);
          final hitSelf = name.contains(q);

          final hitChild = (p.childes ?? const []).any((c) {
            final cn = _norm(c.name);
            final varName = _norm(c.variable);
            return cn.contains(q) || varName.contains(q);
          });

          return hitSelf || hitChild;
        }).toList();

        emit(state.copyWith(newVisibleProducts: results));
      },
      transformer: debounce(const Duration(milliseconds: 250)),
    );

    // --- Hydrate from order (EDIT)
    on<HydrateCartFromOrder>((event, emit) {
      final cart = <int, int>{};
      for (final li in event.order.lineItems ?? const <LineItem>[]) {
        final id = (li.variationId == null || li.variationId == 0)
            ? li.productId
            : li.variationId!;
        final qty = li.quantity ?? 0;
        if (id > 0 && qty > 0) {
          cart[id] = qty;
        }
      }
      _emitCart(emit, cart);
    });


    // --- Clear cart
    on<ClearCart>((event, emit) {
      const empty = <int, int>{};
      const emptyBool = <int, bool>{};
      emit(
        state.copyWith(
          newCount: empty,
          newAddOrderCardProductStatus:  AddOrderCardProductLoaded(empty),
          newAddOrderStatus:  AddOrderProductsLoadedStatus(empty, emptyBool),
        ),
      );
    });

    // --- Add product (+1)
    on<AddOrderAddProduct>((event, emit) {
      final mutable = _readCartSafe(state);
      final id = event.product.id!;
      mutable.update(id, (v) => v + 1, ifAbsent: () => 1);

      emit(state.copyWith(newAddOrderStatus: AddOrderProductsLoadingStatus()));
      _emitCart(emit, mutable);
    });


    // --- Decrease product (-1 / remove)
    on<DecreaseProductCount>((event, emit) {
      // cart مطمئن
      final mutable = _readCartSafe(state);

      // اگر variable داری، بهتره کلید درست را در خود event پاس بدهی:
      // final id = event.keyId ?? event.product.id!;
      final id = event.product.id!;

      final current = mutable[id] ?? 0;
      // اگر هنوز Hydrate نشده یا کلید اشتباهه، اصلاً دست نزن
      if (current == 0) {
        // دیباگ کمک‌کننده
        // print('[Decrease] key=$id not in cart (hydrate not done or wrong key)');
        return;
      }

      if (current > 1) {
        mutable[id] = current - 1;
      } else {
        // فقط وقتی current==1 حذف کن
        mutable.remove(id);
      }

      emit(state.copyWith(newAddOrderStatus: AddOrderProductsLoadingStatus()));
      _emitCart(emit, mutable);
    });

    // --- Submit order
    on<SetOrderEvent>((event, emit) async {
      emit(state.copyWith(newAddOrderStatus: AddOrderLoadingStatus()));
      final ok = await addOrderSetOrderUseCase(event.setOrderParams);
      if (ok) {
        emit(state.copyWith(newAddOrderStatus: AddOrderSuccessStatus()));
      } else {
        emit(state.copyWith(newAddOrderStatus: AddOrderErrorStatus()));
      }
    });

    // --- Set count directly (from a picker, etc.)
    on<addCurrentProducts>((event, emit) async {
      final loaded = state.addOrderStatus as AddOrderProductsLoadedStatus;
      final mutable = Map<int, int>.from(loaded.cart);

      if (event.count <= 0) {
        mutable.remove(event.product.id);
      } else {
        mutable[event.product.id!.toInt()] = event.count;
      }

      final ro = Map<int, int>.unmodifiable(mutable);
      emit(state.copyWith(newCount: ro));
      emit(
        state.copyWith(
          newAddOrderCardProductStatus: AddOrderCardProductLoaded(ro),
          newAddOrderStatus: AddOrderProductsLoadedStatus(ro, const {}),
        ),
      );
    });
  }
  Map<int,int> _readCartSafe(AddOrderState s) {
    // اولویت با state.count
    if (s.count.isNotEmpty) return Map<int,int>.from(s.count);

    // بعد CardProductStatus
    if (s.addOrderCardProductStatus is AddOrderCardProductLoaded) {
      final m = (s.addOrderCardProductStatus as AddOrderCardProductLoaded).cart;
      if (m.isNotEmpty) return Map<int,int>.from(m);
    }

    // بعد ProductsLoadedStatus
    if (s.addOrderStatus is AddOrderProductsLoadedStatus) {
      final m = (s.addOrderStatus as AddOrderProductsLoadedStatus).cart;
      if (m.isNotEmpty) return Map<int,int>.from(m);
    }

    return <int,int>{};
  }

  void _emitCart(Emitter<AddOrderState> emit, Map<int,int> mutable) {
    final ro = Map<int,int>.unmodifiable(mutable);
    emit(state.copyWith(
      newCount: ro,
      newAddOrderCardProductStatus: AddOrderCardProductLoaded(ro),
      newAddOrderStatus: AddOrderProductsLoadedStatus(ro, const {}),
    ));
  }

}
