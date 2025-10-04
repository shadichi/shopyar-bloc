import 'package:shopyar/features/feature_log_in/domain/entities/login_entity.dart';

/// version : "1.0.0"
/// shipping_methods : [{"method_id":"free_shipping:1","method_title":"حمل و نقل رایگان"},{"method_id":"flat_rate:2","method_title":"پست پیشتاز"}]
/// payment_methods : [{"method_id":0,"method_title":"انتقال مستقیم بانکی"}]
/// name : "شاپ یار"
/// user : "shadi"
/// license : "rieufhrweifhweifhweif"
/// status : {"wc-pending":"در انتظار پرداخت","wc-processing":"در حال انجام","wc-on-hold":"در انتظار بررسی","wc-completed":"تکمیل شده","wc-cancelled":"لغو شده","wc-refunded":"مسترد شده","wc-failed":"ناموفق","wc-checkout-draft":"پیش‌نویس"}

class LoginModel extends LoginEntity {
  LoginModel({
    String? version,
    List<ShippingMethods>? shippingMethods,
    List<PaymentMethods>? paymentMethods,
    String? name,
    String? user,
    String? license,
    Status? status,
  }):super(
      version: version,
      shippingMethods: shippingMethods,
      paymentMethods: paymentMethods,
      name: name,
      user: user,
      license: license,
      status: status,
  );

  LoginModel.fromJson(dynamic json) {
    version = json['version'];
    if (json['shipping_methods'] != null) {
      shippingMethods = [];
      json['shipping_methods'].forEach((v) {
        shippingMethods?.add(ShippingMethods.fromJson(v));
      });
    }
    if (json['payment_methods'] != null) {
      paymentMethods = [];
      json['payment_methods'].forEach((v) {
        paymentMethods?.add(PaymentMethods.fromJson(v));
      });
    }
    name = json['name'];
    user = json['user'];
    license = json['license'];
    status = json['status'] != null ? Status.fromJson(json['status']) : null;
  }
  String? version;
  List<ShippingMethods>? shippingMethods;
  List<PaymentMethods>? paymentMethods;
  String? name;
  String? user;
  String? license;
  Status? status;
LoginModel copyWith({  String? version,
  List<ShippingMethods>? shippingMethods,
  List<PaymentMethods>? paymentMethods,
  String? name,
  String? user,
  String? license,
  Status? status,
}) => LoginModel(  version: version ?? this.version,
  shippingMethods: shippingMethods ?? this.shippingMethods,
  paymentMethods: paymentMethods ?? this.paymentMethods,
  name: name ?? this.name,
  user: user ?? this.user,
  license: license ?? this.license,
  status: status ?? this.status,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['version'] = version;
    if (shippingMethods != null) {
      map['shipping_methods'] = shippingMethods?.map((v) => v.toJson()).toList();
    }
    if (paymentMethods != null) {
      map['payment_methods'] = paymentMethods?.map((v) => v.toJson()).toList();
    }
    map['name'] = name;
    map['user'] = user;
    map['license'] = license;
    if (status != null) {
      map['status'] = status?.toJson();
    }
    return map;
  }

}

/// wc-pending : "در انتظار پرداخت"
/// wc-processing : "در حال انجام"
/// wc-on-hold : "در انتظار بررسی"
/// wc-completed : "تکمیل شده"
/// wc-cancelled : "لغو شده"
/// wc-refunded : "مسترد شده"
/// wc-failed : "ناموفق"
/// wc-checkout-draft : "پیش‌نویس"

class Status {
  Status({
      this.wcpending, 
      this.wcprocessing, 
      this.wconhold, 
      this.wccompleted, 
      this.wccancelled, 
      this.wcrefunded, 
      this.wcfailed, 
      this.wccheckoutdraft,});

  Status.fromJson(dynamic json) {
    wcpending = json['wc-pending'];
    wcprocessing = json['wc-processing'];
    wconhold = json['wc-on-hold'];
    wccompleted = json['wc-completed'];
    wccancelled = json['wc-cancelled'];
    wcrefunded = json['wc-refunded'];
    wcfailed = json['wc-failed'];
    wccheckoutdraft = json['wc-checkout-draft'];
  }
  String? wcpending;
  String? wcprocessing;
  String? wconhold;
  String? wccompleted;
  String? wccancelled;
  String? wcrefunded;
  String? wcfailed;
  String? wccheckoutdraft;
Status copyWith({  String? wcpending,
  String? wcprocessing,
  String? wconhold,
  String? wccompleted,
  String? wccancelled,
  String? wcrefunded,
  String? wcfailed,
  String? wccheckoutdraft,
}) => Status(  wcpending: wcpending ?? this.wcpending,
  wcprocessing: wcprocessing ?? this.wcprocessing,
  wconhold: wconhold ?? this.wconhold,
  wccompleted: wccompleted ?? this.wccompleted,
  wccancelled: wccancelled ?? this.wccancelled,
  wcrefunded: wcrefunded ?? this.wcrefunded,
  wcfailed: wcfailed ?? this.wcfailed,
  wccheckoutdraft: wccheckoutdraft ?? this.wccheckoutdraft,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['wc-pending'] = wcpending;
    map['wc-processing'] = wcprocessing;
    map['wc-on-hold'] = wconhold;
    map['wc-completed'] = wccompleted;
    map['wc-cancelled'] = wccancelled;
    map['wc-refunded'] = wcrefunded;
    map['wc-failed'] = wcfailed;
    map['wc-checkout-draft'] = wccheckoutdraft;
    return map;
  }

}

/// method_id : 0
/// method_title : "انتقال مستقیم بانکی"

class PaymentMethods {
  PaymentMethods({
      this.methodId, 
      this.methodTitle,});

  PaymentMethods.fromJson(dynamic json) {
    methodId = json['method_id'];
    methodTitle = json['method_title'];
  }
  String? methodId;
  String? methodTitle;
PaymentMethods copyWith({  String? methodId,
  String? methodTitle,
}) => PaymentMethods(  methodId: methodId ?? this.methodId,
  methodTitle: methodTitle ?? this.methodTitle,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['method_id'] = methodId;
    map['method_title'] = methodTitle;
    return map;
  }

}

/// method_id : "free_shipping:1"
/// method_title : "حمل و نقل رایگان"

class ShippingMethods {
  ShippingMethods({
      this.methodId, 
      this.methodTitle,});

  ShippingMethods.fromJson(dynamic json) {
    methodId = json['method_id'];
    methodTitle = json['method_title'];
  }
  String? methodId;
  String? methodTitle;
ShippingMethods copyWith({  String? methodId,
  String? methodTitle,
}) => ShippingMethods(  methodId: methodId ?? this.methodId,
  methodTitle: methodTitle ?? this.methodTitle,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['method_id'] = methodId;
    map['method_title'] = methodTitle;
    return map;
  }

}