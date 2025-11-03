import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'data/repository/conversion_repository.dart';
import 'ui/viewmodel/converter_viewmodel.dart';
import 'core/notifiers/menu_notifier.dart';
import 'ui/view/converter_page.dart';

import 'core/notifiers/theme_notifier.dart';

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
      ],
      child: Consumer<ThemeNotifier>(
        builder: (context, themeNotifier, child) {
          return MaterialApp(
            title: 'Quick Converter',
            debugShowCheckedModeBanner: false,
            theme: themeNotifier.currentThemeData,
            home: const ConverterPage(),
          );
        },
      ),
    );
  }
}
