class ConversionResult {
  final String originalAmount, fromCurrency, toCurrency, convertedValue;

  ConversionResult({
    required this.originalAmount,
    required this.fromCurrency,
    required this.toCurrency,
    required this.convertedValue,
  });

  factory ConversionResult.fromJson(Map<String, dynamic> json) {
    return ConversionResult(
        originalAmount: json['originalAmount'] ?? '',
        fromCurrency: json['fromCurrency'] ?? '',
        toCurrency: json['toCurrency'] ?? '',
        convertedValue: json['convertedValue'] ?? '');
  }

  Map<String, dynamic> toJson() {
    return {
      'originalAmount': originalAmount,
      'fromCurrency': fromCurrency,
      'toCurrency': toCurrency,
      'convertedValue': convertedValue,
    };
  }

  @override
  String toString() {
    return 'ConversionResult(originalAmount: $originalAmount, fromCurrency: $fromCurrency, toCurrency: $toCurrency, convertedValue: $convertedValue)';
  }
}
