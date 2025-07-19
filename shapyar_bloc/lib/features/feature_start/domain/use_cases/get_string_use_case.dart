import 'package:shapyar_bloc/core/params/whole_user_data_params.dart';
import 'package:shapyar_bloc/core/resources/data_state.dart';
import 'package:shapyar_bloc/core/usecases/get_string_use_case.dart';
import 'package:shapyar_bloc/core/usecases/use_case.dart';
import 'package:shapyar_bloc/features/feature_log_in/domain/entities/login_entity.dart';
import 'package:shapyar_bloc/features/feature_log_in/domain/repository/log_in_repository.dart';

import '../repository/start_repository.dart';


class GetStringUseCase extends getStringUseCase<WholeUserDataParams> {
  final StartRepository _startRepository;
  GetStringUseCase(this._startRepository);

  @override
  Future<WholeUserDataParams> call() {
    return _startRepository.getString();
  }



}