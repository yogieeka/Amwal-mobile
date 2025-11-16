import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/formatters.dart';

/// Pie chart widget for displaying expense categories
class ExpensePieChart extends StatelessWidget {
  final Map<String, double> categoryData;
  final double totalAmount;

  const ExpensePieChart({
    super.key,
    required this.categoryData,
    required this.totalAmount,
  });

  @override
  Widget build(BuildContext context) {
    if (categoryData.isEmpty || totalAmount == 0) {
      return _buildEmptyState();
    }

    return Column(
      children: [
        SizedBox(
          height: 200,
          child: PieChart(
            PieChartData(
              sectionsSpace: 2,
              centerSpaceRadius: 40,
              sections: _generateSections(),
              pieTouchData: PieTouchData(
                touchCallback: (FlTouchEvent event, pieTouchResponse) {},
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        _buildLegend(),
      ],
    );
  }

  List<PieChartSectionData> _generateSections() {
    final colors = [
      AppColors.primaryGreen,
      AppColors.secondaryGold,
      AppColors.accentBlue,
      AppColors.accentPurple,
      AppColors.error,
      AppColors.warning,
      AppColors.success,
      AppColors.income,
    ];

    final sortedEntries = categoryData.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return sortedEntries.asMap().entries.map((entry) {
      final index = entry.key;
      final category = entry.value.key;
      final amount = entry.value.value;
      final percentage = (amount / totalAmount * 100);
      final color = colors[index % colors.length];

      return PieChartSectionData(
        color: color,
        value: amount,
        title: '${percentage.toStringAsFixed(1)}%',
        radius: 60,
        titleStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }).toList();
  }

  Widget _buildLegend() {
    final colors = [
      AppColors.primaryGreen,
      AppColors.secondaryGold,
      AppColors.accentBlue,
      AppColors.accentPurple,
      AppColors.error,
      AppColors.warning,
      AppColors.success,
      AppColors.income,
    ];

    final sortedEntries = categoryData.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Wrap(
      spacing: 12,
      runSpacing: 8,
      children: sortedEntries.asMap().entries.map((entry) {
        final index = entry.key;
        final category = entry.value.key;
        final amount = entry.value.value;
        final color = colors[index % colors.length];
        final percentage = (amount / totalAmount * 100);

        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              '$category (${percentage.toStringAsFixed(0)}%)',
              style: const TextStyle(fontSize: 11),
            ),
          ],
        );
      }).toList(),
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
            Icons.pie_chart_outline,
            size: 64,
            color: AppColors.grey400,
          ),
          const SizedBox(height: 12),
          Text(
            'Belum ada data pengeluaran',
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
