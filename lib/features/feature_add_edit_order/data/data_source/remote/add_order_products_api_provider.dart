import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:shopyar/core/params/report_data_params.dart';
import 'package:shopyar/core/params/whole_user_data_params.dart';
import 'package:shopyar/core/utils/static_values.dart';

import '../../../../../core/params/home_user_data_params.dart';
import '../../../../../core/params/orders_params.dart';
import '../../../../../core/params/products_params.dart';
import '../../../domain/entities/add_order_orders_entity.dart';

class AddOrderProductsApiProvider {
  final Dio _dio = Dio();

  Future<dynamic> getOrderProducts(InfParams productsParams) async {
    var response = await _dio.get(
        "${StaticValues.webService}/wp-json/shop-yar/products?cat=allPr&per_page=10",
        options: Options(headers: {'Authorization': StaticValues.passWord}));
    return response;
  }

  Future setOrder(AddOrderOrdersEntity order, webService, consumerKey, payType,
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
        "customer_email": (order.billing != null && order.billing!.email != null)
            ? order.billing!.email
            : 'shadi@yahoo.com',
      };
      print("Billing object: ${order.billing}");
      print("Billing email: ${order.billing!.email}");
      print("Sending customer_email: ${(order.billing != null && order.billing!.email != null) ? order.billing!.email : 'shadi@yahoo.com'}");
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
      }
      return false;
    } catch (e) {
      log(e.toString());
      return false;
    }
  }
}
