import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:shapyar_bloc/core/params/report_data_params.dart';
import 'package:shapyar_bloc/core/params/whole_user_data_params.dart';
import 'package:shapyar_bloc/core/utils/static_values.dart';

import '../../../../../core/params/home_user_data_params.dart';
import '../../../../../core/params/orders_params.dart';
import '../../../../../core/params/products_params.dart';
import '../../../domain/entities/add_order_orders_entity.dart';

class AddOrderProductsApiProvider {
  final Dio _dio = Dio();

  Future<dynamic> GetOrderProducts(ProductsParams productsParams) async {
    var response = await _dio.get(
        //'http://${ordersParams.webService}/orders?per_page=${ordersParams.orderCount}${ordersParams.filter}',
        "${StaticValues.webService}/wp-json/shop-yar/products?cat=allPr&per_page=23",
        options: Options(headers: {'Authorization': StaticValues.passWord}));
    // print(response.statusCode);
    return response;
    //ریترن کرد تموم بقیش هیچی
  }

  /* Future<dynamic> GetOrderData(UserDataParams userDataParams) async {
    var response =await _dio.get(
      //'http://${ordersParams.webService}/orders?per_page=${ordersParams.orderCount}${ordersParams.filter}',
        "${StaticValues.webService}/wp-json/shop-yar/login",
        options: Options(headers: {'Authorization': StaticValues.passWord})
    );
   // print(response.statusCode);
    return response;
    //ریترن کرد تموم بقیش هیچی
  }*/
/*  Future<bool> SetOrder(AddOrderOrdersEntity order, webService, consumerKey, payType, shipType, String shipPrice) async {
    try {
      var products = [];
      for (var p in order.lineItems!) {
        products.add({"id": p.productId.toString(), "qty": p.quantity});
      }

      var maap = {
        "billing": order.billing,
        "products": products,
        "payment_method_id": payType,
        "shipping_method_id": shipType,
        "shipping_method_price": shipPrice,
      };

      if (order.shipping != null && order.shipping!.firstName.isNotEmpty && order.shipping!.city.isNotEmpty) {
        maap['shipping'] = order.shipping;
      }

      if (order.id != 0) {
        maap['order_id'] = order.id;
      }

      var url = "http://shop-yar.ir/wp-json/shop-yar/add-order";

      final response = await http.post(
        Uri.parse(url),
        headers: {
          "Authorization": "shadi2",  // Adjust if needed
          "Content-Type": "application/json",
        },
        body: json.encode(maap),
      );

      print("Response: ${response.body}");

      if (response.statusCode == 200) {
        print("Order saved successfully.");
        return true;
      } else {
        print("Failed to save order. Status code: ${response.statusCode}");
        return false;
      }
    } catch (e) {
      print("Error occurred: $e");
      return false;
    }
  }*/
  Future SetOrder(AddOrderOrdersEntity order, webService, consumerKey, payType,
      shipType, String shipPrice) async {
    bool connection = false;
    try {
      var prs = [];
      for (var p in order.lineItems!) {
        prs.add({"id": p.productId.toString(), "qty": p.quantity});
      }

      var maap = {
        "billing": order.billing,
        // "shipping":order.shipping,//age shipping nabashe billing ja shipping mizare
        "products": prs,
        "payment_method_id": payType,
        "shipping_method_id": shipType,
        "shipping_method_price": shipPrice,
      };
      if (order.shipping!.firstName.isNotEmpty &&
          order.shipping!.city.isNotEmpty) {
        maap['shipping'] = order.shipping;
      }

      if (order.id != 0) {
        maap['order_id'] = order.id;
      }
      var url =
          "${StaticValues.webService}/wp-json/shop-yar/orders"; // final url
      final response = await http.post(Uri.parse(url),
          headers: {
            "Authorization": StaticValues.passWord,
            "Content-Type": "application/json"
          },
          body: json.encode(maap));
      print("statusCode:${response.statusCode}");
      if (response.statusCode == 200) {
        connection = true;
        print("saved order");
        var json = response.body;
        print(json);
        return connection;
        // print(ordersFromJson(json));
      }
      return false;
    } catch (e) {
      log(e.toString());
      return false;
    }
  }
}
