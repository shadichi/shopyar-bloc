import 'package:dio/dio.dart';
import 'package:shapyar_bloc/core/params/home_user_data_params.dart';
import 'package:shapyar_bloc/core/params/report_data_params.dart';
import 'package:shapyar_bloc/core/params/whole_user_data_params.dart';
import 'package:http/http.dart' as http;
import '../../../../../core/params/orders_params.dart';

class HomeApiProvider{
  final Dio _dio = Dio();
  Future<dynamic> GetReportData(ReportDataParams reportDataParams) async {
    var response =await _dio.get(
        'http://${reportDataParams.webService}/order-report?${reportDataParams.period}',
        queryParameters: {//یعنی بعد از یوارال بالا یه علامت سوال بزن و اینارو ادامش بنویس
          'Authorization': "${reportDataParams.key}",
        }
    );
    return response;

  }
  Future<dynamic> GetMainData(WholeUserDataParams wholeUserDataParams) async {
    final response =await http.get(Uri.parse('https://shop-yar.ir/wp-json/shop-yar/login'),headers:{'Authorization': 'shadi2'});
print('response');
print(response.body);
    return response;
  }
  Future<dynamic> GetOrders(OrdersParams ordersParams) async {
    var response =await _dio.get(
        //'http://${ordersParams.webService}/orders?per_page=${ordersParams.orderCount}${ordersParams.filter}',
       "http://shop-yar.ir/wp-json/shop-yar/orders?per_page=10",
        queryParameters: {//یعنی بعد از لینک بالا یه علامت سوال بزن و اینارو ادامش بنویس
          'Authorization': "shadi2",
        }
    );
    print(response.statusCode);
    return response;

  }
  Future<dynamic> GetHomeData() async {
    print('GetHomeData');
   try{
     final response =await _dio.get('https://shop-yar.ir/wp-json/shop-yar/order-report2',options: Options(headers: {
       "Authorization":"shadi2"
     }));

     return response;

   }catch(e){
     print('error in GetHomeData: $e');
   }
  }
}
