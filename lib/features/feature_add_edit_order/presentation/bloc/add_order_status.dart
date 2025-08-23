import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import '../../domain/entities/add_order_product_entity.dart';

@immutable
abstract class AddOrderStatus extends Equatable{}

class AddOrderProductsLoadingStatus extends AddOrderStatus{
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class AddOrderProductsLoadedStatus extends AddOrderStatus{
  final Map<int, int> cart;
  final Map<int, bool> isFirstTime;
  AddOrderProductsLoadedStatus( this.cart, this.isFirstTime);
  @override
  // TODO: implement props
  List<Object?> get props => [];
}
class AddOrderProductsErrorStatus extends AddOrderStatus{
  @override
  // TODO: implement props
  List<Object?> get props => [];
}
class AddOrderLoadingStatus extends AddOrderStatus{
  @override
  // TODO: implement props
  List<Object?> get props => [];
}
class AddOrderSuccessStatus extends AddOrderStatus{
  @override
  // TODO: implement props
  List<Object?> get props => [];
}
class AddOrderErrorStatus extends AddOrderStatus{
  @override
  // TODO: implement props
  List<Object?> get props => [];
}


