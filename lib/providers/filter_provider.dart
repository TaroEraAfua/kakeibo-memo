import 'package:flutter_riverpod/flutter_riverpod.dart';

class FilterNotifier extends StateNotifier<DateTime> {
  FilterNotifier() : super(DateTime.now());

  void nextMonth() {
    state = DateTime(state.year, state.month + 1);
  }

  void previousMonth() {
    state = DateTime(state.year, state.month - 1);
  }

  void setMonth(DateTime date) {
    state = DateTime(date.year, date.month);
  }
}

final filterProvider =
    StateNotifierProvider<FilterNotifier, DateTime>((ref) {
  return FilterNotifier();
});
