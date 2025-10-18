import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../../core/constants.dart';
import '../model/conversion_result.dart';

class ConversionRepository {
  Future<List<String>> getAvailableCurrencies() async {
    String host = apiBaseUrl;
    if (Platform.isAndroid) {
      host = apiBaseUrl.replaceFirst('localhost', '192.168.2.111');
    }

    final url = Uri.parse('$host/currencies');
    print('Buscando lista de moedas em $url');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        return List<String>.from(jsonList);
      } else {
        throw Exception('Falha ao carregar a lista de moedas');
      }
    } catch (e) {
      print('Erro ao buscar moedas: $e');
      throw Exception('Não foi possível buscar as moedas disponíveis.');
    }
  }

  Future<ConversionResult> convert({
    required String from,
    required String to,
    required String amount,
  }) async {
    String host = apiBaseUrl;
    if (Platform.isAndroid) {
      host = apiBaseUrl.replaceFirst('localhost', '192.168.2.111');
    }

    final url = Uri.parse('$host/convert?from=$from&to=$to&amount=$amount');
    print('Fazendo requisição para a API real em: $url');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final jsonBody = jsonDecode(response.body);
        return ConversionResult.fromJson(jsonBody);
      } else {
        throw Exception(
            'Falha na API: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Erro de conexão: $e');
      throw Exception(
          'Erro de conexão. Verifique se o servidor backend está ligado e acessível');
    }
  }
}
