import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:quick_converter/ui/shared/widgets/side_bar_widget.dart';
import 'package:quick_converter/ui/features/currency/view/converter_page.dart';
import 'package:quick_converter/ui/features/crypto/view/crypto_page.dart';
import 'package:quick_converter/core/notifiers/theme_notifier.dart';
import 'package:quick_converter/core/theme/app_themes.dart';
import 'package:quick_converter/core/notifiers/menu_notifier.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    final menuNotifier = Provider.of<MenuNotifier>(context);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      drawer: const SidebarWidget(),
      appBar: AppBar(
        title: Text(menuNotifier.currentTitle),
        centerTitle: true,
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.menu, color: theme.iconTheme.color),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.palette),
            onPressed: () {
              _showThemeDialog(context);
            },
          )
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: _getPageContent(menuNotifier.currentPage),
          ),
        ),
      ),
    );
  }

  Widget _getPageContent(ActivePage page) {
    switch (page) {
      case ActivePage.currency:
        return const ConverterPage();
      case ActivePage.crypto:
        return const CryptoPage();
    }
  }

  void _showThemeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Selecionar Tema'),
        content: Consumer<ThemeNotifier>(
          builder: (context, notifier, child) {
            return Wrap(
              spacing: 10.0,
              runSpacing: 10.0,
              alignment: WrapAlignment.center,
              children: AppThemeType.values.map((themeType) {
                final themeData = AppThemes.getTheme(themeType);
                final primaryColor = themeData.colorScheme.primary;
                final isSelected = notifier.currentTheme == themeType;
                return GestureDetector(
                  onTap: () {
                    notifier.setTheme(themeType);
                    Navigator.pop(context);
                  },
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.circular(8),
                      border: isSelected
                          ? Border.all(
                              color: themeData.colorScheme.onSurface,
                              width: 3.0)
                          : Border.all(width: 1.0, color: Colors.grey),
                    ),
                    child: isSelected
                        ? Icon(Icons.check,
                            color: themeData.colorScheme.onPrimary, size: 24)
                        : null,
                  ),
                );
              }).toList(),
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fechar'),
          )
        ],
      ),
    );
  }
}
