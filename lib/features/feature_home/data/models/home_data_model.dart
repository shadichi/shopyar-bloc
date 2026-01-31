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
      statusCounts: (json["status_counts"] is Map)?json["status_counts"] != null
          ? StatusCounts.fromJson(json["status_counts"])
          : null : null,
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
  final int wcPending;
  final int wcProcessing;
  final int wcCancelled;
  final int wcFailed;
  final int wcRefunded;

  const StatusCounts({
    required this.wcCompleted,
    required this.wcPending,
    required this.wcProcessing,
    required this.wcCancelled,
    required this.wcFailed,
    required this.wcRefunded,
  });

  factory StatusCounts.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const StatusCounts(
        wcCompleted: 0,
        wcPending: 0,
        wcProcessing: 0,
        wcCancelled: 0,
        wcFailed: 0,
        wcRefunded: 0,
      );
    }

    return StatusCounts(
      wcCompleted: _asInt(json['completed']) ?? 0,
      wcPending: _asInt(json['pending']) ?? 0,
      wcProcessing: _asInt(json['processing']) ?? 0,
      wcCancelled: _asInt(json['cancelled']) ?? 0,
      wcFailed: _asInt(json['failed']) ?? 0,
      wcRefunded: _asInt(json['refunded']) ?? 0,
    );
  }
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
