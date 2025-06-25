import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import '../models/hero_model.dart';

class ApiService {
  final String baseUrl = 'https://gateway.marvel.com/v1/public';
  final String publicKey = 'YOUR_PUBLIC_KEY';
  final String privateKey = 'YOUR_PRIVATE_KEY';
  final List<HeroModel> _mockLocalHeroes = []; // Armazenamento simulado

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

  // POST: Simula adição de herói
  Future<HeroModel> addHero(HeroModel hero) async {
    await Future.delayed(Duration(seconds: 1)); // Simula latência
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