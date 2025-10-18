import 'package:flutter/material.dart';
import 'package:QuickConverter/data/model/conversion_result.dart';
import 'package:QuickConverter/data/repository/conversion_repository.dart';

class ConverterViewModel extends ChangeNotifier {
  final ConversionRepository _repository;

  ConversionResult? _conversionResult;
  bool _isLoading = false;
  String? _errorMessage;

  // Getters para acessar os estados
  ConversionResult? get conversionResult => _conversionResult;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Construtor com Injeção de Dependência (Repository)
  ConverterViewModel(this._repository);

  Future<void> performConversion(
      {required String from,
      required String to,
      required String amount}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      // Chama o repositório para realizar a "conversão"
      final result = await _repository.convert(
        from: from,
        to: to,
        amount: amount,
      );

      _conversionResult = result;
    } catch (e) {
      // Caso ocorra algum erro (simulado ou real futuramente)
      _errorMessage = 'Erro ao realizar conversão: $e';
    } finally {
      // Atualiza o estado final (sempre executado)
      _isLoading = false;
      notifyListeners();
    }
  }
}
