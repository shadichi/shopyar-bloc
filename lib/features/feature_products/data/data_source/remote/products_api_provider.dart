import 'package:dio/dio.dart';
import 'package:shapyar_bloc/core/params/report_data_params.dart';
import 'package:shapyar_bloc/core/params/whole_user_data_params.dart';
import 'package:shapyar_bloc/core/utils/static_values.dart';

import '../../../../../core/params/orders_params.dart';
import '../../../../../core/params/products_params.dart';
import '../../../../../core/resources/order_data_state.dart';

class ProductsApiProvider{
  final Dio _dio = Dio();
/*  Future<dynamic> GetReportData(ReportDataParams reportDataParams) async {
    var response =await _dio.get(
        'http://${reportDataParams.webService}/order-report?${reportDataParams.period}',
        queryParameters: {//یعنی بعد از یوارال بالا یه علامت سوال بزن و اینارو ادامش بنویس
          'Authorization': "${reportDataParams.key}",
        }
    );
    return response;
    //ریترن کرد تموم بقیش هیچی
  }*/
  Future<dynamic> GetProducts(ProductsParams productsParams) async {
    print(StaticValues.webService);
    print(StaticValues.passWord);
    try {
      var response = await _dio.get(
        '${StaticValues.webService}/wp-json/shop-yar/products?cat=allPr&per_page=${productsParams.productCount}',
        options: Options(headers: {'Authorization': StaticValues.passWord}),
      );

      if (response.statusCode == 200) {
        return response;
      } else {
        return []; // در صورت کد نامعتبر، مقدار خالی برگردان
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        print("محصولی یافت نشد");
        return Response(
            requestOptions: RequestOptions(path: ''),
            statusCode: 404,
            data: [] // لیست خالی، چون محصولی وجود ندارد
        );
      }
      return []; // سایر خطاها
    }
  }

}
