import 'package:flutter/material.dart';

import 'package:quick_converter/data/repository/conversion_repository.dart';
import 'package:quick_converter/data/model/conversion_result.dart';

class CryptoViewModel extends ChangeNotifier {
  final ConversionRepository _repository;

  List<String> _cryptos = [];
  bool _isListLoading = false;
  String? _listError;

  ConversionResult? _resultBrl;
  ConversionResult? _resultUsd;
  bool _isConverting = false;
  String? _conversionError;

  List<String> get cryptos => _cryptos;
  bool get isListLoading => _isListLoading;
  String? get listError => _listError;

  ConversionResult? get resultBrl => _resultBrl;
  ConversionResult? get resultUsd => _resultUsd;
  bool get isConverting => _isConverting;
  String? get conversionError => _conversionError;

  CryptoViewModel(this._repository) {
    _fetchCryptos();
  }

  Future<void> _fetchCryptos() async {
    _isListLoading = true;
    notifyListeners();
    try {
      _cryptos = await _repository.getAvailableCryptoCurrencies();
    } catch (e) {
      _listError = e.toString();
    } finally {
      _isListLoading = false;
      notifyListeners();
    }
  }

  Future<void> performCryptoConversion({
    required String crypto,
    required String amount,
  }) async {
    _isConverting = true;
    _conversionError = null;
    _resultBrl = null;
    _resultUsd = null;
    notifyListeners();

    try {
      _resultBrl =
          await _repository.convert(from: crypto, to: 'BRL', amount: amount);
      notifyListeners();
      await Future.delayed(const Duration(milliseconds: 500));
      _resultUsd =
          await _repository.convert(from: crypto, to: 'USD', amount: amount);
    } catch (e) {
      _conversionError = 'Erro ao converter: $e';
    } finally {
      _isConverting = false;
      notifyListeners();
    }
  }
}
