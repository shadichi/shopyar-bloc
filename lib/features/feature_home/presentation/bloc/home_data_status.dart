import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:shopyar/core/resources/order_data_state.dart';
import 'package:shopyar/features/feature_home/domain/entities/home_data_entity.dart';
import 'package:shopyar/features/feature_home/domain/entities/orders_entity.dart';

import '../../../../core/params/home_user_data_params.dart';

@immutable
abstract class HomeDataStatus extends Equatable{}

class HomeDataLoading extends HomeDataStatus{
  @override
  // TODO: implement props
  List<Object?> get props => [];
}
class HomeDataLoadedStatus extends HomeDataStatus{
  @override
  // TODO: implement props
  List<Object?> get props => [];
}
class HomeDataErrorStatus extends HomeDataStatus{
  @override
  // TODO: implement props
  List<Object?> get props => [];
}


