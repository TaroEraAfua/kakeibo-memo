import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/date_utils.dart';

class ExpensePieChart extends StatefulWidget {
  final Map<String, double> data; // category -> amount
  final double total;

  const ExpensePieChart({
    super.key,
    required this.data,
    required this.total,
  });

  @override
  State<ExpensePieChart> createState() => _ExpensePieChartState();
}

class _ExpensePieChartState extends State<ExpensePieChart> {
  int _touchedIndex = -1;

  static const _colors = [
    Color(0xFF2E7D6B), Color(0xFF1976D2), Color(0xFFD32F2F),
    Color(0xFFFF8F00), Color(0xFF6A1B9A), Color(0xFF00838F),
    Color(0xFF2E7D32), Color(0xFFC62828), Color(0xFF4527A0),
    Color(0xFF1565C0), Color(0xFF558B2F),
  ];

  @override
  Widget build(BuildContext context) {
    if (widget.data.isEmpty) {
      return const Center(
        child: Text('支出データがありません',
            style: TextStyle(color: AppColors.textSecondary)),
      );
    }

    final entries = widget.data.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    final sections = List.generate(entries.length, (i) {
      final isTouched = i == _touchedIndex;
      return PieChartSectionData(
        value: entries[i].value,
        color: _colors[i % _colors.length],
        radius: isTouched ? 70 : 60,
        showTitle: false,
      );
    });

    return Column(
      children: [
        SizedBox(
          height: 240,
          child: Stack(
            alignment: Alignment.center,
            children: [
              PieChart(
                PieChartData(
                  sections: sections,
                  centerSpaceRadius: 60,
                  pieTouchData: PieTouchData(
                    touchCallback: (event, response) {
                      setState(() {
                        if (!event.isInterestedForInteractions ||
                            response?.touchedSection == null) {
                          _touchedIndex = -1;
                          return;
                        }
                        _touchedIndex =
                            response!.touchedSection!.touchedSectionIndex;
                      });
                    },
                  ),
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('支出合計',
                      style: TextStyle(
                          fontSize: 12, color: AppColors.textSecondary)),
                  Text(
                    '¥${AppDateUtils.formatAmount(widget.total)}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        // 凡例
        ...List.generate(entries.length, (i) {
          final e = entries[i];
          final pct = widget.total > 0
              ? (e.value / widget.total * 100).toStringAsFixed(1)
              : '0.0';
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
            child: Row(
              children: [
                Container(
                  width: 12, height: 12,
                  decoration: BoxDecoration(
                    color: _colors[i % _colors.length],
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                    child:
                        Text(e.key, style: const TextStyle(fontSize: 14))),
                Text('$pct%',
                    style: const TextStyle(
                        color: AppColors.textSecondary, fontSize: 13)),
                const SizedBox(width: 12),
                Text('¥${AppDateUtils.formatAmount(e.value)}',
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 14)),
              ],
            ),
          );
        }),
      ],
    );
  }
}
