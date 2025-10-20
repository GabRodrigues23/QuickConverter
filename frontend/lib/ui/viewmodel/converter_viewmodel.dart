import 'package:flutter/material.dart';
import 'package:QuickConverter/data/model/conversion_result.dart';
import 'package:QuickConverter/data/repository/conversion_repository.dart';

class ConverterViewModel extends ChangeNotifier {
  final ConversionRepository _repository;

  ConversionResult? _conversionResult;
  bool _isLoading = false;
  String? _errorMessage;

  List<String> _currencies = [];
  bool _isCurrenciesLoading = false;
  String? _currenciesError;

  ConversionResult? get conversionResult => _conversionResult;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<String> get currencies => _currencies;
  bool get isCurrenciesLoading => _isCurrenciesLoading;
  String? get currenciesError => _currenciesError;

  ConverterViewModel(this._repository) {
    fetchCurrencies();
  }

  Future<void> fetchCurrencies() async {
    _isCurrenciesLoading = true;
    _currenciesError = null;
    notifyListeners();

    try {
      _currencies = await _repository.getAvailableCurrencies();
    } catch (e) {
      _currenciesError = e.toString();
    } finally {
      _isCurrenciesLoading = false;
      notifyListeners();
    }
  }

  Future<void> performConversion(
      {required String from,
      required String to,
      required String amount}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      final result = await _repository.convert(
        from: from,
        to: to,
        amount: amount,
      );

      _conversionResult = result;
    } catch (e) {
      _errorMessage = 'Erro ao realizar conversão: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
