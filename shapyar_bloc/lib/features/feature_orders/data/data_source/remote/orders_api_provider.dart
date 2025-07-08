import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:shapyar_bloc/core/params/report_data_params.dart';
import 'package:shapyar_bloc/core/params/whole_user_data_params.dart';
import 'package:http/http.dart' as http;
import 'package:shapyar_bloc/core/utils/static_values.dart';

import '../../../../../core/params/orders_edit_status.dart';
import '../../../../../core/params/orders_params.dart';

class OrdersApiProvider{
  final Dio _dio = Dio();
  Future<dynamic> GetReportData(ReportDataParams reportDataParams) async {
    var response =await _dio.get(
        'https://${reportDataParams.webService}/order-report?${reportDataParams.period}',
        queryParameters: {//یعنی بعد از یوارال بالا یه علامت سوال بزن و اینارو ادامش بنویس
          'Authorization': "${reportDataParams.key}",
        }
    );
    return response;
  }
  Future<dynamic> GetOrders(OrdersParams ordersParams) async {

    print('ordersParams.status');
    print(ordersParams.status);
    print(ordersParams.perPage);

    var response =await _dio.get(
        //'http://${ordersParams.webService}/orders?per_page=${ordersParams.orderCount}${ordersParams.filter}',
       "${StaticValues.webService}/wp-json/shop-yar/orders?per_page=${ordersParams.perPage}&status=${ordersParams.status}&search=${ordersParams.search}",
        options: Options(headers: {
          "Authorization":StaticValues.passWord
        })
    );
    print(response.statusCode);
    return response;
  }
  Future<dynamic> editStatus(OrdersEditStatus ordersEditStatus) async {
    Response? response;
    try {
      var data = {
        "order_id": ordersEditStatus.orderId,
        "status": ordersEditStatus.status,
      };
      response = await _dio.post(
        "${StaticValues.webService}/wp-json/shop-yar/orders",
        options: Options(headers: {
          "Authorization": StaticValues.passWord,
          "Content-Type": "application/json"
        }),
        data: json.encode(data),
      );
    } catch (e) {
      print("Error occurred: $e");
    }

    if (response != null) {
      print(response.statusCode);
      return response;
    } else {
      throw Exception("No response received.");
    }
  }


}
