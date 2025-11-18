import 'dart:io';

class ProductSubmitModel {
  // الزامی
  final String name;

  // عمومی
  final String type;             // 'simple' | 'variable'
  final String? status;          // 'publish' | 'draft' | 'pending' | 'private'
  final String? sku;
  final String? regularPrice;
  final String? salePrice;
  final String? description;
  final String? shortDescription;

  // موجودی
  final bool? manageStock;
  final int? stockQuantity;
  final bool? inStock;

  // مدیا (فایل‌ها)
  final File? featuredFile;        // اگر بدی، خودش آپلود می‌شود
  final List<File> galleryFiles;   // اگر بدی، گالری آپلود می‌شود

  // اگر نخوای فایل بدهی و بخوای وردپرس sideload کنه:
  final String? featuredImageUrl;  // image_url

  // دسته‌بندی/خصوصیات
  final List<int>? categoryIds;

  final List<int>? brandIds;
  /// مثل:
  /// [{"name":"pa_color","options":["red","blue"],"visible":true,"variation":true}]
  final List<Map<String, dynamic>>? attributes;
  /// مثل:
  /// [{"attributes":{"pa_color":"red"},"regular_price":"100000", ...}]
  final List<Map<String, dynamic>>? variations;

  /// لیست موازی با variations برای فایل تصویر هر ورییشن
  /// index 0 برای variations[0] ، index 1 برای variations[1] و ...
  final List<File?> variationImageFiles;


  const ProductSubmitModel({
    // الزامی
    required this.name,

    // عمومی
    this.type = 'simple',
    this.status,
    this.sku,
    this.regularPrice,
    this.salePrice,
    this.description,
    this.shortDescription,

    // موجودی
    this.manageStock,
    this.stockQuantity,
    this.inStock,

    // مدیا
    this.featuredFile,
    this.galleryFiles = const [],
    this.featuredImageUrl,

    // دسته‌بندی/خصوصیات
    this.categoryIds,
    this.brandIds,
    this.attributes,
    this.variations,
    this.variationImageFiles = const [],

  });

  /// این متد فقط JSON بدنه‌ی محصول را می‌سازد
  /// IDهای مدیا را از بیرون (بعد از آپلود) بهش می‌دهیم
  Map<String, dynamic> toJson({
    int? imageMediaId,
    List<int>? galleryMediaIds,
    List<Map<String, dynamic>>? variationsOverride,
  }) {
    final Map<String, dynamic> payload = {
      'type': type,
      'name': name,
    };

    // عمومی
    if (status != null) payload['status'] = status;
    if (sku != null && sku!.isNotEmpty) payload['sku'] = sku;
    if (regularPrice != null) payload['regular_price'] = regularPrice;
    if (salePrice != null) payload['sale_price'] = salePrice;
    if (description != null) payload['description'] = description;
    if (shortDescription != null) payload['short_description'] = shortDescription;

    // موجودی
    if (manageStock != null) payload['manage_stock'] = manageStock;
    if (stockQuantity != null) payload['stock_quantity'] = stockQuantity;
    if (inStock != null) payload['in_stock'] = inStock;

    // مدیا
    if (imageMediaId != null) payload['image_media_id'] = imageMediaId;
    if (featuredImageUrl != null) payload['image_url'] = featuredImageUrl;
    if (galleryMediaIds != null && galleryMediaIds.isNotEmpty) {
      payload['gallery_media_ids'] = galleryMediaIds;
    }

    // دسته‌بندی / خصوصیات / ورییشن‌ها
    if (categoryIds != null && categoryIds!.isNotEmpty) {
      payload['category_ids'] = categoryIds;
    }
    if (brandIds != null && brandIds!.isNotEmpty) {
      payload['brand_ids'] = brandIds;
    }
    if (attributes != null && attributes!.isNotEmpty) {
      payload['attributes'] = attributes;
    }
    // ورییشن‌ها
    if (type == 'variable') {
      final list = variationsOverride ?? variations;
      if (list != null && list.isNotEmpty) {
        payload['variations'] = list;
      }
    }

    return payload;
  }
}
