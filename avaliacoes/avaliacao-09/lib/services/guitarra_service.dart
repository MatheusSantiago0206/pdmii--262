import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/guitarra.dart';

class GuitarraService {
  // API pública da Apple (libera acesso direto no Chrome e Android sem erro 403)
  static const String _url =
      'https://itunes.apple.com/search?term=electric+guitar&entity=album&limit=20';

  Future<List<Guitarra>> buscarGuitarras() async {
    try {
      final response = await http
          .get(Uri.parse(_url))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final Map<String, dynamic> dadosJson = jsonDecode(response.body);
        final List<dynamic> listaResultados = dadosJson['results'] ?? [];

        return listaResultados.map((item) => Guitarra.fromJson(item)).toList();
      } else {
        throw Exception('Erro ao buscar catálogo (HTTP ${response.statusCode})');
      }
    } on SocketException {
      throw Exception('Sem conexão com a internet. Verifique sua rede.');
    } on TimeoutException {
      throw Exception('O servidor demorou muito para responder.');
    } on FormatException {
      throw Exception('Erro ao processar os dados recebidos da API.');
    } catch (e) {
      throw Exception('Falha inesperada: $e');
    }
  }
}