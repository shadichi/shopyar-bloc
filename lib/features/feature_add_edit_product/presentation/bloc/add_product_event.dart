part of 'add_product_bloc.dart';

@immutable
abstract class AddProductEvent {}


class AddProductsDataLoad extends AddProductEvent{
  AddProductsDataLoad();
}

class PickImageFromGalleryRequested extends AddProductEvent {}

class ClearPickedImage extends AddProductEvent {}

class UploadPickedImageRequested extends AddProductEvent {}

class PickGalleryRequested extends AddProductEvent {}             // انتخاب چندتایی

class RemoveGalleryAtRequested extends AddProductEvent {          // حذف یکی
  final int index;
  RemoveGalleryAtRequested(this.index);
}

class ClearGalleryRequested extends AddProductEvent {}            // پاک‌کردن همه

class SelectAttribute extends AddProductEvent {
  final String value;
  SelectAttribute(this.value);
}


