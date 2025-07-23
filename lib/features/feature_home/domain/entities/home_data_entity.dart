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

  const HomeDataEntity({
    this.dailySales,
    this.monthlySales,
    this.dailyCancelled,
    this.monthlyCancelled,
    this.statusCounts,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [
        dailySales,
        monthlySales,
        dailyCancelled,
        monthlyCancelled,
        statusCounts,
      ];
}
