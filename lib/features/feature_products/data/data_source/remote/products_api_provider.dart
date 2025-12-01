import 'package:dio/dio.dart';
import 'package:shopyar/core/params/report_data_params.dart';
import 'package:shopyar/core/params/whole_user_data_params.dart';
import 'package:shopyar/core/utils/static_values.dart';

import '../../../../../core/params/orders_params.dart';
import '../../../../../core/params/products_params.dart';
import '../../../../../core/resources/order_data_state.dart';

class ProductsApiProvider{
  final Dio _dio = Dio();

  Future<dynamic> GetProducts(InfParams productsParams) async {
    print('productsParams.search');
    print(productsParams.search);
    try {
      var response = await _dio.get(
        '${StaticValues.webService}/wp-json/shop-yar/products?cat=allPr&per_page=${productsParams.productCount}&search=${productsParams.search}',
        options: Options(headers: {'Authorization': StaticValues.passWord}),
      );
      print(        '${StaticValues.webService}/wp-json/shop-yar/products?cat=allPr&per_page=${productsParams.productCount}&search=${productsParams.search}',
      );

      if (response.statusCode == 200) {
        return response;
      } else {
        return [];
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        print("محصولی یافت نشد");
        return Response(
            requestOptions: RequestOptions(path: ''),
            statusCode: 200,
            data: []
        );
      }
      return [];
    }
  }

}
