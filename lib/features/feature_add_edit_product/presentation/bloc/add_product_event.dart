part of 'add_product_bloc.dart';

@immutable
abstract class AddProductEvent {}


class AddProductsDataLoadEvent extends AddProductEvent{

  AddProductsDataLoadEvent();

}

class PickImageFromGalleryRequestedEvent extends AddProductEvent {}

class ClearPickedImageEvent extends AddProductEvent {}

class UploadPickedImageRequestedEvent extends AddProductEvent {}

class PickGalleryRequestedEvent extends AddProductEvent {}             // انتخاب چندتایی

class RemoveGalleryAtRequestedEvent extends AddProductEvent {          // حذف یکی
  final int index;
  RemoveGalleryAtRequestedEvent(this.index);
}

class ClearGalleryRequestedEvent extends AddProductEvent {}            // پاک‌کردن همه

class SelectAttributeEvent extends AddProductEvent {
  final Attribute value;
  SelectAttributeEvent(this.value);
}
class AddAttributeEvent extends AddProductEvent {
  final List<Attribute> attribute;
  AddAttributeEvent(this.attribute);
}
class SetTypeOfProductEvent extends AddProductEvent {
  final ProductType  productType;
  SetTypeOfProductEvent(this.productType);
}
class ToggleTermEvent extends AddProductEvent{
  final String attributeName;
  final bool selected;
  final String termSlug; // ← اسم را termSlug بگذار
  ToggleTermEvent(this.attributeName, this.termSlug, this.selected);
}


class RemoveSelectedAttributeEvent extends AddProductEvent{
  final Attribute attribute;
  RemoveSelectedAttributeEvent(this.attribute);
}

class SubmitProductBlocEvent extends AddProductEvent{
  ProductSubmitModel model;
  SubmitProductBlocEvent(this.model);
}
class ResetSubmitProductStatusEvent extends AddProductEvent{
  ResetSubmitProductStatusEvent();
}


