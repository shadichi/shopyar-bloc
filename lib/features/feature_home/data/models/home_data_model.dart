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

      /// 🔑 این خط مهمه
      statusCounts: StatusCounts.fromJson(
        json["status_counts"] as Map<String, dynamic>?,
      ),

      dailyCounts: _asInt(json["daily_count"]) ?? 0,
      monthlyCounts: _asInt(json["monthly_count"]) ?? 0,
      weeklyCounts: _asStringIntMap(json["count"]),

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
  final Map<String, int> counts;

  const StatusCounts({required this.counts});

  factory StatusCounts.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const StatusCounts(counts: {});
    }

    final map = <String, int>{};
    json.forEach((key, value) {
      map[key] = _asInt(value) ?? 0;
    });

    return StatusCounts(counts: map);
  }
}

int? _asInt(dynamic v) {
  if (v == null) return null;
  if (v is int) return v;
  if (v is double) return v.toInt();
  if (v is String) return int.tryParse(v);
  return null;
}

Map<String, int> _asStringIntMap(dynamic v) {
  if (v == null) return {};

  if (v is Map<String, dynamic>) {
    final res = <String, int>{};
    v.forEach((k, val) {
      res[k] = _asInt(val) ?? 0;
    });
    return res;
  }

  if (v is List) {
    return {};
  }

  return {};
}


List<int> _asIntList(dynamic v) {
  if (v is List) return v.map((e) => _asInt(e) ?? 0).toList();
  return const [];
}
