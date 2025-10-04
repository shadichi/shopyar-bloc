import 'package:dio/dio.dart';
import 'package:shopyar/core/params/home_user_data_params.dart';
import 'package:shopyar/core/params/report_data_params.dart';
import 'package:shopyar/core/params/whole_user_data_params.dart';
import 'package:http/http.dart' as http;
import '../../../../../core/params/orders_params.dart';

class HomeApiProvider {
  final Dio _dio = Dio();

  Future<dynamic> getMainData(WholeUserDataParams wholeUserDataParams) async {
    final response = await http.get(
        Uri.parse('${wholeUserDataParams.webService}/wp-json/shop-yar/login'),
        headers: {'Authorization': wholeUserDataParams.key});
    return response;
  }

  Future<dynamic> getHomeData(WholeUserDataParams wholeUserDataParams) async {
    print('GetHomeData');
    try {
      final response = await _dio.get(
          '${wholeUserDataParams.webService}/wp-json/shop-yar/get_full_order_report',
          options:
              Options(headers: {"Authorization": wholeUserDataParams.key}));

      print('response.data');
      print(response.data);

      return response;
    } catch (e) {
      print('error in GetHomeData: $e');
    }
  }
}
