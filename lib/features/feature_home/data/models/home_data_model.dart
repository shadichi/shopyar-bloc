import 'dart:convert';

import 'package:shapyar_bloc/features/feature_home/domain/entities/home_data_entity.dart';

List<HomeDataModel> homeDataFromJson(dynamic json) =>
    List<HomeDataModel>.from(
        json.map((x) => HomeDataModel.fromJson(x)));

class HomeDataModel extends HomeDataEntity {
  HomeDataModel({
    DailyCancelled? dailySales,
    DailyCancelled? monthlySales,
    DailyCancelled? dailyCancelled,
    DailyCancelled? monthlyCancelled,
    StatusCounts? statusCounts,
  }) : super(
          dailySales: dailySales,
          monthlySales: monthlySales,
          dailyCancelled: dailyCancelled,
          monthlyCancelled: monthlyCancelled,
          statusCounts: statusCounts,
        );

  HomeDataModel.fromJson(Map<String, dynamic> json) {
    dailySales = DailyCancelled.fromJson(json["daily_sales"]);
    monthlySales = DailyCancelled.fromJson(json["monthly_sales"]);
    dailyCancelled = DailyCancelled.fromJson(json["daily_cancelled"]);
    monthlyCancelled = DailyCancelled.fromJson(json["monthly_cancelled"]);
    statusCounts = StatusCounts.fromJson(json["status_counts"]);
  }

  DailyCancelled? dailySales;
  DailyCancelled? monthlySales;
  DailyCancelled? dailyCancelled;
  DailyCancelled? monthlyCancelled;
  StatusCounts? statusCounts;

/*Map<String, dynamic> toJson() => {
    "daily_sales": dailySales.toJson(),
    "monthly_sales": monthlySales.toJson(),
    "daily_cancelled": dailyCancelled.toJson(),
    "monthly_cancelled": monthlyCancelled.toJson(),
    "status_counts": statusCounts.toJson(),
  };*/
}

class DailyCancelled {
  DailyCancelled({
    required this.qty,
    required this.price,
  });

  String qty;
  double price;

  factory DailyCancelled.fromJson(Map<String, dynamic> json) => DailyCancelled(
        qty: json["qty"]??'',
        price: json["price"]??0,
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
