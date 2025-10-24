import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'data/repository/conversion_repository.dart';
import 'ui/viewmodel/converter_viewmodel.dart';
import 'ui/view/converter_page.dart';
import 'core/constants.dart';

class QuickConverterApp extends StatelessWidget {
  const QuickConverterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ConverterViewModel(ConversionRepository()),
      child: MaterialApp(
        title: 'Quick Converter',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: primaryColor),
          useMaterial3: true,
        ),
        home: const ConverterPage(),
      ),
    );
  }
}
