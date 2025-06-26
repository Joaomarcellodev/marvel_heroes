import '../models/hero_model.dart';
import '../services/api_service.dart';

class HeroRepository {
  final ApiService _apiService;

  HeroRepository(this._apiService);

  Future<List<HeroModel>> fetchHeroes() => _apiService.fetchHeroes();

  Future<HeroModel> addHero(HeroModel hero) => _apiService.addHero(hero);

  Future<HeroModel> updateHero(HeroModel hero) => _apiService.updateHero(hero);

  Future<void> deleteHero(int id) => _apiService.deleteHero(id);

  // Removi o getLocalHeroes porque não existe mais no ApiService
}
