
import 'package:shapyar_bloc/features/feature_log_in/domain/entities/login_entity.dart';
import 'package:shapyar_bloc/features/feature_log_in/domain/repository/log_in_repository.dart';

import '../../../../core/usecases/set_data_use_case.dart';

class SetStringUseCase extends SetDataUseCase<void, String, String> {
  final LogInRepository _logInRepository;
  SetStringUseCase(this._logInRepository);
Future<void> call(String key, String value) async {
return _logInRepository.setString(key, value);
}
}