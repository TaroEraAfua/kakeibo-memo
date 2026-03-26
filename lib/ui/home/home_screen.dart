import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/categories.dart';
import '../../core/utils/date_utils.dart';
import '../../data/models/transaction.dart';
import '../../providers/filter_provider.dart';
import '../../providers/transaction_provider.dart';
import 'widgets/summary_card.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
          final monthly = notifier.getByMonth(
            all, selectedMonth.year, selectedMonth.month,
          );
          final income  = notifier.totalIncome(monthly);
          final expense = notifier.totalExpense(monthly);

          return ListView(
            children: [
              const SizedBox(height: 8),
              SummaryCard(income: income, expense: expense),
              const SizedBox(height: 16),
              if (monthly.isEmpty)
                const _EmptyState()
              else ...[
                const Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16, vertical: 4,
                  ),
                  child: Text(
                    '最近の取引',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
                ...monthly.take(5).map((t) => _SimpleTile(t: t)),
              ],
            ],
          );
        },
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 60),
      child: Column(
        children: [
          Icon(Icons.receipt_long_outlined,
              size: 56, color: AppColors.textSecondary),
          SizedBox(height: 12),
          Text(
            'まだ記録がありません',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 15,
            ),
          ),
          SizedBox(height: 6),
          Text(
            '右下の + から収支を追加しましょう',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}

class _SimpleTile extends StatelessWidget {
  final Transaction t;
  const _SimpleTile({required this.t});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: t.isIncome
            ? AppColors.incomeLight
            : AppColors.expenseLight,
        child: Text(
          AppCategories.emojiFor(t.category),
          style: const TextStyle(fontSize: 18),
        ),
      ),
      title: Text(t.category),
      subtitle: t.note.isNotEmpty ? Text(t.note) : null,
      trailing: Text(
        '${t.isIncome ? '+' : '-'}¥${AppDateUtils.formatAmount(t.amount)}',
        style: TextStyle(
          color: t.isIncome ? AppColors.income : AppColors.expense,
          fontWeight: FontWeight.w600,
          fontSize: 15,
        ),
      ),
    );
  }
}
