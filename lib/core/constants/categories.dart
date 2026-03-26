class AppCategory {
  final String name;
  final String emoji;
  final bool isIncome;

  const AppCategory({
    required this.name,
    required this.emoji,
    required this.isIncome,
  });
}

class AppCategories {
  AppCategories._();

  static const List<AppCategory> expense = [
    AppCategory(name: '食費',   emoji: '🍚', isIncome: false),
    AppCategory(name: '外食',   emoji: '🍜', isIncome: false),
    AppCategory(name: '交通',   emoji: '🚃', isIncome: false),
    AppCategory(name: '日用品', emoji: '🛒', isIncome: false),
    AppCategory(name: '医療',   emoji: '💊', isIncome: false),
    AppCategory(name: '娯楽',   emoji: '🎮', isIncome: false),
    AppCategory(name: '被服',   emoji: '👕', isIncome: false),
    AppCategory(name: '美容',   emoji: '💄', isIncome: false),
    AppCategory(name: '光熱費', emoji: '💡', isIncome: false),
    AppCategory(name: '通信',   emoji: '📱', isIncome: false),
    AppCategory(name: 'その他', emoji: '📌', isIncome: false),
  ];

  static const List<AppCategory> income = [
    AppCategory(name: '給与',     emoji: '💰', isIncome: true),
    AppCategory(name: '副業',     emoji: '💻', isIncome: true),
    AppCategory(name: '臨時収入', emoji: '🎁', isIncome: true),
    AppCategory(name: 'その他収入', emoji: '📥', isIncome: true),
  ];

  static final Map<String, String> _emojiMap = {
    for (final c in [...expense, ...income]) c.name: c.emoji,
  };

  static String emojiFor(String name) => _emojiMap[name] ?? '📌';
}
