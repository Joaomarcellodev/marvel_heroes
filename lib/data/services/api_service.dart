import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import '../models/hero_model.dart';

class ApiService {
  final String baseUrl = 'https://gateway.marvel.com/v1/public';
  final String publicKey = '8207a6a84b550fd8e0093e8651212604';
  final String privateKey = '1affa5a7f877c8379d8d0e55402bce78301cdc83';
  final List<HeroModel> _mockLocalHeroes = []; 

  String _generateHash(String timestamp) {
    return md5.convert(utf8.encode(timestamp + privateKey + publicKey)).toString();
  }

  // GET: Busca heróis da API Marvel
  Future<List<HeroModel>> fetchHeroes() async {
    final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    final hash = _generateHash(timestamp);
    final url = Uri.parse('$baseUrl/characters?ts=$timestamp&apikey=$publicKey&hash=$hash');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body)['data']['results'] as List;
        return data.map((json) => HeroModel.fromJson(json)).toList();
      } else {
        throw Exception('Falha ao buscar heróis: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro ao buscar heróis: $e');
    }
  }

  
  Future<HeroModel> addHero(HeroModel hero) async {
    await Future.delayed(Duration(seconds: 1)); 
    _mockLocalHeroes.add(hero);
    return hero;
  }

  
  Future<HeroModel> updateHero(HeroModel hero) async {
    await Future.delayed(Duration(seconds: 1)); 
    final index = _mockLocalHeroes.indexWhere((h) => h.id == hero.id);
    if (index != -1) {
      _mockLocalHeroes[index] = hero;
      return hero;
    } else {
      throw Exception('Herói não encontrado');
    }
  }

  
  Future<void> deleteHero(int id) async {
    await Future.delayed(Duration(seconds: 1)); 
    final index = _mockLocalHeroes.indexWhere((h) => h.id == id);
    if (index != -1) {
      _mockLocalHeroes.removeAt(index);
    } else {
      throw Exception('Herói não encontrado');
    }
  }

  
  List<HeroModel> getLocalHeroes() => _mockLocalHeroes;
}