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

  String? _fromCurrency = 'USD';
  String? _toCurrency = 'BRL';
  final List<String> currencies = ['USD', 'BRL', 'EUR', 'GBP', 'JPY'];

  final Map<String, String> currencySymbols = {
    'USD': '\$ ',
    'BRL': 'R\$ ',
    'EUR': '€ ',
    'GBP': '£ ',
    'JPY': '¥ ',
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
      _fromAmountController.clear();
      _toAmountController.clear();

      _fromAmountController.text = resultValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    final fromCurrencies = currencies.where((c) => c != _toCurrency).toList();
    final toCurrencies = currencies.where((c) => c != _fromCurrency).toList();
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
                  if (viewModel.conversionResult != null &&
                      !viewModel.isLoading) {
                    _toAmountController.text =
                        viewModel.conversionResult!.convertedValue;
                  }
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'QUICKCONVERTER',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Simple Money Converter',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16, color: Colors.white70),
                      ),
                      const SizedBox(height: 40),
                      Column(
                        children: [
                          CurrencyInputSection(
                            label: 'From:',
                            selectedCurrency: _fromCurrency,
                            currencies: fromCurrencies,
                            onCurrencyChanged: (newValue) {
                              if (newValue == _toCurrency) {
                                _swapCurrencies();
                              } else {
                                setState(() {
                                  _fromCurrency = newValue;
                                });
                              }
                            },
                            amountController: _fromAmountController,
                            currencySymbols: currencySymbols,
                          ),
                          const SizedBox(height: 15),
                          IconButton(
                            icon: const Icon(Icons.swap_vert,
                                color: Colors.white, size: 35),
                            onPressed: _swapCurrencies,
                          ),
                          const SizedBox(height: 15),
                          CurrencyInputSection(
                            label: 'To:',
                            selectedCurrency: _toCurrency,
                            currencies: toCurrencies,
                            onCurrencyChanged: (newValue) {
                              if (newValue == _fromCurrency) {
                                _swapCurrencies();
                              } else {
                                setState(() {
                                  _toCurrency = newValue;
                                });
                              }
                            },
                            amountController: _toAmountController,
                            currencySymbols: currencySymbols,
                            isReadOnly: true,
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                      ElevatedButton(
                        onPressed: viewModel.isLoading
                            ? null
                            : () {
                                if (_fromCurrency != null &&
                                    _toCurrency != null &&
                                    _fromAmountController.text.isNotEmpty) {
                                  viewModel.performConversion(
                                    from: _fromCurrency!,
                                    to: _toCurrency!,
                                    amount: _fromAmountController.text,
                                  );
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: Colors.black54,
                          disabledBackgroundColor: Colors.grey.shade700,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        child: viewModel.isLoading
                            ? const SizedBox(
                                height: 24,
                                width: 24,
                                child: CircularProgressIndicator(
                                    strokeWidth: 3, color: Colors.white),
                              )
                            : const Text('Converter',
                                style: TextStyle(
                                    fontSize: 18, color: Colors.white)),
                      ),
                      const SizedBox(height: 20),
                      if (viewModel.errorMessage != null)
                        Text(
                          viewModel.errorMessage!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              color: Colors.redAccent,
                              fontWeight: FontWeight.bold),
                        ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
