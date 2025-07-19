import 'package:equatable/equatable.dart';

import '../../data/models/login_model.dart';

class LoginEntity extends Equatable{
  final String? version;
  final List<ShippingMethods>? shippingMethods;
  final List<PaymentMethods>? paymentMethods;
  final String? name;
  final String? user;
  final String? license;
  final Status? status;

  const LoginEntity({
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