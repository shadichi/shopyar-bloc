import 'package:shopyar/core/params/products_params.dart';
import 'package:dio/dio.dart';
import 'package:shopyar/core/utils/static_values.dart';
import 'package:shopyar/features/feature_add_edit_order/data/models/add_order_orders_model.dart';
import 'package:shopyar/features/feature_products/domain/entities/product_entity.dart';
import '../../../../core/params/add_order_get_selected_products_params.dart';
import '../../../../core/params/add_order_products_card.dart';
import '../../../../core/params/setOrderPArams.dart';
import '../../../../core/resources/order_data_state.dart';
import '../../../feature_products/data/models/product_model.dart';
import '../../domain/entities/add_order_orders_entity.dart';
import '../../domain/repository/add_order_repository.dart';
import '../data_source/remote/add_order_products_api_provider.dart';

class AddOrderRepositoryImpl extends AddOrderRepository {
  AddOrderProductsApiProvider apiProvider;

  AddOrderRepositoryImpl(this.apiProvider);

  @override
  Future<OrderDataState<ProductEntity>> getOrderProducts(
      InfParams productsParams) async {
    try {
      Response response = await apiProvider.getOrderProducts(productsParams);

      if (response.statusCode == 200) {
        List<ProductEntity> editOrderProductEntity =
            productsFromJson(response.data);
        return OrderDataSuccess(editOrderProductEntity);
      } else {
        return const OrderDataFailed("Something Went Wrong. try again...");
      }
    } catch (e) {
      print(e.toString());
      return const OrderDataFailed("please check your connection...");
    }
  }

  @override
  Future<AddOrderProductsCard<AddOrderOrdersEntity>> getSelectedProducts(
      AddOrderGetSelectedProductsParams
          editOrderGetSelectedProductsParams) async {
    final selectedProducts = editOrderGetSelectedProductsParams.products
        .where((product) =>
            product.id == editOrderGetSelectedProductsParams.selected)
        .toList();

    LineItem lineItem = LineItem(
        name: selectedProducts[0].name,
        productId: selectedProducts[0].id,
        quantity: editOrderGetSelectedProductsParams.selected.productQuantity,
        total: selectedProducts[0].price);

    editOrderGetSelectedProductsParams.addOrderOrdersEntity.lineItems!
        .add(lineItem);

    if (editOrderGetSelectedProductsParams.selected.productId != 0) {
      return AddOrderProductsChanged(
          editOrderGetSelectedProductsParams.addOrderOrdersEntity);
    }
    if (editOrderGetSelectedProductsParams.selected.productId == 0) {
      return AddOrderProductsRemoved(
          editOrderGetSelectedProductsParams.addOrderOrdersEntity);
    } else {
      return AddOrderProductsCardFailed("failed");
    }
  }

  @override
  Future<bool> AddOrderSetOrder(SetOrderParams setOrderParams) async {
    try {
      var response = await apiProvider.setOrder(
          setOrderParams.order,
          StaticValues.webService,
          StaticValues.passWord,
          setOrderParams.payType,
          setOrderParams.shipType,
          setOrderParams.shipPrice);
      var connection = false;

      if (response) {
        connection = true;

        return connection;
      } else {
        return connection;
      }
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  @override
  Future<OrderDataState<ProductEntity>> AddOrderSearchedProduct(List searchProducts) async {
    try {
      Response response = await apiProvider.getSearchedProductsApi(searchProducts);

      if (response.statusCode == 200) {
        List<ProductEntity> editOrderProductEntity =
        productsFromJson(response.data);
        return OrderDataSuccess(editOrderProductEntity);
      } else {
        return const OrderDataFailed("Something Went Wrong. try again...");
      }
    } catch (e) {
      print(e.toString());
      return const OrderDataFailed("please check your connection...");
    }
  }

}
