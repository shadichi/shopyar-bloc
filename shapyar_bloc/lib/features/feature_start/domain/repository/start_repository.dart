
import '../../../../core/params/whole_user_data_params.dart';

abstract class StartRepository {

  Future<bool> checkConnectivity();

  Future<WholeUserDataParams> getString();


}
