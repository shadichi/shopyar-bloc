import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

import '../../../../core/params/whole_user_data_params.dart';

@immutable
abstract class StartStatus extends Equatable {}

class UserDataLoadingStatus extends StartStatus {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}//

class UserDataLoadedStatus extends StartStatus {

  @override
  // TODO: implement props
  List<Object?> get props => [];
}//

class UserDataErrorStatus extends StartStatus {
 /* final LoginEntity? loginEntity;

  UserDataErrorStatus(this.loginEntity);*/
  @override
  // TODO: implement props
  List<Object?> get props => [];
}//

class ConnectionAvailableStatus extends StartStatus{
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class ConnectionUnavailableState extends StartStatus{
  @override
  // TODO: implement props
  List<Object?> get props =>[];
}