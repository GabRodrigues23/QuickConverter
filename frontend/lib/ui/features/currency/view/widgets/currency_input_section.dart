import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:quick_converter/core/constants.dart';

class CurrencyInputSection extends StatelessWidget {
  final String label;
  final String? selectedCurrency;
  final List<String> currencies;
  final Function(String?) onCurrencyChanged;
  final TextEditingController? amountController;
  final bool isReadOnly;
  final VoidCallback? onEditingComplete;
  final Map<String, String> currencySymbols;

  const CurrencyInputSection({
    super.key,
    required this.label,
    required this.selectedCurrency,
    required this.currencies,
    required this.onCurrencyChanged,
    this.amountController,
    this.isReadOnly = false,
    this.onEditingComplete,
    required this.currencySymbols,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.labelMedium,
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: labelColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: selectedCurrency,
              isExpanded: true,
              hint: Text('Selecione uma Cotação',
                  style: theme.textTheme.labelMedium),
              items: currencies.map((String currency) {
                return DropdownMenuItem<String>(
                  value: currency,
                  child: Text(currency, style: theme.textTheme.labelLarge),
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
              color: isReadOnly ? readOnlyDropdownBGColor : dropdownBGColor,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isReadOnly ? readOnlyDropdownBGColor : dropdownBGColor,
              )),
          child: Row(
            children: [
              SizedBox(
                width: 30,
                child: Text(
                  currencySymbols[selectedCurrency] ?? '',
                  style: TextStyle(color: symbolColor, fontSize: 18),
                ),
              ),
              Expanded(
                child: TextField(
                  controller: amountController,
                  onEditingComplete: onEditingComplete,
                  readOnly: isReadOnly,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  style: theme.textTheme.labelLarge,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    isDense: false,
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                        RegExp(r'^\d*([.,])?\d{0,2}$')),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
