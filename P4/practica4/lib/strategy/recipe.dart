class Recipe {
  final int? id;
  final String name;
  final List<String> ingredients;
  final String instructions;
  final int difficulty;
  final String foodType;
  final DateTime createdAt;

  Recipe({
    this.id,
    required this.name,
    required this.ingredients,
    required this.instructions,
    required this.difficulty,
    required this.foodType,
    required this.createdAt,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      id: json['id'],
      name: json['nombre'],
      ingredients: (json['ingredientes'] as String).split(',').map((e) => e.trim()).toList(),
      instructions: json['instrucciones'] ?? '',
      difficulty: json['dificultad'] ?? 1,
      foodType: json['tipo_comida'] ?? 'salado',
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nombre': name,
      'ingredientes': ingredients.join(','),
      'instrucciones': instructions,
      'dificultad': difficulty,
      'tipo_comida': foodType,
    };
  }
}
