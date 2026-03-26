import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/date_utils.dart';
import '../../providers/filter_provider.dart';
import '../../providers/transaction_provider.dart';
import '../input/input_screen.dart';
import 'widgets/transaction_tile.dart';

class HistoryScreen extends ConsumerStatefulWidget {
  const HistoryScreen({super.key});

  @override
  ConsumerState<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends ConsumerState<HistoryScreen> {
  bool? _filterIsIncome; // null=全て, true=収入, false=支出

  @override
  Widget build(BuildContext context) {
    final selectedMonth = ref.watch(filterProvider);
    final transactionsAsync = ref.watch(transactionProvider);
    final notifier = ref.read(transactionProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.chevron_left),
              onPressed: () =>
                  ref.read(filterProvider.notifier).previousMonth(),
            ),
            Text(AppDateUtils.formatMonth(selectedMonth)),
            IconButton(
              icon: const Icon(Icons.chevron_right),
              onPressed: () =>
                  ref.read(filterProvider.notifier).nextMonth(),
            ),
          ],
        ),
      ),
      body: transactionsAsync.when(
        loading: () =>
            const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('エラー: $e')),
        data: (all) {
          var monthly = notifier.getByMonth(
            all, selectedMonth.year, selectedMonth.month,
          );

          // フィルター適用
          if (_filterIsIncome != null) {
            monthly = monthly
                .where((t) => t.isIncome == _filterIsIncome)
                .toList();
          }
          return Column(
            children: [
              // フィルターチップ
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    FilterChip(
                      label: const Text('すべて'),
                      selected: _filterIsIncome == null,
                      onSelected: (_) =>
                          setState(() => _filterIsIncome = null),
                    ),
                    const SizedBox(width: 8),
                    FilterChip(
                      label: const Text('収入'),
                      selected: _filterIsIncome == true,
                      selectedColor: AppColors.incomeLight,
                      onSelected: (_) =>
                          setState(() => _filterIsIncome = true),
                    ),
                    const SizedBox(width: 8),
                    FilterChip(
                      label: const Text('支出'),
                      selected: _filterIsIncome == false,
                      selectedColor: AppColors.expenseLight,
                      onSelected: (_) =>
                          setState(() => _filterIsIncome = false),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              Expanded(
                child: monthly.isEmpty
                    ? const Center(child: Text('該当する取引がありません'))
                    : ListView.separated(
                        itemCount: monthly.length,
                        separatorBuilder: (_, __) =>
                            const Divider(height: 1, indent: 72),
                        itemBuilder: (context, i) {
                          final t = monthly[i];
                          return TransactionTile(
                            transaction: t,
                            onDelete: () =>
                                ref
                                    .read(transactionProvider.notifier)
                                    .delete(t.id),
                            onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) =>
                                    InputScreen(editTarget: t),
                                fullscreenDialog: true,
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}
