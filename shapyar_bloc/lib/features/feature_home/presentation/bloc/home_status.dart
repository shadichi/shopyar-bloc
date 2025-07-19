import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:shapyar_bloc/core/resources/order_data_state.dart';
import 'package:shapyar_bloc/features/feature_home/domain/entities/orders_entity.dart';

import '../../../../core/params/home_user_data_params.dart';

@immutable
abstract class HomeStatus extends Equatable{}

class HomeLoading extends HomeStatus{
  @override
  // TODO: implement props
  List<Object?> get props => [];
}
/*class UserLoadedStatus extends HomeStatus{
  final UserDataParams homeUserDataParams;
  UserLoadedStatus(this.homeUserDataParams);
  @override
  // TODO: implement props
  List<Object?> get props => [homeUserDataParams];
}
class UserErrorStatus extends HomeStatus{
  @override
  // TODO: implement props
  List<Object?> get props => [];
}*/
class HomeLoadedStatus extends HomeStatus{
  HomeLoadedStatus();
  @override
  // TODO: implement props
  List<Object?> get props => [];
}
class HomeErrorStatus extends HomeStatus{
  @override
  // TODO: implement props
  List<Object?> get props => [];
}


