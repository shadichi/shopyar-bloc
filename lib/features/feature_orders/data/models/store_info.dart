import 'package:hive/hive.dart';

part 'store_info.g.dart';

@HiveType(typeId: 0) //for each hive model
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

  @HiveField(7)
  String? storeSenderName;

  @HiveField(8)
  String? storeNote;


  StoreInfo({
    required this.storeName,
    required this.storeAddress,
    required this.phoneNumber,
    required this.instagram,
    required this.postalCode,
    required this.website,
    required this.storeIcon,
     this.storeSenderName,
     this.storeNote,
  });
}
