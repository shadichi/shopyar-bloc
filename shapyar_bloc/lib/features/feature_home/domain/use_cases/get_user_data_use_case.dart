import '../../../../core/params/home_user_data_params.dart';
import '../../../../core/usecases/get_string_use_case.dart';
import '../repository/home_repository.dart';

class GetMainDataUseCase extends getStringUseCase<UserDataParams> {
  final HomeRepository _homeRepository;
  GetMainDataUseCase(this._homeRepository);

  @override
  Future<UserDataParams> call() {
    return _homeRepository.getMainData();
  }
}