import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import '../../data/models/add_order_data_model.dart';
import '../../domain/entities/add_order_product_entity.dart';

@immutable
abstract class AddProductStatus extends Equatable{}

class AddProductsDataLoading extends AddProductStatus{
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class AddProductsDataLoaded extends AddProductStatus{
  final AddProductDataModel addProductDataModel;
  AddProductsDataLoaded(this.addProductDataModel);
  @override
  // TODO: implement props
  List<Object?> get props => [];
}
class AddProductsDataError extends AddProductStatus{
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

