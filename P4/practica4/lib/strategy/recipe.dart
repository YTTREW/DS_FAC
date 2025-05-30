class Recipe {
  final int? id;
  final String name;
  final List<String> ingredients;
  final int difficulty;
  final String foodType; // 'dulce' o 'salado'
  final DateTime createdAt;

  Recipe({
    this.id,
    required this.name,
    required this.ingredients,
    required this.difficulty,
    required this.foodType,
    required this.createdAt,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      id: json['id'],
      name: json['nombre'],
      ingredients: (json['ingredientes'] as String).split(',').map((e) => e.trim()).toList(),
      difficulty: json['dificultad'] ?? 1,
      foodType: json['tipo'] ?? 'salado',
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nombre': name,
      'ingredientes': ingredients.join(','),
      'dificultad': difficulty,
      'tipo': foodType,
    };
  }
}
