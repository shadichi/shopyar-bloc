import 'dart:io';
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';
import 'package:dio/dio.dart';
import 'package:shopyar/core/utils/static_values.dart';

class AddProductsGetDataApiProvider {
  final Dio _dio = Dio();

  Future<dynamic> getData() async {
    print('11');
    var response = await _dio.get(
        "${StaticValues.webService}/wp-json/shop-yar/catalog/bootstrap",
        options: Options(headers: {'Authorization': StaticValues.passWord}));
    print('21');

    print('response.data');
    print(response.data);
    return response;
  }
  Future<dynamic> submitProduct({
    // الزامی
    required String name,

    // عمومی
    String type = 'simple',                  // 'simple' | 'variable'
    String? status,                          // 'publish' | 'draft' | 'pending' | 'private'
    String? sku,
    String? regularPrice,
    String? salePrice,
    String? description,
    String? shortDescription,

    // موجودی
    bool? manageStock,
    int? stockQuantity,
    bool? inStock,

    // مدیا
    File? featuredFile,                      // اگر بدی، خودش آپلود می‌کند و image_media_id ست می‌شود
    List<File> galleryFiles = const [],      // اگر بدی، خودش آپلود می‌کند و gallery_media_ids ست می‌شود
    String? featuredImageUrl,                // اگر بخواهی به‌جای آپلود، sideload شود

    // دسته‌بندی/خصوصیات
    List<int>? categoryIds,
    List<Map<String, dynamic>>? attributes,  // [{"name":"pa_color","options":["red","blue"],"visible":true,"variation":true}]
    List<Map<String, dynamic>>? variations,  // [{"attributes":{"pa_color":"red"},"regular_price":"..."}]
  }) async {
    print('submitProduct: start');

    // =============== helper: upload one media ===============
    Future<int> _uploadMedia(File file, {String? title}) async {
      final path = file.path;
      final fileName = path.split('/').last;

      final mime = lookupMimeType(path) ?? 'application/octet-stream';
      final mediaType = MediaType.parse(mime);

      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          path,
          filename: fileName,
          contentType: mediaType,
        ),
        if (title != null) 'title': title,
      });

      final res = await _dio.post(
        "${StaticValues.webService}/wp-json/wp/v2/media",
        data: formData,
        options: Options(
          headers: {
            'Authorization': StaticValues.passWord,
            'Accept': 'application/json',
            'Content-Type': 'multipart/form-data',
            'Content-Disposition': 'attachment; filename="$fileName"',
          },
        ),
      );
      final id = (res.data['id'] as num).toInt();
      print('uploadMedia: ok id=$id');
      return id;
    }

    // =============== 1) upload media(s) if provided ===============
    int? imageMediaId;
    if (featuredFile != null) {
      imageMediaId = await _uploadMedia(featuredFile, title: 'featured');
    }

    List<int> galleryMediaIds = [];
    if (galleryFiles.isNotEmpty) {
      for (final f in galleryFiles) {
        final id = await _uploadMedia(f);
        galleryMediaIds.add(id);
      }
    }

    // =============== 2) build payload ===============
    final Map<String, dynamic> payload = {
      'type': type,
      'name': name,
    };

    if (status != null) payload['status'] = status;
    if (sku != null && sku.isNotEmpty) payload['sku'] = sku;
    if (regularPrice != null) payload['regular_price'] = regularPrice;
    if (salePrice != null) payload['sale_price'] = salePrice;
    if (description != null) payload['description'] = description;
    if (shortDescription != null) payload['short_description'] = shortDescription;

    if (manageStock != null) payload['manage_stock'] = manageStock;
    if (stockQuantity != null) payload['stock_quantity'] = stockQuantity;
    if (inStock != null) payload['in_stock'] = inStock;

    if (imageMediaId != null) payload['image_media_id'] = imageMediaId;
    if (featuredImageUrl != null) payload['image_url'] = featuredImageUrl;

    if (galleryMediaIds.isNotEmpty) payload['gallery_media_ids'] = galleryMediaIds;
    if (categoryIds != null && categoryIds!.isNotEmpty) {
      payload['category_ids'] = categoryIds;
    }
    if (attributes != null && attributes!.isNotEmpty) {
      payload['attributes'] = attributes;
    }
    if (type == 'variable' && variations != null && variations!.isNotEmpty) {
      payload['variations'] = variations;
    }

    print('submitProduct: payload => $payload');

    // =============== 3) call create_item endpoint ===============
    final res = await _dio.post(
      "${StaticValues.webService}/wp-json/shop-yar/v1/create-item",
      data: payload,
      options: Options(
        headers: {
          'Authorization': StaticValues.passWord,
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      ),
    );

    print('submitProduct: done status=${res.statusCode}');
    print('submitProduct: response => ${res.data}');
    return res;
  }

}

