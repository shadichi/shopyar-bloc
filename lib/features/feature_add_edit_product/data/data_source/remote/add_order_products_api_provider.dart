import 'package:dio/dio.dart';
import 'package:shopyar/core/utils/static_values.dart';

class AddProductsGetDataApiProvider {
  final Dio _dio = Dio();

  Future<dynamic> getData() async {
    print('11');
    var response = await _dio.get(
        "${StaticValues.webService}/wp-json/shop-yar/catalog/bootstrap",
        options: Options(headers: {'Authorization': StaticValues.passWord}));
    print('21');

    print('response.data');
    print(response.data);
    return response;
  }
}
