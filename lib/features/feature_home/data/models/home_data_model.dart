import 'dart:convert';

import 'package:shapyar_bloc/features/feature_home/domain/entities/home_data_entity.dart';

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
  DailyCancelled({
    required this.qty,
    required this.price,
  });

  String qty;
  String price;

  factory DailyCancelled.fromJson(Map<String, dynamic> json) => DailyCancelled(
        qty: json["qty"] ?? '',
        price: json["price"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "qty": qty,
        "price": price,
      };
}

class StatusCounts {
  int wcCompleted;
  int wcOnHold;
  int wcPending;
  int wcProcessing;
  int wcRefunded;

  StatusCounts({
    required this.wcCompleted,
    required this.wcOnHold,
    required this.wcPending,
    required this.wcProcessing,
    required this.wcRefunded,
  });

  factory StatusCounts.fromJson(Map<String, dynamic> json) => StatusCounts(
        wcCompleted: json["wc-completed"],
        wcOnHold: json["wc-on-hold"],
        wcPending: json["wc-pending"],
        wcProcessing: json["wc-processing"],
        wcRefunded: json["wc-refunded"],
      );

  Map<String, dynamic> toJson() => {
        "wc-completed": wcCompleted,
        "wc-on-hold": wcOnHold,
        "wc-pending": wcPending,
        "wc-processing": wcProcessing,
        "wc-refunded": wcRefunded,
      };
}
