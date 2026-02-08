import 'dart:convert';

import 'package:shopyar/core/resources/data_state.dart';
import 'package:shopyar/core/utils/static_values.dart';
import 'package:shopyar/features/feature_home/domain/entities/home_data_entity.dart';
import 'package:shopyar/features/feature_home/domain/entities/orders_entity.dart';
import 'package:shopyar/features/feature_home/domain/repository/home_repository.dart';
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
        final response = await homeApiProvider.getMainData(
            WholeUserDataParams(webService,passWord));

        if (response.statusCode == 200) {

          StaticValues.webService = webService;
          StaticValues.passWord = passWord;

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
  Future<DataState<HomeDataEntity>> getHomeData() async {
    final prefs = await SharedPreferences.getInstance();
    final webService = prefs.getString("webService");
    final passWord = prefs.getString("passWord");
    Map<String, dynamic> jsonResponse = {};
    if(webService != null && passWord != null){
      try {
        final response = await homeApiProvider.getHomeData(WholeUserDataParams(webService, passWord));
        if (response.statusCode == 200) {
          print("response.dataaaaaaaaaaaaaaaaaaaaaaaaa");
          print(response);
          HomeDataEntity homeDataEntity = HomeDataModel.fromJson(response.data);
          return DataSuccess(homeDataEntity);
        } else {
          print("else error");
          return DataFailed('error in getHomeUserData');
        }
      } catch (e, st) {
        print("catch error");
        return DataFailed('error in getHomeUserData:$e');
      }
    }
    return DataFailed('error in getHomeUserData: webservice and password are null');



  }

}
