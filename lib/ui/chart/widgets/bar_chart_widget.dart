import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/date_utils.dart';
import '../../../data/models/transaction.dart';

class MonthlyBarChart extends StatelessWidget {
  static final Color _incomeColor = AppColors.income.withValues(alpha: 0.8);
  static final Color _expenseColor = AppColors.expense.withValues(alpha: 0.8);

  final List<Transaction> allTransactions;

  const MonthlyBarChart({super.key, required this.allTransactions});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final months = List.generate(6,
        (i) => DateTime(now.year, now.month - 5 + i));

    final groups = List.generate(months.length, (i) {
      final m = months[i];
      final monthly = allTransactions.where(
          (t) => t.date.year == m.year && t.date.month == m.month);
      final inc = monthly
          .where((t) => t.isIncome)
          .fold(0.0, (s, t) => s + t.amount);
      final exp = monthly
          .where((t) => !t.isIncome)
          .fold(0.0, (s, t) => s + t.amount);
      return BarChartGroupData(
        x: i,
        barRods: [
          BarChartRodData(
            toY: inc,
            color: _incomeColor,
            width: 14,
            borderRadius: BorderRadius.circular(4),
          ),
          BarChartRodData(
            toY: exp,
            color: _expenseColor,
            width: 14,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
        barsSpace: 4,
      );
    });

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              _legend(_incomeColor, '収入'),
              const SizedBox(width: 16),
              _legend(_expenseColor, '支出'),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 240,
            child: BarChart(
              BarChartData(
                barGroups: groups,
                gridData: FlGridData(
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (_) => const FlLine(
                    color: AppColors.divider,
                    strokeWidth: 1,
                  ),
                ),
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (v, _) => Text(
                        '${months[v.toInt()].month}月',
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ),
                  leftTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                borderData: FlBorderData(show: false),
                barTouchData: BarTouchData(
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      final label = rodIndex == 0 ? '収入' : '支出';
                      return BarTooltipItem(
                        '$label\n¥${AppDateUtils.formatAmount(rod.toY)}',
                        const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _legend(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 12, height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 12,
            color: AppColors.textSecondary)),
      ],
    );
  }
}
