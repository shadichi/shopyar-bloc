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
  final bool isSimpleProduct;

  // error
  final String? imageError;

  //for attribute selection
  final List<String> allAttributes;
  final List<Attribute> availableAttributes;
  final List<Attribute> selectedAttributes;
  final Map<String, Set<String>> selectedTerms;


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
    this.isSimpleProduct = true,
    required this.selectedTerms,
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
    List<Attribute>? newAvailableAttributes,
    List<Attribute>? newSelectedAttributes,
    bool? newIsSimpleProduct,
    Map<String, Set<String>>? newSelectedTerms,

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
      isSimpleProduct: newIsSimpleProduct ?? this.isSimpleProduct,
      selectedTerms: newSelectedTerms ?? selectedTerms,

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
    selectedAttributes,
    isSimpleProduct,
    selectedTerms
  ];
}
