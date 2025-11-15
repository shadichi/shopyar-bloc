import '../../../../core/resources/add_product_data_state.dart';
import '../../../../core/resources/order_data_state.dart';
import '../../../feature_add_edit_order/data/data_source/remote/add_order_products_api_provider.dart';
import '../../domain/repository/add_product_repository.dart';
import 'package:dio/dio.dart';

import '../data_source/remote/add_order_products_api_provider.dart';
import '../models/product_submit_model.dart';

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
  Future<AddProductDataState> submitProduct(ProductSubmitModel model) async {
    try {

      Response response = await apiProvider.submitProduct(model);
      if (response.statusCode == 200) {
         print("response for submit product is 200:");
         print(response.data);

        return AddProductDataSuccess([]);
      } else {
        return const AddProductDataFailed("AddProductDataFailed");
      }
    } catch (e) {
      print('error in submitProductImpl:');
      print(e.toString());
      return const AddProductDataFailed("AddProductDataFailed");
    }
  }

}
