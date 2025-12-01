import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quick_converter/core/notifiers/history_notifier.dart';
import 'package:quick_converter/data/model/history_item.dart';

import 'package:quick_converter/ui/features/crypto/viewmodel/crypto_viewmodel.dart';
import 'package:quick_converter/ui/features/currency/view/widgets/currency_input_section.dart';

class CryptoPage extends StatefulWidget {
  const CryptoPage({super.key});

  @override
  State<CryptoPage> createState() => _CryptoPageState();
}

class _CryptoPageState extends State<CryptoPage> {
  final _amountController = TextEditingController();
  String? _selectedCrypto;

  final Map<String, String> cryptoSymbols = {
    'BTC': '₿ ',
    'ETH': 'Ξ ',
    'XRP': '✕ ',
    'DOGE': 'Ð ',
  };

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final viewModel = Provider.of<CryptoViewModel>(context, listen: false);
      if (viewModel.cryptos.isEmpty) {
      } else {
        setState(() {
          _selectedCrypto = viewModel.cryptos.first;
        });
      }
    });
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _onConvert(CryptoViewModel viewModel) async {
    final text = _amountController.text.replaceAll(',', '.');
    if (text.isEmpty || _selectedCrypto == null) return;

    final value = double.tryParse(text);
    if (value != null) {
      _amountController.text = value.toStringAsFixed(2).replaceAll('.', ',');
    }

    await viewModel.performCryptoConversion(
      crypto: _selectedCrypto!,
      amount: text,
    );

    if (viewModel.conversionError == null &&
        viewModel.resultBrl != null &&
        viewModel.resultUsd != null) {
      if (mounted) {
        final historyNotifier =
            Provider.of<HistoryNotifier>(context, listen: false);
        final now = DateTime.now();

        historyNotifier.addToHistory(HistoryItem(
          from: _selectedCrypto!,
          to: 'BRL',
          amount: _amountController.text,
          result: viewModel.resultBrl!.convertedValue.replaceAll('.', ','),
          date: now,
        ));

        historyNotifier.addToHistory(HistoryItem(
          from: _selectedCrypto!,
          to: 'USD',
          amount: _amountController.text,
          result: viewModel.resultUsd!.convertedValue.replaceAll('.', ','),
          date: now,
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Consumer<CryptoViewModel>(
      builder: (context, viewModel, child) {
        if (_selectedCrypto == null && viewModel.cryptos.isNotEmpty) {
          _selectedCrypto = viewModel.cryptos.first;
        }

        if (viewModel.isListLoading) {
          return Center(child: CircularProgressIndicator());
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('QUICKCONVERTER',
                textAlign: TextAlign.center,
                style: theme.textTheme.displayLarge),
            const SizedBox(height: 8),
            Text('Simple Crypto Converter',
                textAlign: TextAlign.center,
                style: theme.textTheme.titleMedium),
            const SizedBox(height: 40),
            CurrencyInputSection(
              label: 'Selecione uma moeda:',
              selectedCurrency: _selectedCrypto,
              currencies: viewModel.cryptos,
              currencySymbols: cryptoSymbols,
              onCurrencyChanged: (val) => setState(() => _selectedCrypto = val),
              amountController: _amountController,
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed:
                  viewModel.isConverting ? null : () => _onConvert(viewModel),
              child: viewModel.isConverting
                  ? SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(
                          strokeWidth: 3, color: theme.iconTheme.color))
                  : Text('Converter'),
            ),
            const SizedBox(height: 40),
            if (viewModel.resultBrl != null && viewModel.resultUsd != null)
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withAlpha(1),
                        blurRadius: 10,
                        offset: const Offset(0, 5))
                  ],
                ),
                child: Column(
                  children: [
                    _buildResultRow('REAL',
                        'R\$ ${viewModel.resultBrl!.convertedValue.replaceAll('.', ',')}'),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Divider(),
                    ),
                    _buildResultRow('DÓLAR',
                        '\$  ${viewModel.resultUsd!.convertedValue.replaceAll('.', ',')}'),
                  ],
                ),
              ),
            if (viewModel.conversionError != null)
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Text(viewModel.conversionError!,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: theme.textTheme.bodySmall?.color)),
              ),
          ],
        );
      },
    );
  }

  Widget _buildResultRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87)),
        Text(value,
            style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black)),
      ],
    );
  }
}
