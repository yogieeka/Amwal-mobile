import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

part 'zakat_model.freezed.dart';
part 'zakat_model.g.dart';

/// Enum for zakat types
enum ZakatType {
  mal, // Zakat Harta
  penghasilan, // Zakat Penghasilan
  perdagangan, // Zakat Perdagangan
  pertanian, // Zakat Pertanian
  fitrah, // Zakat Fitrah
}

/// Extension for ZakatType
extension ZakatTypeExtension on ZakatType {
  String get displayName {
    switch (this) {
      case ZakatType.mal:
        return 'Zakat Mal (Harta)';
      case ZakatType.penghasilan:
        return 'Zakat Penghasilan';
      case ZakatType.perdagangan:
        return 'Zakat Perdagangan';
      case ZakatType.pertanian:
        return 'Zakat Pertanian';
      case ZakatType.fitrah:
        return 'Zakat Fitrah';
    }
  }
}

@freezed
@HiveType(typeId: 2)
class ZakatModel with _$ZakatModel {
  const factory ZakatModel({
    @HiveField(0) required String id,
    @HiveField(1) required ZakatType type,
    @HiveField(2) required double amount,
    @HiveField(3) required double totalWealth,
    @HiveField(4) required double nisab,
    @HiveField(5) required bool isWajib,
    @HiveField(6) required DateTime calculatedDate,
    @HiveField(7) String? notes,
    @HiveField(8) Map<String, dynamic>? details,
    @HiveField(9) @Default(false) bool isPaid,
    @HiveField(10) DateTime? paidDate,
    @HiveField(11) required DateTime createdAt,
    @HiveField(12) DateTime? updatedAt,
  }) = _ZakatModel;

  factory ZakatModel.fromJson(Map<String, dynamic> json) =>
      _$ZakatModelFromJson(json);
}

/// Hive Type Adapter for ZakatType
class ZakatTypeAdapter extends TypeAdapter<ZakatType> {
  @override
  final int typeId = 3;

  @override
  ZakatType read(BinaryReader reader) {
    final index = reader.readByte();
    return ZakatType.values[index];
  }

  @override
  void write(BinaryWriter writer, ZakatType obj) {
    writer.writeByte(obj.index);
  }
}
