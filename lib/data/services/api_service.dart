import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/hero_model.dart';

class ApiService {
  final String baseUrl = 'https://685d6bdb769de2bf08609d72.mockapi.io';

  // GET: Busca heróis da API Mockapi
  Future<List<HeroModel>> fetchHeroes() async {
    final url = Uri.parse('$baseUrl/heroes');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);
        return data.map((json) => HeroModel.fromJson(json)).toList();
      } else {
        throw Exception('Falha ao buscar heróis: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro ao buscar heróis: $e');
    }
  }

  // POST: Adiciona novo herói (não envia 'id')
  Future<HeroModel> addHero(HeroModel hero) async {
    final url = Uri.parse('$baseUrl/heroes');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': hero.name,
          'description': hero.description,
          'thumbnail': hero.thumbnail,
        }),
      );

      if (response.statusCode == 201) {
        return HeroModel.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Falha ao adicionar herói: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro ao adicionar herói: $e');
    }
  }

  // PUT: Atualiza herói existente (envia 'id')
  Future<HeroModel> updateHero(HeroModel hero) async {
    final url = Uri.parse('$baseUrl/heroes/${hero.id}');

    try {
      final response = await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': hero.name,
          'description': hero.description,
          'thumbnail': hero.thumbnail,
        }),
      );

      if (response.statusCode == 200) {
        return HeroModel.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Falha ao atualizar herói: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro ao atualizar herói: $e');
    }
  }

  // DELETE: Remove herói pelo ID
  Future<void> deleteHero(int id) async {
    final url = Uri.parse('$baseUrl/heroes/$id');

    try {
      final response = await http.delete(url);

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Falha ao deletar herói: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro ao deletar herói: $e');
    }
  }
}
