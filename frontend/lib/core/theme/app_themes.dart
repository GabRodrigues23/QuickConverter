import 'package:flutter/material.dart';

enum AppThemeType { blue, red, yellow, green }

class AppThemes {
  static final Map<AppThemeType, ThemeData> themes = {
    AppThemeType.blue: _buildTheme(
      seedColor: const Color(0xFF82B1FF),
      primaryBackground: const Color(0xFF4A90E2),
      appBarColor: const Color(0xFF4A90E2),
      titleColor: const Color(0xFFFFFFFF),
      subTitleColor: const Color(0xB3FFFFFF),
      textColor: const Color(0xFF000000),
      iconColor: const Color(0xFFFFFFFF),
      menuHeaderColor: const Color(0xFF121B2A),
      menuItemColor: const Color(0xFF3D5B8B),
      menuBackground: const Color(0xFF588ADB),
      buttonActiveColor: const Color(0x89000000),
      buttonInactiveColor: const Color(0xFF616161),
      buttonTextColor: const Color(0xFFFFFFFF),
      errorText: const Color(0xFFF44336),
    ),
    AppThemeType.red: _buildTheme(
      seedColor: const Color(0xFFFF8A80),
      primaryBackground: const Color(0xFFD32F2F),
      titleColor: const Color(0xFFFFFFFF),
      subTitleColor: const Color(0xB3FFFFFF),
      textColor: const Color(0xFF000000),
      iconColor: const Color(0xFFFFFFFF),
      appBarColor: const Color.fromARGB(255, 141, 22, 22),
      menuHeaderColor: const Color(0xFF2A1212),
      menuItemColor: const Color(0xFF5B3D3D),
      menuBackground: const Color(0xFFA12525),
      buttonActiveColor: const Color(0x89000000),
      buttonInactiveColor: const Color(0xFF616161),
      buttonTextColor: const Color(0xFFFFFFFF),
      errorText: const Color(0xFFF44336),
    ),
    AppThemeType.yellow: _buildTheme(
      seedColor: const Color(0xFFFFECB3),
      primaryBackground: const Color(0xFFFFA000),
      titleColor: const Color(0xFFFFFFFF),
      subTitleColor: const Color(0xB3FFFFFF),
      textColor: const Color(0xFF000000),
      iconColor: const Color(0xFFFFFFFF),
      appBarColor: const Color(0xFFFFA000),
      menuHeaderColor: const Color(0xFF2A2012),
      menuItemColor: const Color(0xFF5B493D),
      menuBackground: const Color(0xFFDD8D58),
      buttonActiveColor: const Color(0x89000000),
      buttonInactiveColor: const Color(0xFF616161),
      buttonTextColor: const Color(0xFFFFFFFF),
      errorText: const Color(0xFFF44336),
    ),
    AppThemeType.green: _buildTheme(
      seedColor: const Color(0xFFB9F6CA),
      primaryBackground: const Color(0xFF388E3C),
      appBarColor: const Color(0xFF388E3C),
      titleColor: const Color(0xFFFFFFFF),
      subTitleColor: const Color(0xB3FFFFFF),
      textColor: const Color(0xFF000000),
      iconColor: const Color(0xFFFFFFFF),
      menuHeaderColor: const Color(0xFF122A13),
      menuItemColor: const Color(0xFF3D5B3E),
      menuBackground: const Color(0xFF62B565),
      buttonActiveColor: const Color(0x89000000),
      buttonInactiveColor: const Color(0xFF616161),
      buttonTextColor: const Color(0xFFFFFFFF),
      errorText: const Color(0xFFF44336),
    ),
  };

  static ThemeData _buildTheme({
    required Color seedColor,
    required Color primaryBackground,
    required Color appBarColor,
    required Color titleColor,
    required Color subTitleColor,
    required Color textColor,
    required Color iconColor,
    required Color menuHeaderColor,
    required Color menuBackground,
    required Color menuItemColor,
    required Color buttonActiveColor,
    required Color buttonInactiveColor,
    required Color buttonTextColor,
    required Color errorText,
  }) {
    final colorScheme = ColorScheme.fromSeed(
        seedColor: seedColor,
        brightness: ThemeData.estimateBrightnessForColor(seedColor));

    return ThemeData(
      colorScheme: colorScheme,
      scaffoldBackgroundColor: primaryBackground,
      appBarTheme: AppBarTheme(
        backgroundColor: menuHeaderColor,
        foregroundColor: iconColor,
        iconTheme: IconThemeData(color: iconColor),
        centerTitle: true,
      ),
      drawerTheme: DrawerThemeData(backgroundColor: menuBackground),
      secondaryHeaderColor: menuHeaderColor,
      listTileTheme: ListTileThemeData(
        tileColor: menuBackground,
        iconColor: iconColor,
        textColor: textColor,
      ),
      iconTheme: IconThemeData(color: iconColor),
      textTheme: TextTheme(
        displayLarge: TextStyle(
            fontSize: 28, fontWeight: FontWeight.bold, color: titleColor),
        displayMedium: TextStyle(
            fontSize: 20, fontWeight: FontWeight.bold, color: subTitleColor),
        displaySmall: TextStyle(color: titleColor),
        bodySmall: TextStyle(fontSize: 14, color: errorText),
        labelMedium: TextStyle(fontSize: 12, color: textColor),
        labelLarge: TextStyle(fontSize: 16, color: textColor),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonActiveColor,
          disabledBackgroundColor: buttonInactiveColor,
          foregroundColor: buttonTextColor,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
      useMaterial3: true,
    );
  }

  static ThemeData getTheme(AppThemeType themeType) {
    return themes[themeType] ?? themes[AppThemeType.blue]!;
  }
}
