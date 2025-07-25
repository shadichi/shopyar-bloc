import 'dart:convert';
import 'dart:io';

import 'package:shapyar_bloc/core/params/whole_user_data_params.dart';
import 'package:shapyar_bloc/core/utils/static_values.dart';
import 'package:shapyar_bloc/features/feature_log_in/data/models/login_model.dart';
import 'package:shapyar_bloc/features/feature_log_in/domain/repository/log_in_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import '../../../../core/resources/data_state.dart';
import '../../domain/entities/login_entity.dart';
import '../data_source/remote/api_provider.dart';

class LogInRepositoryImpl extends LogInRepository {
  ApiProvider apiProvider;
 LogInRepositoryImpl(this.apiProvider);



  @override
  Future<void> setString(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("webService", value);
    await prefs.setString("passWord", key);
    /*await prefs.setString("loginEntityUser", loginEntity.user!);
    await prefs.setString("shipmentMethods", jsonEncode(loginEntity.shippingMethods));
    await prefs.setString("paymentMethods", jsonEncode(loginEntity.paymentMethods));
    await prefs.setString("status", jsonEncode(loginEntity.status));
    print("setString");*/
  }

  @override
  Future<Map<String, dynamic>> callLogInData(WholeUserDataParams userDataParams) async {
    try{
      final response = await apiProvider.GetLoginData(WholeUserDataParams(userDataParams.webService, userDataParams.key));
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);

          return jsonResponse;

      }else{
        return {};

      }
    }catch (e){
      print(e.toString());
      return {};

    }
  }

  @override
  Future<bool> checkConnectivity() async {
     try {
       final result = await InternetAddress.lookup('example.com');
       return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
     } on SocketException catch (_) {
       return false;
     }
  }

}

