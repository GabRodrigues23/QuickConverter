import 'package:flutter/material.dart';

class CurrencyInputSection extends StatelessWidget {
  final String label;
  final String? selectedCurrency;
  final List<String> currencies;
  final Function(String?) onCurrencyChanged;
  final TextEditingController? amountController;
  final bool isReadOnly;
  final Map<String, String> currencySymbols;

  const CurrencyInputSection({
    super.key,
    required this.label,
    required this.selectedCurrency,
    required this.currencies,
    required this.onCurrencyChanged,
    required this.currencySymbols,
    this.amountController,
    this.isReadOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: selectedCurrency,
              isExpanded: true,
              hint:
                  const Text('Selecione', style: TextStyle(color: Colors.grey)),
              items: currencies.map((String currency) {
                return DropdownMenuItem<String>(
                  value: currency,
                  child: Text(currency,
                      style: const TextStyle(color: Colors.black)),
                );
              }).toList(),
              onChanged: onCurrencyChanged,
            ),
          ),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: amountController,
          readOnly: isReadOnly,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          style: const TextStyle(color: Colors.black, fontSize: 18),
          decoration: InputDecoration(
            prefixText: currencySymbols[selectedCurrency] ?? '',
            filled: true,
            fillColor: isReadOnly ? Colors.grey[200] : Colors.white,
            hintText: '0.00',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }
}
