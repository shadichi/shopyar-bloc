import '../../features/feature_add_edit_order/domain/entities/add_order_orders_entity.dart';

class SetOrderParams{
  final AddOrderOrdersEntity order;
  final String payType;
  final String shipType;
  final String shipPrice;
  const SetOrderParams(this.order, this.payType, this.shipType, this.shipPrice);
}