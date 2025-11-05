import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:equatable/equatable.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:shopyar/core/resources/data_state.dart';
import '../../../../core/params/products_params.dart';
import '../../../../core/resources/add_product_data_state.dart';
import '../../../../core/resources/order_data_state.dart';
import '../../data/models/add_order_data_model.dart';
import '../../domain/use_cases/add_product_get_products_use_case.dart';
import '../../domain/use_cases/upload_image_use_case.dart';
import 'add_product_status.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'add_product_event.dart';

part 'add_product_state.dart';

class AddProductBloc extends Bloc<AddProductEvent, AddProductState> {
  AddProductGetDataNeededUseCase addProductGetDataNeededUseCase;
  UploadImageUseCase uploadImageUseCase;

  final _picker = ImagePicker();

  AddProductBloc(this.addProductGetDataNeededUseCase, this.uploadImageUseCase)
      : super(
          AddProductState(
            addProductStatus: AddProductsDataLoading(),
            featuredImage: null,
            allAttributes: const [],
            availableAttributes: const [],
            selectedAttributes: const [],
          ),
        ) {
    on<AddProductsDataLoad>((event, emit) async {
      emit(state.copyWith(newAddProductStatus: AddProductsDataLoading()));

      final AddProductDataState result =
          await addProductGetDataNeededUseCase(InfParams("", false, "", false));
      if (result is AddProductDataSuccess) {
        try {
          final model = AddProductDataModel.fromJson(
            result.data as Map<String, dynamic>,
          );

          emit(
            state.copyWith(
              newAddProductStatus: AddProductsDataLoaded(model),
            ),
          );
        } catch (e, st) {
          print('❌ خطا در پارس کردن AddProductDataModel: $e');
          print(st);
          emit(state.copyWith(newAddProductStatus: AddProductsDataError()));
        }
      } else {
        emit(state.copyWith(newAddProductStatus: AddProductsDataError()));
      }
    });

    on<PickImageFromGalleryRequested>((event, emit) async {
      emit(state.copyWith(newIsPickingImage: true, newImageError: null));
      try {
        final x = await _picker.pickImage(source: ImageSource.gallery);
        if (x == null) {
          emit(state.copyWith(newIsPickingImage: false));
          return;
        }
        emit(state.copyWith(
          newIsPickingImage: false,
          newImageFile: File(x.path),
        ));
      } catch (e) {
        emit(state.copyWith(
            newIsPickingImage: false, newImageError: e.toString()));
      }
    });

    on<ClearPickedImage>((event, emit) {
      print("ClearPickedImage");
      emit(state.copyWith(
        clearImageFile: true,
        newIsPickingImage: false,
        newImageFile: null,
      )); // print("ClearPickedImage");
    });

    on<PickGalleryRequested>((event, emit) async {
      emit(state.copyWith(newIsPickingGallery: true, newImageError: null));
      try {
        final picker = ImagePicker();
        final List<XFile> picked = await picker.pickMultiImage(); // چندتایی
        if (picked.isEmpty) {
          emit(state.copyWith(newIsPickingGallery: false));
          return;
        }

        // اگر ذخیره نمی‌کنی، مستقیماً File از path بساز:
        final files = picked.map((x) => File(x.path)).toList();

        // اگر می‌خواهی پایدار ذخیره کنی، هر xfile را saveTo کنی و بعد File بسازی.

        emit(state.copyWith(
          newIsPickingGallery: false,
          galleryImages: files,
          appendGallery: true, // تصاویر جدید به انتها اضافه شوند
        ));
      } catch (e) {
        emit(state.copyWith(
            newIsPickingGallery: false, newImageError: e.toString()));
      }
    });

    on<RemoveGalleryAtRequested>((event, emit) {
      final list = [...state.galleryImages];
      if (event.index >= 0 && event.index < list.length) {
        list.removeAt(event.index);
        emit(state.copyWith(galleryImages: list));
      }
    });

    on<ClearGalleryRequested>((event, emit) {
      emit(state.copyWith(
        galleryImages: [],
      ));
    });

    on<SelectAttribute>((event, emit) {
      final selected = List<Attribute>.from(state.selectedAttributes);
      final available = List<Attribute>.from(state.availableAttributes);

      // از لیست قابل‌انتخاب‌ها حذفش کن
      available.remove(event.value);

      // به لیست انتخاب‌شده‌ها اضافه کن
      selected.add(event.value);

      emit(state.copyWith(
        newAvailableAttributes: available,
        newSelectedAttributes: selected,
      ));
    });

    on<AddAttribute>((event, emit) {
      final selected = List<Attribute>.from(state.selectedAttributes);
      final available = List<Attribute>.from(state.availableAttributes);

      if (event.attribute.isNotEmpty) {
        available.clear();
        for (final attr in event.attribute) {
          available.add(attr);
        }
      }

      emit(state.copyWith(
        newAvailableAttributes: available,
        newSelectedAttributes: selected,
      ));
    });

    on<SetTypeOfProduct>((event, emit) {
      emit(state.copyWith(
        newIsSimpleProduct: event.isSimpleProduct
      ));
    });

/*
    on<UploadGalleryRequested>((event, emit) async {
      if (state.galleryImages.isEmpty) return;
      emit(state.copyWith(newIsUploadingGallery: true, newerror: null));

      try {
        final uri = Uri.parse('https://shop-yar.ir/wp-json/shop-yar/upload');
        final req = http.MultipartRequest('POST', uri)
          ..headers['authorization'] = 'shadi2';

        // files[] برای چندتایی
        for (final f in state.galleryImages) {
          req.files.add(await http.MultipartFile.fromPath('files[]', f.path));
        }

        final resp = await req.send();
        final body = await resp.stream.bytesToString();
        if (resp.statusCode < 200 || resp.statusCode >= 300) {
          throw Exception('Upload failed: ${resp.statusCode} $body');
        }

        // پاسخ: { success:true, items:[ { id, url, index }, ... ] }
        final json = jsonDecode(body) as Map<String, dynamic>;
        final items = (json['items'] as List).cast<Map<String, dynamic>>();
        final ids = <int>[];
        for (final it in items) {
          final id = it['id'];
          if (id is int) ids.add(id);
          if (id is String) ids.add(int.tryParse(id) ?? 0);
        }

        emit(state.copyWith(
          isUploadingGallery: false,
          galleryMediaIds: ids.where((e) => e > 0).toList(),
        ));
      } catch (e) {
        emit(state.copyWith(isUploadingGallery: false, error: e.toString()));
      }
    });
*/

/*
     on<UploadPickedImageRequested>((event, emit) async {
      if (state.featuredImage == null) return;
      emit(state.copyWith(newIsUploadingImage: true, newImageError: null));
      OrderDataState dataState = await uploadImageUseCase(InfParams("0", false, "search", false));
      if(dataState is OrderDataSuccess ){
        emit
      }
      try {
        final uri = Uri.parse('https://shop-yar.ir/wp-json/shop-yar/upload');
        final req = http.MultipartRequest('POST', uri)
          ..headers['authorization'] = 'shadi2'
          ..files.add(await http.MultipartFile.fromPath('file', state.imageFile!.path));

      final resp = await req.send();
      final body = await resp.stream.bytesToString();
      if (resp.statusCode < 200 || resp.statusCode >= 300) {
      throw Exception('Upload failed: ${resp.statusCode} $body');
      }
      // خروجی: { success:true, items:[ { id: 345, url: ... } ] }
      final json = jsonDecode(body) as Map<String, dynamic>;
      final items = (json['items'] as List).cast<Map<String, dynamic>>();
      final mediaId = (items.isNotEmpty ? items.first['id'] : null) as int?;

      emit(state.copyWith(isUploadingImage: false, imageMediaId: mediaId));
      } catch (e) {
      emit(state.copyWith(isUploadingImage: false, imageError: e.toString()));
      }
    });
*/
  }
}
