// Local: lib/ui/view/converter_page.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewmodel/converter_viewmodel.dart';

// Tela principal do aplicativo de conversão.
class ConverterPage extends StatefulWidget {
  const ConverterPage({super.key});

  @override
  State<ConverterPage> createState() => _ConverterPageState();
}

class _ConverterPageState extends State<ConverterPage> {
  // Controller para o campo de entrada do valor a ser convertido.
  final _amountControllerFrom = TextEditingController();
  final _amountControllerTo = TextEditingController();

  // O método dispose é chamado quando a tela é destruída. Limpa os controllers para evitar vazamentos de memória.
  @override
  void dispose() {
    _amountControllerFrom.dispose();
    _amountControllerTo.dispose();
    super.dispose();
  }

  List<String> currencies = ['USD', 'BRL', 'EUR', 'GBP', 'JPY'];
  String? selectedCurrency;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF4A90E2),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 50.0, vertical: 40.0),
            child: Consumer<ConverterViewModel>(
              builder: (context, viewModel, child) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Column(
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
                        const Text(
                          'Simple Money Converter',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16, color: Colors.white70),
                        ),
                      ],
                    ),
                    const SizedBox(height: 50),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'From:',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: DropdownButton<String>(
                            value: selectedCurrency,
                            isExpanded: true,
                            underline: const SizedBox(),
                            hint: const Text(
                              'Selecione a Cotação',
                              style: TextStyle(color: Colors.grey),
                            ),
                            items: currencies.map((String currency) {
                              return DropdownMenuItem<String>(
                                value: currency,
                                child: Text(currency),
                              );
                            }).toList(),
                            onChanged: (newValue) {
                              setState(() {});
                            },
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextField(
                          controller: _amountControllerFrom,
                          keyboardType: TextInputType.number,
                          style: const TextStyle(
                              color: Colors.black, fontSize: 18),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            hintText: 'R\$ 0.00',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    if (viewModel.isLoading)
                      const Center(
                          child: CircularProgressIndicator(color: Colors.white))
                    else
                      Icon(Icons.swap_vert, color: Colors.white, size: 35),
                    const SizedBox(height: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'To:',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: DropdownButton<String>(
                            value: selectedCurrency,
                            isExpanded: true,
                            underline: const SizedBox(),
                            hint: const Text(
                              'Selecione a Cotação',
                              style: TextStyle(color: Colors.grey),
                            ),
                            items: currencies.map((String currency) {
                              return DropdownMenuItem<String>(
                                value: currency,
                                child: Text(currency),
                              );
                            }).toList(),
                            onChanged: (newValue) {
                              setState(() {});
                            },
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextField(
                          controller: _amountControllerTo,
                          keyboardType: TextInputType.number,
                          style: const TextStyle(
                              color: Colors.black, fontSize: 18),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            hintText: 'R\$ 0.00',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: () {
                        viewModel.performConversion(
                          from: 'USD', // Valor fixo por enquanto
                          to: 'BRL', // Valor fixo por enquanto
                          amount: '100.00',
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: Colors.black54,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Converter',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
