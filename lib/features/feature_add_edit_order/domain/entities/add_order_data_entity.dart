import 'package:equatable/equatable.dart';

import '../../data/models/add_order_data_model.dart';

class AddOrderDataEntity extends Equatable{
  final String? version;
  final List<ShippingMethod>? shippingMethods;
  final List<PaymentMethod>? paymentMethods;
  final String? name;
  final String? user;
  final String? license;
  final Status? status;

  const AddOrderDataEntity({
    this.version,
    this.shippingMethods,
    this.paymentMethods,
    this.name,
    this.user,
    this.license,
    this.status
});

  @override
  // TODO: implement props
  List<Object?> get props => [
    version,
    shippingMethods,
    paymentMethods,
    name,
    user,
    license,
    status
  ];
}