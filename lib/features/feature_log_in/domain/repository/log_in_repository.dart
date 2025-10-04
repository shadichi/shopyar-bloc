import 'package:shopyar/core/params/whole_user_data_params.dart';
import 'package:shopyar/features/feature_log_in/domain/entities/login_entity.dart';

import '../../../../core/params/connection_data_parms.dart';
import '../../../../core/resources/data_state.dart';

abstract class LogInRepository {

  Future<void> setString(String key, String value);

  Future<Map<String, dynamic>> callLogInData(WholeUserDataParams userDataParams);

  Future<bool> checkConnectivity();

}
