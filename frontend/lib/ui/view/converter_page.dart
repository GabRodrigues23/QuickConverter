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
  final _amountController = TextEditingController();

  // O método dispose é chamado quando a tela é destruída. Limpa os controllers para evitar vazamentos de memória.
  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF4A90E2),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Consumer<ConverterViewModel>(
              builder: (context, viewModel, child) {
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

                    // ---- Seção "FROM" ----
                    TextField(
                      controller: _amountController,
                      keyboardType: TextInputType.number,
                      style: const TextStyle(color: Colors.black, fontSize: 18),
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
                    const SizedBox(height: 20),

                    // ---- Botão de Conversão ----
                    ElevatedButton(
                      onPressed: () {
                        // Quando o botão é pressionado, chamamos a função do ViewModel.
                        viewModel.performConversion(
                          from: 'USD', // Valor fixo por enquanto
                          to: 'BRL', // Valor fixo por enquanto
                          amount: _amountController.text,
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
                    const SizedBox(height: 20),

                    // ---- Seção de RESULTADO (Reativa) ----
                    if (viewModel.isLoading)
                      // Se estiver carregando, mostra o spinner.
                      const Center(
                          child: CircularProgressIndicator(color: Colors.white))
                    else if (viewModel.errorMessage != null)
                      // Se tiver um erro, mostra a mensagem.
                      Text(
                        viewModel.errorMessage!,
                        style: const TextStyle(
                            color: Colors.redAccent, fontSize: 16),
                        textAlign: TextAlign.center,
                      )
                    else if (viewModel.conversionResult != null)
                      // Se tiver um resultado, mostra o valor.
                      Text(
                        'Resultado: ${viewModel.conversionResult!.convertedValue}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
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
