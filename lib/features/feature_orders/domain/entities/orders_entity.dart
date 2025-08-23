import 'package:equatable/equatable.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import '../../data/models/orders_model.dart';

class OrdersEntity extends Equatable {
  final int? id;
  final int? parentId;
  final String? status;
  final String? total;
  final Ing? billing;
  final String? shippingPrice;
  final Jalali? dateCreated;
  final Ing? shipping;
  final String? paymentMethod;
  final String? paymentMethodTitle;
  final List<LineItem>? lineItems;
  final List<ShippingLine>? shippingLines;

  const OrdersEntity(
      {this.id,
      this.parentId,
      this.status,
      this.total,
        this.dateCreated,
      this.billing,
        this.shippingPrice,
      this.shipping,
      this.paymentMethod,
      this.paymentMethodTitle,
      this.lineItems,
      this.shippingLines});

  @override
  // TODO: implement props
  List<Object?> get props => [
        id,
        parentId,
        status,
        total,
        billing,
    shippingPrice,
        paymentMethod,
    dateCreated,
        shipping,
        paymentMethodTitle,
        lineItems,
        shippingLines
      ];
}
