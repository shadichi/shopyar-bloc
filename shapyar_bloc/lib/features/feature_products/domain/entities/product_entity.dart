import 'package:equatable/equatable.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import '../../data/models/product_model.dart';

class ProductEntity extends Equatable {
  final int? id;
  final String? name;
  final String? sku;
  final String? regularPrice;
  final String? salePrice;
  final String? price;
  final bool? manageStock;
  final String? stockQuantity;
  final bool? inStock;
  final String? dateOnSaleFrom;
  final String? dateOnSaleTo;
  final String? lowStock;
  final String? image;
  final int? totalSales;
  final List<Childe>? childes;

  const ProductEntity(
      {this.id,
      this.name,
      this.sku,
      this.regularPrice,
      this.salePrice,
      this.price,
      this.manageStock,
      this.stockQuantity,
      this.inStock,
      this.dateOnSaleFrom,
      this.dateOnSaleTo,
      this.lowStock,
      this.image,
      this.totalSales,
      this.childes});

  @override
  // TODO: implement props
  List<Object?> get props => [
        id,
    name,
    sku,
    regularPrice,
    salePrice,
    price,
    manageStock,
    stockQuantity,
    inStock,
    dateOnSaleFrom,
    dateOnSaleTo,
    lowStock,
    image,
    totalSales,
    childes,
      ];
}
