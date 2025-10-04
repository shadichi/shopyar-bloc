
import 'package:shopyar/core/resources/data_state.dart';

import '../../../../core/params/home_user_data_params.dart';
import '../../../../core/params/orders_params.dart';
import '../../../../core/params/whole_user_data_params.dart';
import '../../../../core/resources/order_data_state.dart';
import '../../../feature_log_in/data/data_source/remote/api_provider.dart';
import '../entities/home_data_entity.dart';
import '../entities/orders_entity.dart';

abstract class HomeRepository{

  Future<UserDataParams> getMainData();

  Future<DataState<HomeDataEntity>> getHomeData();
}