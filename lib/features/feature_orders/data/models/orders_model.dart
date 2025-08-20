import 'dart:convert';
import 'package:shapyar_bloc/features/feature_orders/domain/entities/orders_entity.dart';
import 'package:shamsi_date/shamsi_date.dart';

List<OrdersModel> ordersFromJson(dynamic json) =>
    List<OrdersModel>.from(json.map((x) => OrdersModel.fromJson(x)));

class OrdersModel extends OrdersEntity {
  OrdersModel({
    int? id,
    int? parentId,
    String? status,
    String? total,
    Ing? billing,
    Jalali? dateCreated,
    Ing? shipping,
    String? paymentMethod,
    String? paymentMethodTitle,
    List<LineItem>? lineItems,
    List<ShippingLine>? shippingLines,
  }) : super(
          id: id,
          parentId: parentId,
          status: status,
          total: total,
          billing: billing,
          dateCreated: dateCreated,
          shipping: shipping,
          paymentMethod: paymentMethod,
          paymentMethodTitle: paymentMethodTitle,
          lineItems: lineItems,
          shippingLines: shippingLines,
        );

  OrdersModel.fromJson(dynamic json) {
    id = json['id'];
    parentId = json['parent_id'];
    status = json['status'];
    total = json["total"];
    billing = Ing.fromJson(json["billing"]);
    dateCreated = DateTime.parse(json["date_created"]).toJalali();
    shipping = Ing.fromJson(json["shipping"]);
    paymentMethod = json["payment_method"];
    paymentMethodTitle = json["payment_method_title"];
    lineItems = List<LineItem>.from(
        json["line_items"].map((x) => LineItem.fromJson(x)));
    shippingLines = List<ShippingLine>.from(
        json["shipping_lines"].map((x) => ShippingLine.fromJson(x)));
  }

  int? id;
  int? parentId;
  String? status;
  String? total;
  Ing? billing;
  Jalali? dateCreated;
  Ing? shipping;
  String? paymentMethod;
  String? paymentMethodTitle;
  List<LineItem>? lineItems;
  List<ShippingLine>? shippingLines;
}

class Ing {
  Ing({
    required this.firstName,
    required this.lastName,
    required this.address1,
    required this.city,
    required this.state,
    required this.postcode,
    required this.country,
    required this.phone,
  });

  String firstName;
  String lastName;
  String address1;
  String city;
  String state;
  String postcode;
  String country;
  String? email;
  String phone;

  factory Ing.fromJson(Map<String, dynamic> json) => Ing(
        firstName: json["first_name"],
        lastName: json["last_name"],
        address1: json["address_1"],
        city: json["city"],
        state: json["state"],
        postcode: json["postcode"],
        country: json["country"],
        phone: json["phone"],
      );

  Map<String, dynamic> toJson() => {
        "first_name": firstName,
        "last_name": lastName,
        "address_1": address1,
        "city": city,
        "state": state,
        "postcode": postcode,
        "country": country,
        "phone": phone,
      };
}

class LineItem {
  LineItem({
    this.id,
    required this.name,
    required this.productId,
    this.variationId,
    required this.quantity,
    this.taxClass,
    this.price,
    this.subtotal,
    this.subtotalTax,
    required this.total,
    this.totalTax,
    this.sku,
  });

  int? id;
  int? orderId;
  String name;
  int productId;
  int? variationId;
  int quantity;
  String? taxClass;
  String? price;
  String? subtotal;
  String? subtotalTax;
  String total;
  String? totalTax;
  String? sku;
  String? img;

  factory LineItem.fromJson(Map<String, dynamic> json) => LineItem(
        id: json["id"],
        // orderId: json["order_id"],
        name: json["name"],
        productId: json["product_id"],
        variationId: json["variation_id"],
        quantity: json["quantity"],
        taxClass: json["tax_class"],
    price: json["price"],
        subtotal: json["subtotal"],
        subtotalTax: json["subtotal_tax"],
        total: json["total"],
        totalTax: json["total_tax"],
        sku: json["sku"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "order_id": orderId,
        "name": name,
        "product_id": productId,
        "variation_id": variationId,
        "quantity": quantity,
        "tax_class": taxClass,
        "price": price,
        "subtotal": subtotal,
        "subtotal_tax": subtotalTax,
        "total": total,
        "total_tax": totalTax,
        "sku": sku,
        "img": img,
      };
}

class ShippingLine {
  ShippingLine({
    this.id,
    this.methodTitle,
    this.methodId,
    this.total,
    this.totalTax,
  });

  int? id;
  String? methodTitle;
  String? methodId;
  String? total;
  String? totalTax;

  factory ShippingLine.fromJson(Map<String, dynamic> json) => ShippingLine(
        id: json["id"],
        methodTitle: json["method_title"],
        methodId: json["method_id"],
        total: json["total"],
        totalTax: json["total_tax"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "method_title": methodTitle,
        "method_id": methodId,
        "total": total,
        "total_tax": totalTax,
      };
}
