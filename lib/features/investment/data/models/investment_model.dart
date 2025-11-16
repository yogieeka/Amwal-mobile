import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

part 'investment_model.freezed.dart';
part 'investment_model.g.dart';

/// Investment type enum
@HiveType(typeId: 3)
enum InvestmentType {
  @HiveField(0)
  sukuk, // Islamic bonds
  @HiveField(1)
  sahamSyariah, // Shariah-compliant stocks
  @HiveField(2)
  reksadanaSyariah, // Islamic mutual funds
  @HiveField(3)
  emas, // Gold
  @HiveField(4)
  properti, // Property
  @HiveField(5)
  deposito, // Deposits
  @HiveField(6)
  bisnis, // Business
}

extension InvestmentTypeExtension on InvestmentType {
  String get displayName {
    switch (this) {
      case InvestmentType.sukuk:
        return 'Sukuk';
      case InvestmentType.sahamSyariah:
        return 'Saham Syariah';
      case InvestmentType.reksadanaSyariah:
        return 'Reksadana Syariah';
      case InvestmentType.emas:
        return 'Emas';
      case InvestmentType.properti:
        return 'Properti';
      case InvestmentType.deposito:
        return 'Deposito Syariah';
      case InvestmentType.bisnis:
        return 'Bisnis';
    }
  }
}

/// Investment model for tracking Islamic investments
@freezed
@HiveType(typeId: 4)
class InvestmentModel with _$InvestmentModel {
  const factory InvestmentModel({
    @HiveField(0) required String id,
    @HiveField(1) required String name,
    @HiveField(2) required InvestmentType type,
    @HiveField(3) required double initialAmount,
    @HiveField(4) required double currentValue,
    @HiveField(5) required DateTime startDate,
    @HiveField(6) DateTime? endDate,
    @HiveField(7) @Default('') String description,
    @HiveField(8) @Default(0.0) double expectedReturn, // Expected return percentage
    @HiveField(9) @Default(true) bool isActive,
    @HiveField(10) @Default('') String notes,
  }) = _InvestmentModel;

  factory InvestmentModel.fromJson(Map<String, dynamic> json) =>
      _$InvestmentModelFromJson(json);
}

/// Investment statistics
class InvestmentStats {
  final double totalInvested;
  final double totalCurrentValue;
  final double totalProfit;
  final double totalReturn; // Percentage
  final int activeInvestments;
  final Map<InvestmentType, double> investmentByType;

  InvestmentStats({
    required this.totalInvested,
    required this.totalCurrentValue,
    required this.totalProfit,
    required this.totalReturn,
    required this.activeInvestments,
    required this.investmentByType,
  });
}
