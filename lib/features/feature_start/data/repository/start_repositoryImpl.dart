import 'dart:convert';
import 'dart:io';
import 'package:shopyar/core/params/whole_user_data_params.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/utils/static_values.dart';
import '../../domain/repository/start_repository.dart';

class StartRepositoryImpl extends StartRepository {

  @override
  Future<bool> checkConnectivity() async {
     try {
       final result = await InternetAddress.lookup('example.com');
       return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
     } on SocketException catch (_) {
       return false;
     }
  }

  @override
  Future<WholeUserDataParams> getString() async {
    final prefs = await SharedPreferences.getInstance();
    final webService = prefs.getString("webService");
    final passWord = prefs.getString("passWord");
    if(webService == null || passWord == null){
      return WholeUserDataParams('','');
    }else{
      StaticValues.webService = webService.toString();
      StaticValues.passWord = passWord.toString();
    }
    return WholeUserDataParams(webService, passWord);
  }

}

