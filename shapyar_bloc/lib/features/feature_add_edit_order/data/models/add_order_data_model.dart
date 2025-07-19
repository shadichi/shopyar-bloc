import 'dart:convert';

import '../../domain/entities/add_order_data_entity.dart';

List<AddOrderDataModel> AddOrderDataFromJson(dynamic json) =>
    List<AddOrderDataModel>.from(
        json.map((x) => AddOrderDataModel.fromJson(x)));


class AddOrderDataModel extends AddOrderDataEntity {
  const AddOrderDataModel({
    String? version,
    List<ShippingMethod>? shippingMethods,
    List<PaymentMethod>? paymentMethods,
    String? name,
    String? user,
    String? license,
    Status? status,
  }) : super(
          version: version,
          shippingMethods: shippingMethods,
          paymentMethods: paymentMethods,
          name: name,
          user: user,
          license: license,
          status: status,
        );

  factory AddOrderDataModel.fromJson(dynamic json) {
    List<PaymentMethod> paymentMethods = [];
    List<ShippingMethod> shippingMethod = [];

    if (json["payment_methods"] != null) {
      json["payment_methods"].forEach((v) {
      paymentMethods.add(PaymentMethod.fromJson(v));
      });
    }
    if (json["shipping_methods"] != null) {
      json["shipping_methods"].forEach((v) {
        shippingMethod.add(ShippingMethod.fromJson(v));
      });
    }
    return AddOrderDataModel(
      version: json["version"],
      shippingMethods: shippingMethod,
      paymentMethods: paymentMethods,
      name: json["name"],
      user: json["user"],
      license: json["license"],
      status: Status.fromJson(json["status"]),
    );
  }

  /*String? version;
  List<ShippingMethod>? shippingMethods;
  List<PaymentMethod>? paymentMethods;
  String? name;
  String? user;
  String? license;
  Status? status;*/

  /*Map<String, dynamic> toJson() => {
        "version": version,
        "shipping_methods":
            List<dynamic>.from(shippingMethods!.map((x) => x.toJson())),
        "payment_methods":
            List<dynamic>.from(paymentMethods!.map((x) => x.toJson())),
        "name": name,
        "user": user,
        "license": license,
        "status": status!.toJson(),
      };*/
}

class PaymentMethod {
  PaymentMethod({
    dynamic? methodId,
    String? methodTitle,
  }) {
    methodId = methodId;
    methodTitle = methodTitle;
  }

  PaymentMethod.fromJson(dynamic json) {
    _methodId = json["method_id"];
    _methodTitle = json["method_title"];
  }

  dynamic? _methodId;
  String? _methodTitle;

  dynamic? get methodId => _methodId;
  String? get methodTitle => _methodTitle;

  Map<String, dynamic> toJson() => {
        "method_id": methodId,
        "method_title": methodTitle,
      };
}

class ShippingMethod {
  ShippingMethod({
    dynamic? methodId,
    String? methodTitle,
  }) {
    methodId = methodId;
    methodTitle = methodTitle;
  }

  ShippingMethod.fromJson(dynamic json) {
    _methodId = json["method_id"];
    _methodTitle = json["method_title"];
  }

  dynamic? _methodId;
  String? _methodTitle;

  dynamic? get methodId => _methodId;
  String? get methodTitle => _methodTitle;

  Map<String, dynamic> toJson() => {
    "method_id": methodId,
    "method_title": methodTitle,
  };
}

class Status {
  String wcPending;
  String wcProcessing;
  String wcOnHold;
  String wcCompleted;
  String wcCancelled;
  String wcRefunded;
  String wcFailed;
  String wcCheckoutDraft;

  Status({
    required this.wcPending,
    required this.wcProcessing,
    required this.wcOnHold,
    required this.wcCompleted,
    required this.wcCancelled,
    required this.wcRefunded,
    required this.wcFailed,
    required this.wcCheckoutDraft,
  });

  factory Status.fromJson(Map<String, dynamic> json) => Status(
        wcPending: json["wc-pending"],
        wcProcessing: json["wc-processing"],
        wcOnHold: json["wc-on-hold"],
        wcCompleted: json["wc-completed"],
        wcCancelled: json["wc-cancelled"],
        wcRefunded: json["wc-refunded"],
        wcFailed: json["wc-failed"],
        wcCheckoutDraft: json["wc-checkout-draft"],
      );

  Map<String, dynamic> toJson() => {
        "wc-pending": wcPending,
        "wc-processing": wcProcessing,
        "wc-on-hold": wcOnHold,
        "wc-completed": wcCompleted,
        "wc-cancelled": wcCancelled,
        "wc-refunded": wcRefunded,
        "wc-failed": wcFailed,
        "wc-checkout-draft": wcCheckoutDraft,
      };
}
