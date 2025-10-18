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
          style: const TextStyle(color: Colors.white, fontSize: 18),
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: selectedCurrency,
              isExpanded: true,
              hint: const Text('Selecione uma Cotação',
                  style: TextStyle(color: Colors.grey)),
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
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: isReadOnly ? Colors.grey[200] : Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              SizedBox(
                width: 30,
                child: Text(
                  currencySymbols[selectedCurrency] ?? '',
                  style: const TextStyle(color: Colors.black54, fontSize: 18),
                ),
              ),
              Expanded(
                child: TextField(
                  controller: amountController,
                  readOnly: isReadOnly,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  style: const TextStyle(color: Colors.black, fontSize: 18),
                  decoration: const InputDecoration(
                    hintText: '0.00',
                    border: InputBorder.none,
                    isDense: false,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
