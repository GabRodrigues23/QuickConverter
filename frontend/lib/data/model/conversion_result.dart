class ConversionResult {
  final String originalAmount, fromCurrency, toCurrency, convertedValue;

// Construtor que inicializa todas as propriedades obrigatórias.
  ConversionResult({
    required this.originalAmount,
    required this.fromCurrency,
    required this.toCurrency,
    required this.convertedValue,
  });

  // Construtor para criar uma instância de ConversionResult a partir de um JSON.
  factory ConversionResult.fromJson(Map<String, dynamic> json) {
    return ConversionResult(
        originalAmount: json['originalAmount'] ?? '',
        fromCurrency: json['fromCurrency'] ?? '',
        toCurrency: json['toCurrency'] ?? '',
        convertedValue: json['convertedValue'] ?? '');
  }

  // Método para converter a instância atual em um JSON.
  Map<String, dynamic> toJson() {
    return {
      'originalAmount': originalAmount,
      'fromCurrency': fromCurrency,
      'toCurrency': toCurrency,
      'convertedValue': convertedValue,
    };
  }

  // Facilita na depuração, imprimindo os valores das propriedades como String.
  @override
  String toString() {
    return 'ConversionResult(originalAmount: $originalAmount, fromCurrency: $fromCurrency, toCurrency: $toCurrency, convertedValue: $convertedValue)';
  }
}
