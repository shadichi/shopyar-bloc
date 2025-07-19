import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import 'package:shapyar_bloc/features/feature_orders/domain/entities/orders_entity.dart';

import '../../../../core/params/orders_params.dart';

@immutable
abstract class OrdersStatus extends Equatable {}


class UserErrorStatus extends OrdersStatus {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class OrdersLoadingStatus extends OrdersStatus {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class OrdersLoadedStatus extends OrdersStatus {


  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class OrdersErrorStatus extends OrdersStatus {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}
class OrdersSearchFailedStatus extends OrdersStatus {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}
class EditOrderInitialStatus extends OrdersStatus {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}
class EditOrderLoadingStatus extends OrdersStatus {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}
class EditOrderSuccessStatus extends OrdersStatus {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}
class EditOrderFailedStatus extends OrdersStatus {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}
