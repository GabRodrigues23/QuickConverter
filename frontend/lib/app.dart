import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:quick_converter/data/repository/conversion_repository.dart';
import 'package:quick_converter/core/notifiers/theme_notifier.dart';
import 'package:quick_converter/core/notifiers/menu_notifier.dart';
import 'package:quick_converter/core/notifiers/history_notifier.dart';
import 'package:quick_converter/ui/features/currency/viewmodel/converter_viewmodel.dart';
import 'package:quick_converter/ui/features/crypto/viewmodel/crypto_viewmodel.dart';
import 'package:quick_converter/ui/view/main_page.dart';

class QuickConverterApp extends StatelessWidget {
  const QuickConverterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) => ConverterViewModel(ConversionRepository())),
        ChangeNotifierProvider(create: (_) => MenuNotifier()),
        ChangeNotifierProvider(create: (_) => ThemeNotifier()),
        ChangeNotifierProvider(
            create: (_) => CryptoViewModel(ConversionRepository())),
        ChangeNotifierProvider(create: (_) => HistoryNotifier()),
      ],
      child: Consumer<ThemeNotifier>(
        builder: (context, themeNotifier, child) {
          return MaterialApp(
            title: 'Quick Converter',
            debugShowCheckedModeBanner: false,
            theme: themeNotifier.currentThemeData,
            home: const MainPage(),
          );
        },
      ),
    );
  }
}
