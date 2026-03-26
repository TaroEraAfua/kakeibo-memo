import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/constants/app_colors.dart';

class AmountField extends StatelessWidget {
  static final _thousandsSeparator = _ThousandsSeparatorFormatter();

  final TextEditingController controller;
  final bool isIncome;

  const AmountField({
    super.key,
    required this.controller,
    required this.isIncome,
  });

  @override
  Widget build(BuildContext context) {
    final color = isIncome ? AppColors.income : AppColors.expense;

    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        _thousandsSeparator,
      ],
      textAlign: TextAlign.right,
      style: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        color: color,
        letterSpacing: -0.5,
      ),
      decoration: InputDecoration(
        prefixText: '¥',
        prefixStyle: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: color,
        ),
        hintText: '0',
        hintStyle: const TextStyle(color: AppColors.textSecondary),
        border: InputBorder.none,
        filled: true,
        fillColor: isIncome
            ? AppColors.incomeLight
            : AppColors.expenseLight,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20, vertical: 16,
        ),
      ),
      autofocus: true,
    );
  }
}

class _ThousandsSeparatorFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) return newValue;
    final digits = newValue.text.replaceAll(',', '');
    if (digits.isEmpty) return newValue.copyWith(text: '');

    final number = int.tryParse(digits) ?? 0;
    if (number > 99999999) return oldValue;

    final formatted = _format(number);
    return newValue.copyWith(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }

  String _format(int n) {
    final s = n.toString();
    final buf = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) buf.write(',');
      buf.write(s[i]);
    }
    return buf.toString();
  }
}
