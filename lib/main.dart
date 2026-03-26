import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'data/models/transaction.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Hive 初期化
  await Hive.initFlutter();
  Hive.registerAdapter(TransactionAdapter());

  // Hive box と日本語ロケールを並行初期化
  await Future.wait([
    Hive.openBox<Transaction>('transactions'),
    initializeDateFormatting('ja'),
  ]);

  runApp(
    const ProviderScope(
      child: KakeiboApp(),
    ),
  );
}
