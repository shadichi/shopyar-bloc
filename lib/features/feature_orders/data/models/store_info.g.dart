
part of 'store_info.dart';

class StoreInfoAdapter extends TypeAdapter<StoreInfo> {
  @override
  final int typeId = 0;

  @override
  StoreInfo read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return StoreInfo(
      storeName: fields[0] as String,
      storeAddress: fields[1] as String,
      phoneNumber: fields[2] as String,
      instagram: fields[3] as String,
      postalCode: fields[4] as String,
      website: fields[5] as String,
      storeIcon: fields[6] as String,
    );
  }

  @override
  void write(BinaryWriter writer, StoreInfo obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.storeName)
      ..writeByte(1)
      ..write(obj.storeAddress)
      ..writeByte(2)
      ..write(obj.phoneNumber)
      ..writeByte(3)
      ..write(obj.instagram)
      ..writeByte(4)
      ..write(obj.postalCode)
      ..writeByte(5)
      ..write(obj.website)
      ..writeByte(6)
      ..write(obj.storeIcon);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StoreInfoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
