part of 'add_product_bloc.dart';

class AddProductState extends Equatable {
  final AddProductStatus addProductStatus;

  // feature image
  final File? featuredImage;
  final bool isPickingImage;
  final bool isUploadingImage;
  final int? imageMediaId; //upload result

  //count of current selected att
  final int attList;

  // gallery
  final List<File> galleryImages;
  final bool isPickingGallery;
  final bool isUploadingGallery;

  // error
  final String? imageError;

  //for attribute selection
  final List<String> allAttributes;
  final List<String> availableAttributes;
  final List<String> selectedAttributes;

  const AddProductState({
    required this.addProductStatus,
    this.featuredImage,
    this.galleryImages = const [],
    this.isPickingGallery = false,
    this.isPickingImage = false,
    this.isUploadingImage = false,
    this.isUploadingGallery = false,
    this.imageError,
    this.imageMediaId,
    this.attList = 0,
     this.allAttributes = const [],
     this.availableAttributes= const [],
     this.selectedAttributes= const [],
  });

  AddProductState copyWith({
    AddProductStatus? newAddProductStatus,
    // feature image
    File? newImageFile,
    bool clearImageFile = false,
    bool? newIsPickingImage,
    bool? newIsUploadingImage,
    int? newImageMediaId,
    // gallery
    List<File>? galleryImages,
    bool appendGallery = false, // اگر true باشد، galleryImages اضافه می‌شود نه جایگزین
    bool? newIsPickingGallery,
    bool? newIsUploadingGallery,
    // error
    String? newImageError,
    int? newAttList,
    List<String>? newAllAttributes,
    List<String>? newAvailableAttributes,
    List<String>? newSelectedAttributes,
  }) {
    // محاسبه‌ی featuredImage با احترام به clearImageFile
    final File? nextFeatured =
    clearImageFile ? null : (newImageFile ?? featuredImage);

    // محاسبه‌ی گالری (افزودن یا جایگزینی یا حفظ قبلی)
    List<File> nextGallery = this.galleryImages;
    if (appendGallery && galleryImages != null) {
      nextGallery = <File>[...this.galleryImages, ...galleryImages];
    } else if (galleryImages != null) {
      nextGallery = <File>[...galleryImages];
    }

    return AddProductState(
      addProductStatus: newAddProductStatus ?? addProductStatus,

      featuredImage: nextFeatured,
      isPickingImage: newIsPickingImage ?? isPickingImage,
      isUploadingImage: newIsUploadingImage ?? isUploadingImage,
      imageMediaId: newImageMediaId ?? imageMediaId,

      galleryImages: nextGallery,
      isPickingGallery: newIsPickingGallery ?? isPickingGallery,
      isUploadingGallery: newIsUploadingGallery ?? isUploadingGallery,

      imageError: newImageError ?? imageError,
      attList: newAttList ?? attList,
      allAttributes: newAllAttributes ?? this.allAttributes,
      availableAttributes: newAvailableAttributes ?? this.availableAttributes,
      selectedAttributes: newSelectedAttributes ?? this.selectedAttributes,
    );
  }

  @override
  List<Object?> get props => [
    addProductStatus,
    featuredImage,
    galleryImages,
    isPickingImage,
    isPickingGallery,
    isUploadingImage,
    isUploadingGallery,
    imageError,
    imageMediaId,
    attList,
    allAttributes,
    availableAttributes,
    selectedAttributes
  ];
}
