// To parse this JSON data, do
//
//     final addProductDataModel = addProductDataModelFromJson(jsonString);

import 'dart:convert';

AddProductDataModel addProductDataModelFromJson(String str) => AddProductDataModel.fromJson(json.decode(str));

String addProductDataModelToJson(AddProductDataModel data) => json.encode(data.toJson());

class AddProductDataModel {
  List<Category> categories;
  List<Attribute> attributes;
  List<dynamic> tags;
  SPagination tagsPagination;
  List<Brand> brands;
  SPagination brandsPagination;
  String brandsTaxonomy;
  List<dynamic> shippingClasses;

  AddProductDataModel({
    required this.categories,
    required this.attributes,
    required this.tags,
    required this.tagsPagination,
    required this.brands,
    required this.brandsPagination,
    required this.brandsTaxonomy,
    required this.shippingClasses,
  });

  factory AddProductDataModel.fromJson(Map<String, dynamic> json) => AddProductDataModel(
    categories: List<Category>.from(json["categories"].map((x) => Category.fromJson(x))),
    attributes: List<Attribute>.from(json["attributes"].map((x) => Attribute.fromJson(x))),
    tags: List<dynamic>.from(json["tags"].map((x) => x)),
    tagsPagination: SPagination.fromJson(json["tags_pagination"]),
    brands: List<Brand>.from(json["brands"].map((x) => Brand.fromJson(x))),
    brandsPagination: SPagination.fromJson(json["brands_pagination"]),
    brandsTaxonomy: json["brands_taxonomy"],
    shippingClasses: List<dynamic>.from(json["shipping_classes"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "categories": List<dynamic>.from(categories.map((x) => x.toJson())),
    "attributes": List<dynamic>.from(attributes.map((x) => x.toJson())),
    "tags": List<dynamic>.from(tags.map((x) => x)),
    "tags_pagination": tagsPagination.toJson(),
    "brands": List<dynamic>.from(brands.map((x) => x.toJson())),
    "brands_pagination": brandsPagination.toJson(),
    "brands_taxonomy": brandsTaxonomy,
    "shipping_classes": List<dynamic>.from(shippingClasses.map((x) => x)),
  };
}

class Attribute {
  int id;
  String name;
  String slug;
  String taxonomy;
  List<Brand> terms;

  Attribute({
    required this.id,
    required this.name,
    required this.slug,
    required this.taxonomy,
    required this.terms,
  });

  factory Attribute.fromJson(Map<String, dynamic> json) => Attribute(
    id: json["id"],
    name: json["name"],
    slug: json["slug"],
    taxonomy: json["taxonomy"],
    terms: List<Brand>.from(json["terms"].map((x) => Brand.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "slug": slug,
    "taxonomy": taxonomy,
    "terms": List<dynamic>.from(terms.map((x) => x.toJson())),
  };
}

class Brand {
  int id;
  String name;
  String slug;

  Brand({
    required this.id,
    required this.name,
    required this.slug,
  });

  factory Brand.fromJson(Map<String, dynamic> json) => Brand(
    id: json["id"],
    name: json["name"],
    slug: json["slug"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "slug": slug,
  };
}

class SPagination {
  int page;
  int perPage;
  int total;

  SPagination({
    required this.page,
    required this.perPage,
    required this.total,
  });

  factory SPagination.fromJson(Map<String, dynamic> json) => SPagination(
    page: json["page"],
    perPage: json["per_page"],
    total: json["total"],
  );

  Map<String, dynamic> toJson() => {
    "page": page,
    "per_page": perPage,
    "total": total,
  };
}

class Category {
  int id;
  String name;
  String slug;
  int parent;
  List<dynamic> children;

  Category({
    required this.id,
    required this.name,
    required this.slug,
    required this.parent,
    required this.children,
  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
    id: json["id"],
    name: json["name"],
    slug: json["slug"],
    parent: json["parent"],
    children: List<dynamic>.from(json["children"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "slug": slug,
    "parent": parent,
    "children": List<dynamic>.from(children.map((x) => x)),
  };
}
