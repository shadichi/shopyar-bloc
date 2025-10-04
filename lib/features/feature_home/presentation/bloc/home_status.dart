import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:shopyar/core/resources/order_data_state.dart';
import 'package:shopyar/features/feature_home/domain/entities/orders_entity.dart';

import '../../../../core/params/home_user_data_params.dart';

@immutable
abstract class HomeStatus extends Equatable{}

class HomeLoading extends HomeStatus{
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

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
class HomeAccountExitStatus extends HomeStatus{
  @override
  // TODO: implement props
  List<Object?> get props => [];
}


