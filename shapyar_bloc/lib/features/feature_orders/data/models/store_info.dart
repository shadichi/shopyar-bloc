import 'package:hive/hive.dart';

part 'store_info.g.dart';

@HiveType(typeId: 0) // تعیین یک شناسه یکتا
class StoreInfo extends HiveObject {
  @HiveField(0)
  String storeName;

  @HiveField(1)
  String storeAddress;

  @HiveField(2)
  String phoneNumber;

  @HiveField(3)
  String instagram;

  @HiveField(4)
  String postalCode;

  @HiveField(5)
  String website;

  @HiveField(6)
  String storeIcon;

  StoreInfo({
    required this.storeName,
    required this.storeAddress,
    required this.phoneNumber,
    required this.instagram,
    required this.postalCode,
    required this.website,
    required this.storeIcon,
  });
}
