import 'package:shopyar/core/params/whole_user_data_params.dart';
import 'package:shopyar/core/resources/data_state.dart';
import 'package:shopyar/core/usecases/use_case.dart';
import 'package:shopyar/features/feature_log_in/domain/entities/login_entity.dart';
import 'package:shopyar/features/feature_log_in/domain/repository/log_in_repository.dart';

class GetLoginDataUseCase implements UseCase<Map<String, dynamic>, WholeUserDataParams>{
  final LogInRepository _logInRepository;
  GetLoginDataUseCase(this._logInRepository);

  @override
  Future<Map<String, dynamic>> call(WholeUserDataParams userDataParams) {
    return _logInRepository.callLogInData(userDataParams);
  }

}