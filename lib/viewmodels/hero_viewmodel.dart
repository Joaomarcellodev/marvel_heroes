import 'package:flutter/material.dart';
import '../data/models/hero_model.dart';
import '../data/repository/hero_repository.dart';

enum ViewState { idle, loading, error }

class HeroViewModel extends ChangeNotifier {
  final HeroRepository _repository;
  List<HeroModel> heroes = [];
  ViewState state = ViewState.idle;
  String? errorMessage;

  HeroViewModel(this._repository);

  Future<void> fetchHeroes() async {
    state = ViewState.loading;
    notifyListeners();

    try {
      heroes = await _repository.fetchHeroes();
      heroes.addAll(_repository.getLocalHeroes()); 
      state = ViewState.idle;
    } catch (e) {
      state = ViewState.error;
      errorMessage = e.toString();
    }
    notifyListeners();
  }

  Future<void> addHero(String name, String description, String thumbnail) async {
    state = ViewState.loading;
    notifyListeners();

    try {
      final newHero = HeroModel(
        id: DateTime.now().millisecondsSinceEpoch, 
        name: name,
        description: description,
        thumbnail: thumbnail.isEmpty ? 'https://via.placeholder.com/150' : thumbnail,
      );
      await _repository.addHero(newHero);
      heroes.add(newHero);
      state = ViewState.idle;
    } catch (e) {
      state = ViewState.error;
      errorMessage = e.toString();
    }
    notifyListeners();
  }

  Future<void> updateHero(HeroModel hero) async {
    state = ViewState.loading;
    notifyListeners();

    try {
      final updatedHero = await _repository.updateHero(hero);
      final index = heroes.indexWhere((h) => h.id == hero.id);
      if (index != -1) {
        heroes[index] = updatedHero;
      }
      state = ViewState.idle;
    } catch (e) {
      state = ViewState.error;
      errorMessage = e.toString();
    }
    notifyListeners();
  }

  Future<void> deleteHero(int id) async {
    state = ViewState.loading;
    notifyListeners();

    try {
      await _repository.deleteHero(id);
      heroes.removeWhere((h) => h.id == id);
      state = ViewState.idle;
    } catch (e) {
      state = ViewState.error;
      errorMessage = e.toString();
    }
    notifyListeners();
  }
}