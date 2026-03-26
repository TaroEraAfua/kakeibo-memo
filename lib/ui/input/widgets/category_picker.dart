import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/categories.dart';

class CategoryPicker extends StatelessWidget {
  final bool isIncome;
  final String? selected;
  final ValueChanged<String> onSelected;

  const CategoryPicker({
    super.key,
    required this.isIncome,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final categories = isIncome
        ? AppCategories.income
        : AppCategories.expense;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        childAspectRatio: 1.1,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: categories.length,
      itemBuilder: (context, i) {
        final cat = categories[i];
        final isSelected = selected == cat.name;
        return GestureDetector(
          onTap: () => onSelected(cat.name),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            decoration: BoxDecoration(
              color: isSelected
                  ? (isIncome ? AppColors.incomeLight : AppColors.expenseLight)
                  : AppColors.surface,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: isSelected
                    ? (isIncome ? AppColors.income : AppColors.expense)
                    : AppColors.divider,
                width: isSelected ? 1.5 : 1,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(cat.emoji, style: const TextStyle(fontSize: 22)),
                const SizedBox(height: 4),
                Text(
                  cat.name,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: isSelected
                        ? FontWeight.w600
                        : FontWeight.w400,
                    color: isSelected
                        ? (isIncome ? AppColors.income : AppColors.expense)
                        : AppColors.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
