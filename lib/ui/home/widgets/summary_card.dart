import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/date_utils.dart';

class SummaryCard extends StatelessWidget {
  final double income;
  final double expense;

  const SummaryCard({
    super.key,
    required this.income,
    required this.expense,
  });

  double get balance => income - expense;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _balanceRow(),
            const SizedBox(height: 16),
            const Divider(height: 1, color: AppColors.divider),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: _amountColumn('収入', income, AppColors.income)),
                Container(width: 1, height: 40, color: AppColors.divider),
                Expanded(child: _amountColumn('支出', expense, AppColors.expense)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _balanceRow() {
    final color = balance > 0
        ? AppColors.positive
        : balance < 0
            ? AppColors.negative
            : AppColors.neutral;

    return Column(
      children: [
        const Text(
          '残高',
          style: TextStyle(
            fontSize: 13,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '¥${AppDateUtils.formatAmount(balance.abs())}',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: color,
            letterSpacing: -0.5,
          ),
        ),
      ],
    );
  }

  Widget _amountColumn(String label, double amount, Color color) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '¥${AppDateUtils.formatAmount(amount)}',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
      ],
    );
  }
}
