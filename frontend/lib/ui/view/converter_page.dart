import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:QuickConverter/core/notifiers/theme_notifier.dart';
import 'package:QuickConverter/core/theme/app_themes.dart';

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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        leading: Builder(
          builder: (context) {
            return IconButton(
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              icon: const Icon(Icons.menu),
            );
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.palette_rounded),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Theme Selector'),
                  content: Consumer<ThemeNotifier>(
                    builder: (context, notifier, child) {
                      return Wrap(
                        spacing: 10.0,
                        runSpacing: 10.0,
                        alignment: WrapAlignment.center,
                        children: AppThemeType.values.map((themeType) {
                          final themeData = AppThemes.getTheme(themeType);
                          final primaryColor =
                              themeData.colorScheme.primaryContainer;
                          final isSelected = notifier.currentTheme == themeType;
                          return GestureDetector(
                            onTap: () {
                              notifier.setTheme(themeType);
                              Navigator.pop(context);
                            },
                            child: Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color: primaryColor,
                                borderRadius: BorderRadius.circular(8),
                                border: isSelected
                                    ? Border.all(
                                        color: colorScheme.primary, width: 3.0)
                                    : Border.all(width: 1.0),
                              ),
                              child: isSelected
                                  ? Icon(
                                      Icons.check,
                                      color: themeData.colorScheme.primary,
                                      size: 24,
                                    )
                                  : null,
                            ),
                          );
                        }).toList(),
                      );
                    },
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        'Close',
                        style:
                            TextStyle(color: theme.textTheme.titleSmall?.color),
                      ),
                    ),
                  ],
                ),
              );
            },
          )
        ],
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
              child: Consumer<ConverterViewModel>(
                builder: (context, viewModel, child) {
                  if (viewModel.isCurrenciesLoading) {
                    return Center(
                        child: CircularProgressIndicator(
                            color: theme.iconTheme.color));
                  }
                  if (viewModel.currenciesError != null) {
                    return Center(
                      child: Text(viewModel.currenciesError!,
                          style: TextStyle(
                              color: theme.textTheme.labelSmall?.color)),
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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

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
        Text('QUICKCONVERTER',
            textAlign: TextAlign.center, style: theme.textTheme.displayLarge),
        const SizedBox(height: 8),
        Text('Simple Money Converter',
            textAlign: TextAlign.center, style: theme.textTheme.titleMedium),
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
          child: viewModel.isLoading
              ? SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(
                      strokeWidth: 3, color: theme.iconTheme.color))
              : const Text('Converter'),
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
  }
}
