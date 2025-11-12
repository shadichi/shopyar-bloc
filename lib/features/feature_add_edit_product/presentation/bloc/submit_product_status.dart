import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import '../../data/models/add_order_data_model.dart';
import '../../domain/entities/add_order_product_entity.dart';

@immutable
abstract class SubmitProductStatus extends Equatable{}

class SubmitProductLoading extends SubmitProductStatus{
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class SubmitProductLoaded extends SubmitProductStatus{
  final AddProductDataModel addProductDataModel;
  SubmitProductLoaded(this.addProductDataModel);
  @override
  // TODO: implement props
  List<Object?> get props => [];
}
class SubmitProductError extends SubmitProductStatus{
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

