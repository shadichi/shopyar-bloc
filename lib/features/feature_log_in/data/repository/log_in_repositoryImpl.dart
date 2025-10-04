import 'dart:convert';
import 'dart:io';

import 'package:shopyar/core/params/whole_user_data_params.dart';
import 'package:shopyar/core/utils/static_values.dart';
import 'package:shopyar/features/feature_log_in/data/models/login_model.dart';
import 'package:shopyar/features/feature_log_in/domain/repository/log_in_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import '../../../../core/resources/data_state.dart';
import '../../domain/entities/login_entity.dart';
import '../data_source/remote/api_provider.dart';

class LogInRepositoryImpl extends LogInRepository {
  ApiProvider apiProvider;

  LogInRepositoryImpl(this.apiProvider);

  String ensureHttps(String base) {
    final s = base.trim();
    if (s.startsWith('https://')) return s;
    if (s.startsWith('http://')) return 'https://${s.substring(7)}';
    return 'https://$s';
  }

  @override
  Future<void> setString(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("webService", ensureHttps(value));
    await prefs.setString("passWord", key);
  }

  @override
  Future<Map<String, dynamic>> callLogInData(
      WholeUserDataParams userDataParams) async {
    try {
      final response = await apiProvider.GetLoginDataApi(WholeUserDataParams(
          ensureHttps(userDataParams.webService), userDataParams.key));
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);

        return jsonResponse;
      } else {
        return {};
      }
    } catch (e) {
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
