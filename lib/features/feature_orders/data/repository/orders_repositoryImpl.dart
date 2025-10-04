import 'dart:convert';

import 'package:shopyar/core/params/orders_edit_status.dart';
import 'package:shopyar/core/params/orders_params.dart';
import 'package:shopyar/features/feature_orders/domain/entities/orders_entity.dart';
import 'package:shopyar/features/feature_orders/domain/repository/orders_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/params/whole_user_data_params.dart';
import '../../../../core/resources/data_state.dart';
import '../../../../core/resources/order_data_state.dart';
import '../../../feature_orders/data/models/orders_model.dart';
import '../data_source/remote/orders_api_provider.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;

class OrdersRepositoryImpl extends OrdersRepository {
  OrdersApiProvider ordersApiProvider;

  OrdersRepositoryImpl(this.ordersApiProvider);



  @override
  Future<OrderDataState<OrdersEntity>> getOrders(
      OrdersParams ordersParams) async {
    try {
      Response response = await ordersApiProvider.GetOrders(ordersParams);

      //Response response = await apiProvider.GetOrders(ordersParams);
      if (response.statusCode == 200) {
        List<OrdersEntity> ordersEntity = ordersFromJson(response.data);
        print("yeeees");

        return OrderDataSuccess(ordersEntity);
      } else {
        return const OrderDataFailed("Something Went Wrong. try again...");
      }
    } catch (e) {
      print(e.toString());
      return const OrderDataFailed("please check your connection...");
    }
  }

  @override
  Future<DataState> editStatus(OrdersEditStatus ordersEditStatus) async {

    try {
      Response  response = await ordersApiProvider.editStatus(ordersEditStatus);

      if (response.statusCode == 200) {
        print("yeeees");

        return DataSuccess('confirmed');
      } else {
        print("nooooooooo");
        return const DataFailed("Something Went Wrong. try again...");
      }
    } catch (e) {
      print(e.toString());
      return const DataFailed("please check your connection...");
    }
  }
}
