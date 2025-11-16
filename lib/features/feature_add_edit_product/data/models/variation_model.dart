import 'dart:io';

class VariationUiModel {
  final Map<String, String> attributes;
  final Map<String, String> displayAttributes;

  String? regularPrice;
  String? salePrice;
  bool manageStock;
  String? stockQuantity;
  bool inStock;

  File? imageFile;      // برای انتخاب از گالری
  int? imageMediaId;    // آیدی که از آپلود می‌گیری


  VariationUiModel({
    required this.attributes,
    required this.displayAttributes,
    this.regularPrice,
    this.salePrice,
    this.manageStock = false,
    this.stockQuantity,
    this.inStock = true,
    this.imageFile,
    this.imageMediaId,
  });
}
