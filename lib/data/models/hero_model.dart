class HeroModel {
  final int id;
  final String name;
  final String description;
  final String thumbnail;

  HeroModel({
    required this.id,
    required this.name,
    required this.description,
    required this.thumbnail,
  });

  factory HeroModel.fromJson(Map<String, dynamic> json) {
    return HeroModel(
      id: int.parse(json['id'].toString()),  // mockapi retorna id como string
      name: json['name'] ?? 'Sem nome',
      description: json['description'] ?? 'Sem descrição disponível',
      thumbnail: json['thumbnail'] ?? 'https://via.placeholder.com/150',  // URL direta da imagem
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'thumbnail': thumbnail,
    };
  }
}
