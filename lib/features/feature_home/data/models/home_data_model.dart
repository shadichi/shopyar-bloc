import 'dart:convert';

import 'package:shopyar/features/feature_home/domain/entities/home_data_entity.dart';

List<HomeDataModel> homeDataFromJson(dynamic json) =>
    List<HomeDataModel>.from(json.map((x) => HomeDataModel.fromJson(x)));

class HomeDataModel extends HomeDataEntity {
  HomeDataModel({
    DailyCancelled? dailySales,
    DailyCancelled? monthlySales,
    DailyCancelled? dailyCancelled,
    DailyCancelled? monthlyCancelled,
    StatusCounts? statusCounts,
    int? dailyCounts,
    int? monthlyCounts,
   Map<String, int>? weeklyCounts,
  }) : super(
    dailySales: dailySales,
    monthlySales: monthlySales,
    dailyCancelled: dailyCancelled,
    monthlyCancelled: monthlyCancelled,
    statusCounts: statusCounts,
    dailyCounts: dailyCounts,
    monthlyCounts: monthlyCounts,
    weeklyCounts: weeklyCounts,
  );

  factory HomeDataModel.fromJson(Map<String, dynamic> json) {
    return HomeDataModel(
      dailySales: json["daily_sales"] != null
          ? DailyCancelled.fromJson(json["daily_sales"])
          : null,
      monthlySales: json["monthly_sales"] != null
          ? DailyCancelled.fromJson(json["monthly_sales"])
          : null,
      dailyCancelled: json["daily_cancelled"] != null
          ? DailyCancelled.fromJson(json["daily_cancelled"])
          : null,
      monthlyCancelled: json["monthly_cancelled"] != null
          ? DailyCancelled.fromJson(json["monthly_cancelled"])
          : null,
      statusCounts: json["status_counts"] != null
          ? StatusCounts.fromJson(json["status_counts"])
          : null,
      dailyCounts: json["daily_count"] ?? 0,  // Provide default value
      monthlyCounts: json["monthly_count"] ?? 0,  // Provide default value
      weeklyCounts: (json["count"] is Map)?json["count"] != null
          ? Map<String, int>.from(json["count"])
          : {}:{},  // Provide empty map as default
    );
  }
}

class DailyCancelled {
  final int qty;
  final int? price; // چون بعضی پاسخ‌ها price = null

  DailyCancelled({
    required this.qty,
    this.price,
  });

  factory DailyCancelled.fromJson(Map<String, dynamic> json) => DailyCancelled(
    qty: _asInt(json['qty']) ?? 0,
    price: _asInt(json['price']),
  );

  Map<String, dynamic> toJson() => {
    'qty': qty,
    'price': price,
  };
}


class StatusCounts {
  final int wcCompleted;
  final int wcOnHold;
  final int wcPending;
  final int wcProcessing;
  final int wcCancelled;
  final int wcCheckoutDraft;
  final int trash;

  StatusCounts({
    required this.wcCompleted,
    required this.wcOnHold,
    required this.wcPending,
    required this.wcProcessing,
    required this.wcCancelled,
    required this.wcCheckoutDraft,
    required this.trash,
  });

  factory StatusCounts.fromJson(Map<String, dynamic> json) => StatusCounts(
    wcCompleted:     _asInt(json['wc-completed'])     ?? 0,
    wcOnHold:        _asInt(json['wc-on-hold'])       ?? 0,
    wcPending:       _asInt(json['wc-pending'])       ?? 0,
    wcProcessing:    _asInt(json['wc-processing'])    ?? 0,
    wcCancelled:     _asInt(json['wc-cancelled'])     ?? 0,
    wcCheckoutDraft: _asInt(json['auto-draft'])?? 0,
    trash:           _asInt(json['trash'])            ?? 0,
  );

  Map<String, dynamic> toJson() => {
    'wc-completed': wcCompleted,
    'wc-on-hold': wcOnHold,
    'wc-pending': wcPending,
    'wc-processing': wcProcessing,
    'wc-cancelled': wcCancelled,
    'auto-draft': wcCheckoutDraft,
    'trash': trash,
  };
}

int? _asInt(dynamic v) {
  if (v == null) return null;
  if (v is int) return v;
  if (v is double) return v.toInt();
  if (v is String) return int.tryParse(v);
  return null;
}

Map<String, int> _asStringIntMap(Map<String, dynamic>? m) {
  final res = <String, int>{};
  if (m == null) return res;
  m.forEach((k, v) => res[k] = _asInt(v) ?? 0);
  return res;
}

List<int> _asIntList(dynamic v) {
  if (v is List) return v.map((e) => _asInt(e) ?? 0).toList();
  return const [];
}

