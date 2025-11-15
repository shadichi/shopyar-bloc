import 'dart:io';
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';
import 'package:dio/dio.dart';
import 'package:shopyar/core/utils/static_values.dart';

import '../../models/product_submit_model.dart';

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
  Future<dynamic> submitProduct(ProductSubmitModel model) async {
    print('submitProduct: start');

    // =============== helper: upload one media ===============
    Future<int> _uploadMedia(File file, {String? title}) async {
      try {
        final path = file.path;
        final fileName = path.split('/').last;

        final mime = lookupMimeType(path) ?? 'application/octet-stream';
        final mediaType = MediaType.parse(mime);

        final formData = FormData.fromMap({
          // طبق PHP: $_FILES['file']
          'file': await MultipartFile.fromFile(
            path,
            filename: fileName,
            contentType: mediaType,
          ),
          if (title != null) 'title': title,
        });

        final res = await _dio.post(
          "${StaticValues.webService}/wp-json/shop-yar/upload",
          data: formData,
          options: Options(
            headers: {
              'Authorization': StaticValues.passWord,   // همون توکن پلاگین
              'Accept': 'application/json',
              'Content-Type': 'multipart/form-data',
            },
          ),
        );

        print('uploadMedia: status=${res.statusCode}');
        print('uploadMedia: data=${res.data}');

        // ساختار پاسخ handle_upload تو PHP:
        // ['success'=>true,'items'=>[ ['index'=>0,'id'=>123,'url'=>'...'], ... ]]
        final data = res.data as Map<String, dynamic>;
        if (data['success'] != true) {
          throw Exception('uploadMedia: success=false | $data');
        }

        final items = (data['items'] as List);
        if (items.isEmpty) {
          throw Exception('uploadMedia: empty items');
        }

        final first = items.first as Map<String, dynamic>;
        final id = (first['id'] as num).toInt();
        print('uploadMedia: ok id=$id');

        return id;
      } catch (e) {
        print("error in _uploadMedia:");
        print(e);
        rethrow; // بذار بالا همون DioException یا Exception واقعی رو ببینه
      }
    }


    // =============== 1) upload media(s) if provided ===============
    int? imageMediaId;
    if (model.featuredFile != null) {
      imageMediaId = await _uploadMedia(model.featuredFile!, title: 'featured');
    }

    List<int> galleryMediaIds = [];
    if (model.galleryFiles.isNotEmpty) {
      for (final f in model.galleryFiles) {
        final id = await _uploadMedia(f);
        galleryMediaIds.add(id);
      }
    }

    // =============== 2) build payload from model ===============
    final payload = model.toJson(
      imageMediaId: imageMediaId,
      galleryMediaIds: galleryMediaIds,
    );

    print('submitProduct: payload => $payload');

    // =============== 3) call /shop-yar/products ===============
    final res = await _dio.post(
      "${StaticValues.webService}/wp-json/shop-yar/products",
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

