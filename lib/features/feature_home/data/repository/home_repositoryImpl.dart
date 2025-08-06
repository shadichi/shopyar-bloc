import 'dart:convert';

import 'package:shapyar_bloc/core/resources/data_state.dart';
import 'package:shapyar_bloc/features/feature_home/domain/entities/home_data_entity.dart';
import 'package:shapyar_bloc/features/feature_home/domain/entities/orders_entity.dart';
import 'package:shapyar_bloc/features/feature_home/domain/repository/home_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import '../../../../core/params/home_user_data_params.dart';
import '../../../../core/params/orders_params.dart';
import '../../../../core/params/whole_user_data_params.dart';
import '../../../../core/resources/order_data_state.dart';
import '../data_source/remote/home_api_provider.dart';
import '../models/home_data_model.dart';
import '../models/orders_model.dart';

class HomeRepositoryImpl extends HomeRepository{
  HomeApiProvider homeApiProvider;
  HomeRepositoryImpl(this.homeApiProvider);

  @override
  Future<UserDataParams> getMainData() async {
    final prefs = await SharedPreferences.getInstance();
    final webService = prefs.getString("webService");
    final passWord = prefs.getString("passWord");
    Map<String, dynamic> jsonResponse = {};

    if(webService != null && passWord != null){
      try {
        final response = await homeApiProvider.GetMainData(
            WholeUserDataParams(webService,passWord));

        if (response.statusCode == 200) {

          jsonResponse = jsonDecode(response.body);
        } else {

          print(jsonDecode(response.body));
        }
      } catch (e) {
        print(e.toString());
      }
      return UserDataParams( webService, passWord, jsonResponse);
    }
    else{
      return UserDataParams('','',{});
    }
  }

  @override
  Future<OrderDataState<OrdersEntity>> getOrders(OrdersParams ordersParams) async{
    try{
      Response response = await homeApiProvider.GetOrders(ordersParams);

      //Response response = await apiProvider.GetOrders(ordersParams);
      if (response.statusCode == 200) {

        List<OrdersEntity> ordersEntity = ordersFromJson(response.data);
        print("yeeees");

        return OrderDataSuccess(ordersEntity);
      }else{
        return const OrderDataFailed("Something Went Wrong. try again...");

      }
    }catch (e){
      print(e.toString());
      return const OrderDataFailed("please check your connection...");

    }
  }

  @override
  Future<DataState<HomeDataEntity>> getHomeData() async {

      try {
        final response = await homeApiProvider.GetHomeData();

        if (response.statusCode == 200) {

          HomeDataEntity homeDataEntity = HomeDataModel.fromJson(response.data);

          print('eeeeeee');
          print(response);

          return DataSuccess(homeDataEntity);

        } else {
          return DataFailed('error in getHomeUserData');
        }
      } catch (e) {
        print(e.toString());
        return DataFailed('error in getHomeUserData:$e');
      }


  }

}
