import 'package:shopyar/core/params/connection_data_parms.dart';
import 'package:shopyar/core/resources/data_state.dart';
import 'package:shopyar/core/usecases/use_case.dart';

import '../../../../core/usecases/check-connection-use-case.dart';
import '../repository/start_repository.dart';

class CheckConnectivityUseCase extends CheckConnectionUseCase{
  final StartRepository _logInRepository;
  CheckConnectivityUseCase(this._logInRepository);

  @override
  Future<bool> call() {
    return _logInRepository.checkConnectivity();
  }

}

