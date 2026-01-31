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
import '../../domain/use_cases/add_order_searched_products_use_case.dart';
import '../../domain/use_cases/add_order_set_order_use_case.dart';
import '../../domain/use_cases/add_order_get_selected_products_use_case.dart';
import 'add_order_card_product_status.dart';
import 'add_order_set_order_status.dart';
import 'add_order_status.dart';
import 'package:collection/collection.dart';


part 'add_order_event.dart';

part 'add_order_state.dart';

class AddOrderBloc extends Bloc<AddOrderEvent, AddOrderState> {
  final AddProductGetDataUseCase getProductsUseCase;
  final AddOrderSetOrderUseCase addOrderSetOrderUseCase;
  final AddProductSearchedDataUseCase addProductSearchedDataUseCase;


  AddOrderBloc(this.getProductsUseCase, this.addOrderSetOrderUseCase, this.addProductSearchedDataUseCase)
      : super(
    AddOrderState(
      addOrderStatus: AddOrderProductsLoadingStatus(),
      addOrderCardProductStatus: AddOrderChooseLoadingStatus(),
      addOrderSetOrderStatus: AddOrderSetOrderInitialStatus(),
      count: const {},
      isFirstTime: const {},
      visibleProducts: const [],
      isLoadingMore: false, isSearching:false, isRemoteResult: false
    ),
  ) {

    int _searchToken = 0;

    // --- Load products
    on<LoadAddOrderProductsData>((event, emit) async {
      print('event.productsParams.isLoadMore');
      print(event.productsParams.isLoadMore);
      if (event.productsParams.isLoadMore) {
        emit(state.copyWith(newIsLoadingMore: true));
      }
      if (StaticValues.staticProducts.isEmpty || event.productsParams.isLoadMore) {
        final dataState = await getProductsUseCase(InfParams(event.productsParams.productCount, false, '', false));

        print("dataState");
        print(dataState);
        print(dataState.data);


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
      if (event.productsParams.isLoadMore) {
        emit(state.copyWith(newIsLoadingMore: false));
      }
    });

    // --- Debounced search
    String _norm(String? s) => (s ?? '').toLowerCase().replaceAll('ي', 'ی').replaceAll('ك', 'ک').trim();

    /// ===== Helpers =====

    bool _isIdSearch(String q) =>
        RegExp(r'^(\d+)(,\d+)*$').hasMatch(q);

    List<ProductEntity> _localSearch(String q) {
      print("localsearchhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh");
      return StaticValues.staticProducts.where((p) {
        final hitSelf = _norm(p.name).contains(q);

        final hitChild = (p.childes ?? []).any((c) =>
        _norm(c.name).contains(q) ||
            _norm(c.variable).contains(q));

        print(hitChild);
        print(hitSelf);

        return hitSelf || hitChild;
      }).toList();
    }

    Future<List<ProductEntity>> _fakeApiSearch() async {
      await Future.delayed(const Duration(milliseconds: 600));
      return [];
    }

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
    Future<void> _onSearchChanged(
        LoadOnChangedAddOrderProductsData event,
        Emitter<AddOrderState> emit,
        ) async {
      final int token = ++_searchToken;

      // debounce
      await Future.delayed(const Duration(milliseconds: 350));
      if (token != _searchToken || emit.isDone) return;

      final q = _norm(event.query);

      final cart = (state.addOrderCardProductStatus is AddOrderCardProductLoaded)
          ? (state.addOrderCardProductStatus as AddOrderCardProductLoaded).cart
          : <int,int>{};

      // سرچ خالی
      if (q.isEmpty) {
        // 1️⃣ محصولات انتخاب شده (cart)
        final selectedProducts = cart.keys.map((id) {
          return state.apiSearchedProducts
              .firstWhereOrNull((p) => p.id == id) ??
              StaticValues.staticProducts.firstWhereOrNull((p) => p.id == id);
        }).whereType<ProductEntity>().toList();

        // 2️⃣ بقیه محصولات استاتیک که انتخاب نشده‌اند
        final remainingProducts = StaticValues.staticProducts
            .where((p) => !selectedProducts.any((c) => c.id == p.id))
            .toList();

        final merged = [...selectedProducts, ...remainingProducts];

        emit(state.copyWith(
          newVisibleProducts: merged,
          newIsSearching: false,
          newIsRemoteResult: false,
        ));
        return;
      }

      // سرچ لوکال
      final localResults = _localSearch(q);

      // سرچ API
      emit(state.copyWith(newIsSearching: true));

      final dataState = await addProductSearchedDataUseCase(q);
      if (emit.isDone) return;

      final apiResults = (dataState is OrderDataSuccess && dataState.data != null)
          ? dataState.data!.cast<ProductEntity>()
          : <ProductEntity>[];

      // merge لوکال + API بدون تکرار
      final combined = [
        ...localResults,
        ...apiResults.where(
                (apiProd) => !localResults.any((localProd) => localProd.id == apiProd.id))
      ];

      emit(state.copyWith(
        newVisibleProducts: combined,
        newApiSearchedProducts: apiResults,
        newIsSearching: false,
        newIsRemoteResult: true,
      ));
    }



    on<LoadOnChangedAddOrderProductsData>(_onSearchChanged);

    @override
    Future<void> close() {
      return super.close();
    }
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
