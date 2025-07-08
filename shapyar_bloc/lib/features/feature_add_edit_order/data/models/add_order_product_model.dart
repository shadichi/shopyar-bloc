// To parse this JSON data, do
//
//     final products = productsFromJson(jsonString);

import 'dart:convert';

import '../../domain/entities/add_order_product_entity.dart';


List<AddOrderProductModel> AddOrderProductsFromJson(dynamic json) => List<AddOrderProductModel>.from(json.map((x) => AddOrderProductModel.fromJson(x)));

//String productsToJson(List<ProductModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class AddOrderProductModel extends AddOrderProductEntity{
  AddOrderProductModel({
    int? id,
    String? name,
    String? sku,
    String? regularPrice,
    String? salePrice,
    String? price,
    bool? manageStock,
    String? stockQuantity,
    bool? inStock,
    String? dateOnSaleFrom,
    String? dateOnSaleTo,
    String? lowStock,
    String? image,
    int? totalSales,
    List<Childe>? childes,
}):super(
    id: id,
    name: name,
    sku: sku,
    regularPrice: regularPrice,
    salePrice: salePrice,
    price: price,
    manageStock: manageStock,
    stockQuantity: stockQuantity,
    inStock: inStock,
    dateOnSaleFrom: dateOnSaleFrom,
    dateOnSaleTo: dateOnSaleTo,
    lowStock: lowStock,
    image: image,
    totalSales: totalSales,
    childes: childes,
  );


  AddOrderProductModel.fromJson(dynamic json) {
    id= json["id"];
    name= json["name"];
    sku= json["sku"];
    regularPrice= json["regular_price"];
    salePrice= json["sale_price"];
    price=json["price"];
    manageStock= json["manage_stock"];
    stockQuantity= json["stock_quantity"];
    inStock= json["in_stock"];
    dateOnSaleFrom= json["date_on_sale_from"];
    dateOnSaleTo= json["date_on_sale_to"];
    lowStock= json["low_stock"];
    image= json["image"];
    totalSales= json["total_sales"];
    childes= List<Childe>.from(json["variations"].map((x) => Childe.fromJson(x)));
  }
   int? id;
   String? name;
   String? sku;
   String? regularPrice;
   String? salePrice;
   String? price;
   bool? manageStock;
   String? stockQuantity;
   bool? inStock;
   String? dateOnSaleFrom;
   String? dateOnSaleTo;
   String? lowStock;
   String? image;
   int? totalSales;
   List<Childe>? childes;
  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "sku": sku,
    "regular_price": regularPrice,
    "sale_price": salePrice,
    "price": price,
    "manage_stock": manageStock,
    "stock_quantity": stockQuantity,
    "in_stock": inStock,
    "date_on_sale_from": dateOnSaleFrom,
    "date_on_sale_to": dateOnSaleTo,
    "low_stock": lowStock,
    "image": image,
    "total_sales": totalSales,
    "childes": List<dynamic>.from(childes!.map((x) => x.toJson())),
  };


}


class Childe {
  int id;
  String name;
  String sku;
  String regularPrice;
  String salePrice;
  String price;
  dynamic manageStock;
  String stockQuantity;
  bool inStock;
  String dateOnSaleFrom;
  String dateOnSaleTo;
  String lowStock;
  String image;
  String variable;

  Childe({
    required this.id,
    required this.name,
    required this.sku,
    required this.regularPrice,
    required this.salePrice,
    required this.price,
    required this.manageStock,
    required this.stockQuantity,
    required this.inStock,
    required this.dateOnSaleFrom,
    required this.dateOnSaleTo,
    required this.lowStock,
    required this.image,
    required this.variable,
  });

  factory Childe.fromJson(Map<String, dynamic> json) => Childe(
    id: json["id"],
    name: json["name"],
    sku: json["sku"],
    regularPrice: json["regular_price"],
    salePrice: json["sale_price"],
    price: json["price"],
    manageStock: json["manage_stock"],
    stockQuantity: json["stock_quantity"],
    inStock: json["in_stock"],
    dateOnSaleFrom: json["date_on_sale_from"],
    dateOnSaleTo: json["date_on_sale_to"],
    lowStock: json["low_stock"],
    image: json["image"],
    variable: json["variable"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "sku": sku,
    "regular_price": regularPrice,
    "sale_price": salePrice,
    "price": price,
    "manage_stock": manageStock,
    "stock_quantity": stockQuantity,
    "in_stock": inStock,
    "date_on_sale_from": dateOnSaleFrom,
    "date_on_sale_to": dateOnSaleTo,
    "low_stock": lowStock,
    "image": image,
    "variable": variable,
  };
}
