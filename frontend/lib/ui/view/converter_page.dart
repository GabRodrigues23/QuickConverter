import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewmodel/converter_viewmodel.dart';
import 'widgets/currency_input_section.dart';

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
    'ARS': '\$ ',
    'EUR': '€ ',
    'JPY': '¥ ',
  };

  @override
  void dispose() {
    _fromAmountController.dispose();
    _toAmountController.dispose();
    super.dispose();
  }

  void _swapCurrencies() {
    final tempCurrency = _fromCurrency;
    setState(() {
      _fromCurrency = _toCurrency;
      _toCurrency = tempCurrency;
    });

    final String resultValue = _toAmountController.text;
    _toAmountController.text = _fromAmountController.text;
    _fromAmountController.text = resultValue;
  }

  void _formatAmountInput() {
    final text = _fromAmountController.text.replaceAll(',', '.');
    final value = double.tryParse(text);
    if (value == null) return;

    final formattedWithDot = value.toStringAsFixed(2);
    final formattedWithComma = formattedWithDot.replaceAll('.', ',');

    _fromAmountController.text = formattedWithComma;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF4A90E2),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
              child: Consumer<ConverterViewModel>(
                builder: (context, viewModel, child) {
                  if (viewModel.isCurrenciesLoading) {
                    return const Center(
                        child: CircularProgressIndicator(color: Colors.white));
                  }
                  if (viewModel.currenciesError != null) {
                    return Center(
                      child: Text(viewModel.currenciesError!,
                          style: const TextStyle(color: Colors.redAccent)),
                    );
                  }
                  return _buildConverterForm(viewModel);
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildConverterForm(ConverterViewModel viewModel) {
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

    final currencies = viewModel.currencies;
    final fromCurrencies = currencies.where((c) => c != _toCurrency).toList();
    final toCurrencies = currencies.where((c) => c != _fromCurrency).toList();

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text('QUICKCONVERTER',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white)),
        const SizedBox(height: 8),
        const Text('Simple Money Converter',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.white70)),
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
                  if (newValue == _toCurrency) {
                    _toCurrency = _fromCurrency;
                  }
                  _fromCurrency = newValue;
                });
              },
              amountController: _fromAmountController,
              onEditingComplete: _formatAmountInput,
            ),
            const SizedBox(height: 15),
            IconButton(
              icon: const Icon(Icons.swap_vert, color: Colors.white, size: 35),
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
                    final amount = double.tryParse(
                            _fromAmountController.text.replaceAll(',', '.')) ??
                        0.0;
                    if (amount > 0) {
                      viewModel.performConversion(
                        from: _fromCurrency!,
                        to: _toCurrency!,
                        amount: _fromAmountController.text.replaceAll(',', '.'),
                      );
                    }
                  }
                },
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            backgroundColor: Colors.black54,
            disabledBackgroundColor: Colors.grey.shade700,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: viewModel.isLoading
              ? const SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(
                      strokeWidth: 3, color: Colors.white))
              : const Text('Converter',
                  style: TextStyle(fontSize: 18, color: Colors.white)),
        ),
        const SizedBox(height: 20),

        if (viewModel.errorMessage != null)
          Text(
            viewModel.errorMessage!,
            textAlign: TextAlign.center,
            style: const TextStyle(
                color: Colors.redAccent, fontWeight: FontWeight.bold),
          ),
      ],
    );
  }
}
