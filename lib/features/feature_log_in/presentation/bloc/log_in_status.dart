import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

import '../../../../core/params/whole_user_data_params.dart';
import '../../domain/entities/login_entity.dart';

@immutable
abstract class LogInStatus extends Equatable {}
class UserDataInitialStatus extends LogInStatus {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}
class UserDataLoadingStatus extends LogInStatus {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}//

class UserDataLoadedStatus extends LogInStatus {
/*
  final UserDataParams userData;
  final LoginEntity? loginEntity;

  UserDataLoadedStatus({required this.userData, this.loginEntity});
*/

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class UserDataErrorStatus extends LogInStatus {
 /* final LoginEntity? loginEntity;

  UserDataErrorStatus(this.loginEntity);*/
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class LoginErrorState extends LogInStatus {
  final String error;

  LoginErrorState(this.error);

  @override
  // TODO: implement props
  List<Object?> get props => [error];
}
class LoginEmptyFieldErrorState extends LogInStatus {
  final String error;

  LoginEmptyFieldErrorState(this.error);

  @override
  // TODO: implement props
  List<Object?> get props => [error];
}
class SharedPErrorState extends LogInStatus {
  final String error;

  SharedPErrorState(this.error);

  @override
  // TODO: implement props
  List<Object?> get props => [error];
}

class LoadingLogInStatus extends LogInStatus {

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class EmptyTextFieldsStatus extends LogInStatus {

  @override
  // TODO: implement props
  List<Object?> get props => [];
}