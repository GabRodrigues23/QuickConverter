import 'dart:async';
import '../model/conversion_result.dart';

class ConversionRepository {
  // Método responsável por realizar a "conversão"
  Future<ConversionResult> convert({
    required String from,
    required String to,
    required String amount,
  }) async {
    // Print para facilitar o debug (exibe os parâmetros recebidos)
    print('Iniciando conversão: $amount de $from para $to');

    // Simula o tempo de resposta da rede.
    await Future.delayed(const Duration(seconds: 2));

    // Retorna um resultado fictício (mocked)
    return ConversionResult(
      originalAmount: amount,
      fromCurrency: from,
      toCurrency: to,
      convertedValue: "100.00",
    );
  }
}
