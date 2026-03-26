import 'package:intl/intl.dart';

class AppDateUtils {
  AppDateUtils._();

  static DateTime firstDayOfMonth(DateTime d) =>
      DateTime(d.year, d.month, 1);

  static DateTime lastDayOfMonth(DateTime d) =>
      DateTime(d.year, d.month + 1, 0, 23, 59, 59);

  static String formatMonth(DateTime d) =>
      DateFormat('yyyy年M月', 'ja').format(d);

  static String formatDate(DateTime d) =>
      DateFormat('M/d(E)', 'ja').format(d);

  static String formatAmount(double amount) =>
      NumberFormat('#,###', 'ja').format(amount.toInt());
}
