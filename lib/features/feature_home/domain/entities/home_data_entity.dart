import 'package:equatable/equatable.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import '../../data/models/home_data_model.dart';
import '../../data/models/orders_model.dart';

class HomeDataEntity extends Equatable {
  final DailyCancelled? dailySales;
  final DailyCancelled? monthlySales;
  final DailyCancelled? dailyCancelled;
  final DailyCancelled? monthlyCancelled;
  final StatusCounts? statusCounts;
  final int? dailyCounts;
  final int? monthlyCounts;
  final Map<String, int>? weeklyCounts;

  const HomeDataEntity({
    this.dailySales,
    this.monthlySales,
    this.dailyCancelled,
    this.monthlyCancelled,
    this.statusCounts,
    this.dailyCounts,
    this.monthlyCounts,
    this.weeklyCounts,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [
        dailySales,
        monthlySales,
        dailyCancelled,
        monthlyCancelled,
        statusCounts,
        dailyCounts,
        monthlyCounts,
        weeklyCounts,
      ];
}
