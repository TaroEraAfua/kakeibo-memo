import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/constants/app_colors.dart';
import 'ui/home/home_screen.dart';
import 'ui/history/history_screen.dart';
import 'ui/chart/chart_screen.dart';
import 'ui/input/input_screen.dart';

final currentTabProvider = StateProvider<int>((ref) => 0);

class KakeiboApp extends StatelessWidget {
  const KakeiboApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '家計メモ帳',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: AppColors.surface,
        cardTheme: const CardThemeData(
          elevation: 0,
          color: AppColors.cardBg,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
            side: BorderSide(color: AppColors.divider, width: 1),
          ),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.cardBg,
          elevation: 0,
          scrolledUnderElevation: 1,
          centerTitle: true,
          foregroundColor: AppColors.textPrimary,
          titleTextStyle: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ja', 'JP'),
        Locale('en', 'US'),
      ],
      locale: const Locale('ja', 'JP'),
      home: const MainShell(),
    );
  }
}

class MainShell extends ConsumerWidget {
  const MainShell({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTab = ref.watch(currentTabProvider);

    const screens = [
      HomeScreen(),
      HistoryScreen(),
      ChartScreen(),
    ];

    return Scaffold(
      body: IndexedStack(
        index: currentTab,
        children: screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentTab,
        onDestinationSelected: (i) =>
            ref.read(currentTabProvider.notifier).state = i,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'ホーム',
          ),
          NavigationDestination(
            icon: Icon(Icons.list_alt_outlined),
            selectedIcon: Icon(Icons.list_alt),
            label: '履歴',
          ),
          NavigationDestination(
            icon: Icon(Icons.pie_chart_outline),
            selectedIcon: Icon(Icons.pie_chart),
            label: 'グラフ',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openInput(context),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add, size: 28),
      ),
    );
  }

  void _openInput(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const InputScreen(),
        fullscreenDialog: true,
      ),
    );
  }
}
