import 'package:shapyar_bloc/core/params/whole_user_data_params.dart';
import 'package:shapyar_bloc/core/resources/data_state.dart';
import 'package:shapyar_bloc/core/usecases/use_case.dart';
import 'package:shapyar_bloc/features/feature_log_in/domain/entities/login_entity.dart';
import 'package:shapyar_bloc/features/feature_log_in/domain/repository/log_in_repository.dart';

class GetLoginDataUseCase implements UseCase<Map<String, dynamic>, WholeUserDataParams>{
  final LogInRepository _logInRepository;
  GetLoginDataUseCase(this._logInRepository);

  @override
  Future<Map<String, dynamic>> call(WholeUserDataParams userDataParams) {
    return _logInRepository.callLogInData(userDataParams);
  }

}