import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:equatable/equatable.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:shopyar/core/resources/data_state.dart';
import 'package:shopyar/features/feature_add_edit_product/presentation/bloc/submit_product_status.dart';
import '../../../../core/params/products_params.dart';
import '../../../../core/resources/add_product_data_state.dart';
import '../../../../core/resources/order_data_state.dart';
import '../../data/models/add_order_data_model.dart';
import '../../data/models/product_submit_model.dart';
import '../../domain/use_cases/add_product_get_products_use_case.dart';
import '../../domain/use_cases/submit_product_use_case.dart';
import '../screens/product_form_screen.dart';
import 'add_product_status.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'add_product_event.dart';

part 'add_product_state.dart';

class AddProductBloc extends Bloc<AddProductEvent, AddProductState> {
  AddProductGetDataNeededUseCase addProductGetDataNeededUseCase;
  SubmitProductUseCase submitProductUseCase;

  final _picker = ImagePicker();

  AddProductBloc(this.addProductGetDataNeededUseCase, this.submitProductUseCase)
      : super(
          AddProductState(
            addProductStatus: AddProductsDataLoading(),
            featuredImage: null,
            allAttributes: const [],
            availableAttributes: const [],
            selectedAttributes: const [],
            selectedTerms: {} ,
            productType: ProductType.simple, submitProductStatus: SubmitProductInitial(),
          ),
        ) {
    on<AddProductsDataLoadEvent>((event, emit) async {
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

    on<PickImageFromGalleryRequestedEvent>((event, emit) async {
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

    on<ClearPickedImageEvent>((event, emit) {
      print("ClearPickedImage");
      emit(state.copyWith(
        clearImageFile: true,
        newIsPickingImage: false,
        newImageFile: null,
      )); // print("ClearPickedImage");
    });

    on<PickGalleryRequestedEvent>((event, emit) async {
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

    on<RemoveGalleryAtRequestedEvent>((event, emit) {
      final list = [...state.galleryImages];
      if (event.index >= 0 && event.index < list.length) {
        list.removeAt(event.index);
        emit(state.copyWith(galleryImages: list));
      }
    });

    on<ClearGalleryRequestedEvent>((event, emit) {
      emit(state.copyWith(
        galleryImages: [],
      ));
    });

    on<SelectAttributeEvent>((event, emit) {
      final selected = List<Attribute>.from(state.selectedAttributes);
      final available = List<Attribute>.from(state.availableAttributes);

      available.removeWhere((a) => a.name == event.value.name);
      if (!selected.any((a) => a.name == event.value.name)) selected.add(event.value);

      final terms = Map<String, Set<String>>.from(state.selectedTerms);
      terms.putIfAbsent(event.value.name, () => <String>{});

      emit(state.copyWith(
        newAvailableAttributes: available,
        newSelectedAttributes: selected,
        newSelectedTerms: terms,
      ));
    });



    on<AddAttributeEvent>((event, emit) {
      final selected = List<Attribute>.from(state.selectedAttributes);
      final available = <Attribute>[];
      if (event.attribute.isNotEmpty) {
        available.addAll(event.attribute);
      }
      emit(state.copyWith(
        newAvailableAttributes: available,
        newSelectedAttributes: selected,
      ));
    });

    on<SetTypeOfProductEvent>((event, emit) {
      // اگر ساده شد: همه چیز مرتبط با متغیرها را ریست کن
      if (event.productType == ProductType.simple) {
        emit(state.copyWith(
          newProductType: ProductType.simple,
          newSelectedAttributes: <Attribute>[],
          newAvailableAttributes: state.availableAttributes, // یا دوباره از منبع پر کن
          newSelectedTerms: <String, Set<String>>{},
        ));
      } else {
        emit(state.copyWith(newProductType: ProductType.variable));
      }
    });

    on<ToggleTermEvent>((event, emit) {
      final map = Map<String, Set<String>>.from(state.selectedTerms);
      final current = map[event.attributeName] ?? <String>{};
      final newSet = Set<String>.from(current); // ← کپی عمیق

      if (event.selected) newSet.add(event.termSlug);
      else newSet.remove(event.termSlug);

      map[event.attributeName] = newSet;        // ← جایگزینی کامل
      emit(state.copyWith(newSelectedTerms: map));
    });

    on<RemoveSelectedAttributeEvent>((event, emit) {
      final selected = List<Attribute>.from(state.selectedAttributes);
      final available = List<Attribute>.from(state.availableAttributes);

      selected.removeWhere((a) => a.name == event.attribute.name);
      if (!available.any((a) => a.name == event.attribute.name)) {
        available.add(event.attribute);
      }

      final terms = Map<String, Set<String>>.from(state.selectedTerms);
      terms.remove(event.attribute.name);

      emit(state.copyWith(
        newSelectedAttributes: selected,
        newAvailableAttributes: available,
        newSelectedTerms: terms,
      ));
    });


    on<SubmitProductBlocEvent>((event, emit) async {
      emit(state.copyWith(newSubmitProductStatus: SubmitProductLoading()));

      final AddProductDataState result =
          await submitProductUseCase(event.model);
      if(result is AddProductDataSuccess){
        emit(state.copyWith(newSubmitProductStatus: SubmitProductLoaded()));

      }else{
        emit(state.copyWith(newSubmitProductStatus: SubmitProductError()));

      }

    });
    on<ResetSubmitProductStatusEvent>((event, emit) {
      emit(state.copyWith(
        newSubmitProductStatus: SubmitProductInitial(),
      ));
    });

    // add_product_bloc.dart (یا جایی که on<>ها هست)
    on<ClearProductFormEvent>((event, emit) {
      emit(state.copyWith(

        newSelectedAttributes: [],
        newAvailableAttributes: [],
        newSelectedTerms: {},
        newProductType: ProductType.simple,
        newSubmitProductStatus: SubmitProductInitial(),
      ));
    });


  }
}
