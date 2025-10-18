import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../../core/constants.dart';
import '../model/conversion_result.dart';

class ConversionRepository {
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
        print('perfeito!');
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
