import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:shopyar/core/resources/order_data_state.dart';
import 'package:shopyar/features/feature_home/domain/entities/orders_entity.dart';
import 'package:shopyar/features/feature_products/domain/entities/product_entity.dart';

import '../../../../core/params/home_user_data_params.dart';
import '../../../../core/params/products_params.dart';

@immutable
abstract class ProductsStatus extends Equatable{}

class ProductsLoadingStatus extends ProductsStatus{
  @override
  // TODO: implement props
  List<Object?> get props => [];
}
class pUserLoadedStatus extends ProductsStatus{
  final ProductsParams productsParams;
  pUserLoadedStatus(this.productsParams);
  @override
  // TODO: implement props
  List<Object?> get props => [productsParams];
}
class UserErrorStatus extends ProductsStatus{
  @override
  // TODO: implement props
  List<Object?> get props => [];
}
class ProductsLoadedStatus extends ProductsStatus{
 /* final List<ProductEntity>? productsDataState;
  ProductsLoadedStatus(this.productsDataState);*/
  @override
  // TODO: implement props
  List<Object?> get props => [];
}
class ProductsErrorStatus extends ProductsStatus{
  @override
  // TODO: implement props
  List<Object?> get props => [];
}
class ProductsSearchFailedStatus extends ProductsStatus {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}


