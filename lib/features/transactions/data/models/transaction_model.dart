import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';
import '../../../../core/constants/enums.dart';

part 'transaction_model.freezed.dart';
part 'transaction_model.g.dart';

@freezed
@HiveType(typeId: 0)
class TransactionModel with _$TransactionModel {
  const factory TransactionModel({
    @HiveField(0) required String id,
    @HiveField(1) required String title,
    @HiveField(2) required double amount,
    @HiveField(3) required TransactionType type,
    @HiveField(4) required String category,
    @HiveField(5) required DateTime date,
    @HiveField(6) String? description,
    @HiveField(7) String? notes,
    @HiveField(8) @Default(false) bool isRecurring,
    @HiveField(9) String? recurringPeriod,
    @HiveField(10) @Default([]) List<String> tags,
    @HiveField(11) required DateTime createdAt,
    @HiveField(12) DateTime? updatedAt,
  }) = _TransactionModel;

  factory TransactionModel.fromJson(Map<String, dynamic> json) =>
      _$TransactionModelFromJson(json);
}

// Hive Type Adapters for enums
class TransactionTypeAdapter extends TypeAdapter<TransactionType> {
  @override
  final int typeId = 1;

  @override
  TransactionType read(BinaryReader reader) {
    final index = reader.readByte();
    return TransactionType.values[index];
  }

  @override
  void write(BinaryWriter writer, TransactionType obj) {
    writer.writeByte(obj.index);
  }
}
