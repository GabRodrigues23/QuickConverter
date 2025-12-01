import 'package:flutter/material.dart';

enum ActivePage {
  currency, // Conversor de Moedas
  crypto, // Criptomoedas
}

class MenuNotifier extends ChangeNotifier {
  ActivePage _currentPage = ActivePage.currency;

  ActivePage get currentPage => _currentPage;

  String get currentTitle {
    switch (_currentPage) {
      case ActivePage.currency:
        return 'Conversor de Moedas';
      case ActivePage.crypto:
        return 'Conversor de Criptomoedas';
    }
  }

  void setPage(ActivePage page) {
    _currentPage = page;
    notifyListeners();
  }
}
