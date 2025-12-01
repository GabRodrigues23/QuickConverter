import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:quick_converter/ui/features/currency/view/widgets/currency_input_section.dart';
import 'package:quick_converter/ui/features/currency/viewmodel/converter_viewmodel.dart';

class ConverterPage extends StatefulWidget {
  const ConverterPage({super.key});

  @override
  State<ConverterPage> createState() => _ConverterPageState();
}

class _ConverterPageState extends State<ConverterPage> {
  final _fromAmountController = TextEditingController();
  final _toAmountController = TextEditingController();

  String? _fromCurrency;
  String? _toCurrency;

  final Map<String, String> currencySymbols = {
    'USD': '\$ ',
    'BRL': 'R\$ ',
    'GBP': '£ ',
    'EUR': '€ ',
    'ARS': '\$',
    'JPY': '¥ ',
    'CHF': '₣ ',
  };

  @override
  void dispose() {
    _fromAmountController.dispose();
    _toAmountController.dispose();
    super.dispose();
  }

  void _swapCurrencies() {
    setState(() {
      final temp = _fromCurrency;
      _fromCurrency = _toCurrency;
      _toCurrency = temp;

      final String resultValue = _toAmountController.text;
      _toAmountController.text = _fromAmountController.text;
      _fromAmountController.text = resultValue;
    });
  }

  void _formatAmountInput() {
    final text = _fromAmountController.text.replaceAll(',', '.');
    final value = double.tryParse(text);
    if (value == null) return;

    final formattedWithDot = value.toStringAsFixed(2);
    _fromAmountController.text = formattedWithDot.replaceAll('.', ',');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Consumer<ConverterViewModel>(
      builder: (context, viewModel, child) {
        if (_fromCurrency == null && viewModel.currencies.isNotEmpty) {
          _fromCurrency = viewModel.currencies.contains('USD')
              ? 'USD'
              : viewModel.currencies.first;
          _toCurrency = viewModel.currencies.contains('BRL')
              ? 'BRL'
              : viewModel.currencies.last;
        }

        if (viewModel.conversionResult != null && !viewModel.isLoading) {
          final valueWithDot = viewModel.conversionResult!.convertedValue;
          _toAmountController.text = valueWithDot.replaceAll('.', ',');
        }

        if (viewModel.isCurrenciesLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (viewModel.currenciesError != null) {
          return Center(
              child: Text(viewModel.currenciesError!,
                  style: TextStyle(color: theme.textTheme.labelSmall?.color)));
        }

        final currencies = viewModel.currencies;
        final fromCurrencies =
            currencies.where((c) => c != _toCurrency).toList();
        final toCurrencies =
            currencies.where((c) => c != _fromCurrency).toList();

        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('QUICKCONVERTER',
                textAlign: TextAlign.center,
                style: theme.textTheme.displayLarge),
            const SizedBox(height: 8),
            Text('Simple Money Converter',
                textAlign: TextAlign.center,
                style: theme.textTheme.titleMedium),
            const SizedBox(height: 40),
            Column(
              children: [
                CurrencyInputSection(
                  label: 'From:',
                  selectedCurrency: _fromCurrency,
                  currencies: fromCurrencies,
                  currencySymbols: currencySymbols,
                  onCurrencyChanged: (newValue) {
                    setState(() {
                      if (newValue == _toCurrency) _toCurrency = _fromCurrency;
                      _fromCurrency = newValue;
                    });
                  },
                  amountController: _fromAmountController,
                  onEditingComplete: _formatAmountInput,
                ),
                const SizedBox(height: 15),
                IconButton(
                  icon: Icon(Icons.swap_vert, size: 35),
                  onPressed: _swapCurrencies,
                ),
                const SizedBox(height: 15),
                CurrencyInputSection(
                  label: 'To:',
                  selectedCurrency: _toCurrency,
                  currencies: toCurrencies,
                  currencySymbols: currencySymbols,
                  onCurrencyChanged: (newValue) {
                    setState(() {
                      if (newValue == _fromCurrency) {
                        _fromCurrency = _toCurrency;
                      }
                      _toCurrency = newValue;
                    });
                  },
                  amountController: _toAmountController,
                  isReadOnly: true,
                ),
              ],
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: viewModel.isLoading
                  ? null
                  : () {
                      _formatAmountInput();
                      if (_fromCurrency != null &&
                          _toCurrency != null &&
                          _fromAmountController.text.isNotEmpty) {
                        final amount = double.tryParse(_fromAmountController
                                .text
                                .replaceAll(',', '.')) ??
                            0.0;
                        if (amount > 0) {
                          viewModel.performConversion(
                            from: _fromCurrency!,
                            to: _toCurrency!,
                            amount:
                                _fromAmountController.text.replaceAll(',', '.'),
                          );
                        }
                      }
                    },
              child: viewModel.isLoading
                  ? SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(
                          strokeWidth: 3, color: theme.iconTheme.color))
                  : Text('Converter'),
            ),
            const SizedBox(height: 20),
            if (viewModel.errorMessage != null)
              Text(
                viewModel.errorMessage!,
                textAlign: TextAlign.center,
                style: TextStyle(color: theme.textTheme.bodySmall?.color),
              ),
          ],
        );
      },
    );
  }
}
