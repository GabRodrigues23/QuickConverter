import 'dart:async';
import '../model/conversion_result.dart';

class ConversionRepository {
  // Método responsável por realizar a "conversão"
  Future<ConversionResult> convert({
    required String from,
    to,
    amount,
  }) async {
    // Simula o tempo de resposta da rede.
    await Future.delayed(const Duration(seconds: 2));

    // Retorna um resultado fictício
    return ConversionResult(
      originalAmount: amount,
      fromCurrency: from,
      toCurrency: to,
      convertedValue: "100.00",
    );
  }
}
