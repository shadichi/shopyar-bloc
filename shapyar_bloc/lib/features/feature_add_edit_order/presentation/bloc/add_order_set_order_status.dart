import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:shapyar_bloc/core/resources/order_data_state.dart';
import 'package:shapyar_bloc/features/feature_home/domain/entities/orders_entity.dart';
import 'package:shapyar_bloc/features/feature_products/domain/entities/product_entity.dart';

import '../../../../core/params/home_user_data_params.dart';
import '../../../../core/params/products_params.dart';
import '../../domain/entities/add_order_data_entity.dart';
import '../../domain/entities/add_order_product_entity.dart';

@immutable
abstract class AddOrderSetOrderStatus extends Equatable{}

class AddOrderSetOrderInitialStatus extends AddOrderSetOrderStatus{

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class AddOrderSetOrderLoadingStatus extends AddOrderSetOrderStatus{
  @override
  // TODO: implement props
  List<Object?> get props => [];
}
class AddOrderSetOrderSuccess extends AddOrderSetOrderStatus{

  @override
  // TODO: implement props
  List<Object?> get props => [];
}
class AddOrderSetOrderFailed extends AddOrderSetOrderStatus{

  @override
  // TODO: implement props
  List<Object?> get props => [];
}



