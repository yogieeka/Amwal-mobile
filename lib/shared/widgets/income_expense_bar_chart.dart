import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/formatters.dart';

/// Bar chart widget for displaying income vs expense comparison
class IncomeExpenseBarChart extends StatelessWidget {
  final double income;
  final double expense;
  final double zakatSedekah;

  const IncomeExpenseBarChart({
    super.key,
    required this.income,
    required this.expense,
    required this.zakatSedekah,
  });

  @override
  Widget build(BuildContext context) {
    if (income == 0 && expense == 0 && zakatSedekah == 0) {
      return _buildEmptyState();
    }

    final maxValue = [income, expense, zakatSedekah].reduce((a, b) => a > b ? a : b);

    return Column(
      children: [
        SizedBox(
          height: 200,
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,
              maxY: maxValue * 1.2,
              minY: 0,
              barTouchData: BarTouchData(
                enabled: true,
                touchTooltipData: BarTouchTooltipData(
                  tooltipBgColor: AppColors.grey800,
                  getTooltipItem: (group, groupIndex, rod, rodIndex) {
                    String label = '';
                    switch (group.x.toInt()) {
                      case 0:
                        label = 'Pemasukan';
                        break;
                      case 1:
                        label = 'Pengeluaran';
                        break;
                      case 2:
                        label = 'Zakat/Sedekah';
                        break;
                    }
                    return BarTooltipItem(
                      '$label\n${Formatters.formatCompactCurrency(rod.toY)}',
                      const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    );
                  },
                ),
              ),
              titlesData: FlTitlesData(
                show: true,
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      switch (value.toInt()) {
                        case 0:
                          return const Text(
                            'Masuk',
                            style: TextStyle(fontSize: 11),
                          );
                        case 1:
                          return const Text(
                            'Keluar',
                            style: TextStyle(fontSize: 11),
                          );
                        case 2:
                          return const Text(
                            'Zakat',
                            style: TextStyle(fontSize: 11),
                          );
                        default:
                          return const Text('');
                      }
                    },
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 50,
                    getTitlesWidget: (value, meta) {
                      if (value == 0) return const Text('');
                      return Text(
                        Formatters.formatCompactCurrency(value),
                        style: const TextStyle(fontSize: 10),
                      );
                    },
                  ),
                ),
                topTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
              ),
              gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
                horizontalInterval: maxValue / 4,
                getDrawingHorizontalLine: (value) {
                  return FlLine(
                    color: AppColors.grey200,
                    strokeWidth: 1,
                  );
                },
              ),
              borderData: FlBorderData(
                show: false,
              ),
              barGroups: [
                BarChartGroupData(
                  x: 0,
                  barRods: [
                    BarChartRodData(
                      toY: income,
                      color: AppColors.income,
                      width: 40,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(6),
                      ),
                    ),
                  ],
                ),
                BarChartGroupData(
                  x: 1,
                  barRods: [
                    BarChartRodData(
                      toY: expense,
                      color: AppColors.expense,
                      width: 40,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(6),
                      ),
                    ),
                  ],
                ),
                BarChartGroupData(
                  x: 2,
                  barRods: [
                    BarChartRodData(
                      toY: zakatSedekah,
                      color: AppColors.zakat,
                      width: 40,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(6),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        _buildSummary(),
      ],
    );
  }

  Widget _buildSummary() {
    final balance = income - expense - zakatSedekah;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildSummaryItem('Masuk', income, AppColors.income),
        _buildSummaryItem('Keluar', expense, AppColors.expense),
        _buildSummaryItem('Saldo', balance,
          balance >= 0 ? AppColors.success : AppColors.error),
      ],
    );
  }

  Widget _buildSummaryItem(String label, double amount, Color color) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: AppColors.grey600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          Formatters.formatCompactCurrency(amount),
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Container(
      height: 200,
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.bar_chart_outlined,
            size: 64,
            color: AppColors.grey400,
          ),
          const SizedBox(height: 12),
          Text(
            'Belum ada data transaksi',
            style: TextStyle(
              color: AppColors.grey600,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
