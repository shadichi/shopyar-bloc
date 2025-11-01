import '../../../../core/resources/add_product_data_state.dart';
import '../../../../core/resources/order_data_state.dart';
import '../../../feature_add_edit_order/data/data_source/remote/add_order_products_api_provider.dart';
import '../../domain/repository/add_product_repository.dart';
import 'package:dio/dio.dart';

import '../data_source/remote/add_order_products_api_provider.dart';

class AddProductRepositoryImpl extends AddProductRepository {
  AddProductsGetDataApiProvider apiProvider;

  AddProductRepositoryImpl(this.apiProvider);

  @override
  Future<AddProductDataState> getProductData() async {
    try {
      Response response = await apiProvider.getData();
      if (response.statusCode == 200) {
       /* List<ProductEntity> editOrderProductEntity =
        productsFromJson(response.data);*/

        return AddProductDataSuccess(response.data);
      } else {
        return const AddProductDataFailed("Something Went Wrong. try again...");
      }
    } catch (e) {
      print(e.toString());
      return const AddProductDataFailed("please check your connection...");
    }
  }

  @override
  Future<OrderDataState> uploadImages() async {
    try {
      Response response = await apiProvider.getData();
      if (response.statusCode == 200) {
        /* List<ProductEntity> editOrderProductEntity =
        productsFromJson(response.data);*/

        return OrderDataSuccess([]);
      } else {
        return const OrderDataFailed("Something Went Wrong. try again...");
      }
    } catch (e) {
      print(e.toString());
      return const OrderDataFailed("please check your connection...");
    }
  }

}
