import 'package:flutter/material.dart';

class MenuNotifier extends ChangeNotifier {
  int selectedIndex = 0;

  void updateMenuIndex(int index) {
    selectedIndex = index;
    notifyListeners();
  }

  String get currentSectionTitle {
    switch (selectedIndex) {
      case 0:
        return "Conversor de Moedas";
      case 1:
        return "Conversor de CryptoMoedas";
      case 2:
        return "Historico";
      default:
        return "null";
    }
  }
}
