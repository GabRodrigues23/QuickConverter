import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'data/repository/conversion_repository.dart';
import 'ui/view/converter_page.dart';
import 'ui/viewmodel/converter_viewmodel.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ConverterViewModel(ConversionRepository()),
      child: MaterialApp(
        title: 'Quick Converter',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
          useMaterial3: true,
        ),
        home: const ConverterPage(),
      ),
    );
  }
}
