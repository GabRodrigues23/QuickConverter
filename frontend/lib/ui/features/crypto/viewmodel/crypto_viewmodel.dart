import 'package:flutter/material.dart';

import 'package:quick_converter/data/model/conversion_result.dart';
import 'package:quick_converter/data/repository/conversion_repository.dart';

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
      final futures = await Future.wait([
        _repository.convert(from: crypto, to: 'BRL', amount: amount),
        _repository.convert(from: crypto, to: 'USD', amount: amount),
      ]);

      _resultBrl = futures[0];
      _resultUsd = futures[1];
    } catch (e) {
      _conversionError = 'Erro ao converter: $e';
    } finally {
      _isConverting = false;
      notifyListeners();
    }
  }
}
