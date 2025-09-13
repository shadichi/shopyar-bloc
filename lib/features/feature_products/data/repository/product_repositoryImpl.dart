import 'package:shapyar_bloc/core/params/products_params.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'package:shapyar_bloc/core/utils/static_values.dart';
import 'package:shapyar_bloc/features/feature_products/domain/entities/product_entity.dart';
import '../../../../core/params/home_user_data_params.dart';
import '../../../../core/resources/order_data_state.dart';
import '../../domain/repository/product_repository.dart';
import '../data_source/remote/products_api_provider.dart';
import '../models/product_model.dart';

class ProductRepositoryImpl extends ProductRepository{
  ProductsApiProvider apiProvider;
  ProductRepositoryImpl(this.apiProvider);

  @override
  Future<ProductsParams> getString() async {
    if(StaticValues.webService == '' && StaticValues.passWord == ''){
      final prefs = await SharedPreferences.getInstance();
      final webService = prefs.getString("webService");
      final passWord = prefs.getString("passWord");
      StaticValues.webService = webService.toString();
      StaticValues.passWord = passWord.toString();
      if(webService == null || passWord == null){
        return ProductsParams('10',false,'',false);
      }

      return ProductsParams('10',false, '',false);
    }
    else{
      return ProductsParams('10',false, '',false);
    }

  }

  @override
  Future<OrderDataState<ProductEntity>> getProducts(ProductsParams productsParams) async{

    try{
      Response response = await apiProvider.GetProducts(productsParams);

      if (response.statusCode == 200) {
        print('response.statusCode');
        print(response.statusCode);
        List<ProductEntity> productEntity = productsFromJson(response.data);

        return OrderDataSuccess(productEntity);
      }else{
        return const OrderDataFailed("Something Went Wrong. try again...");

      }
    }catch (e){
      print(e.toString());
      return const OrderDataFailed("please check your connection...");

    }


}}
