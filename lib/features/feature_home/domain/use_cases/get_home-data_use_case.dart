import 'package:shapyar_bloc/core/resources/order_data_state.dart';
import 'package:shapyar_bloc/features/feature_home/domain/entities/home_data_entity.dart';

import '../../../../core/params/home_user_data_params.dart';
import '../../../../core/resources/data_state.dart';
import '../../../../core/usecases/get_string_use_case.dart';
import '../repository/home_repository.dart';

class GetHomeDataUseCase extends getStringUseCase<DataState<HomeDataEntity>> {
  final HomeRepository _homeRepository;
  GetHomeDataUseCase(this._homeRepository);

  @override
  Future<DataState<HomeDataEntity>> call() {
    return _homeRepository.getHomeData();
  }
}