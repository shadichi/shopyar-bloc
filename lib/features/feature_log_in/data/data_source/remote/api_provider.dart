import 'package:dio/dio.dart';
import 'package:shopyar/core/params/whole_user_data_params.dart';
import 'package:http/http.dart' as http;

class ApiProvider{
  //final Dio _dio = Dio();
  Future<dynamic> GetLoginDataApi(WholeUserDataParams userDataParams) async {
    final response =await http.get(Uri.parse('${userDataParams.webService}/wp-json/shop-yar/login'),headers:{'Authorization': userDataParams.key});


    return response;
  }

}
