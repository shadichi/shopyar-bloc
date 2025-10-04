import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:shopyar/core/resources/order_data_state.dart';
import 'package:shopyar/features/feature_home/domain/entities/orders_entity.dart';
import 'package:shopyar/features/feature_products/domain/entities/product_entity.dart';

import '../../../../core/params/home_user_data_params.dart';
import '../../../../core/params/products_params.dart';
import '../../domain/entities/add_order_data_entity.dart';
import '../../domain/entities/add_order_orders_entity.dart';
import '../../domain/entities/add_order_product_entity.dart';

@immutable
abstract class AddOrderCardProductStatus extends Equatable{}

class AddOrderProductsInitialStatus extends AddOrderCardProductStatus{//وجود دکمه انتخاب محصول
  final AddOrderOrdersEntity addOrderOrdersEntity;
  AddOrderProductsInitialStatus(this.addOrderOrdersEntity);
  @override
  // TODO: implement props
  List<Object?> get props => [addOrderOrdersEntity];
}

class AddOrderChooseLoadingStatus extends AddOrderCardProductStatus{//وجود لادینگ
  @override
  // TODO: implement props
  List<Object?> get props => [];
}
class AddOrderCardProductLoaded extends AddOrderCardProductStatus{
  final Map<int, int> cart;
  AddOrderCardProductLoaded(this.cart);
  @override
  // TODO: implement props
  List<Object?> get props => [];
}
class AddOrderCardProductNotLoaded extends AddOrderCardProductStatus{
  final List<AddOrderProductEntity>? addOrderProductEntity;
  final Map<int, int> cart;
  AddOrderCardProductNotLoaded(this.addOrderProductEntity, this.cart);
  @override
  // TODO: implement props
  List<Object?> get props => [];
}
class AddOrderProductSelectionChangedStatus extends AddOrderCardProductStatus{// وجود تعداد محصول و دکمه های ادد و کم شدن
  final AddOrderOrdersEntity addOrderOrdersEntity;
   AddOrderProductSelectionChangedStatus(this.addOrderOrdersEntity);

  @override
  // TODO: implement props
  List<Object?> get props => [addOrderOrdersEntity];
}


