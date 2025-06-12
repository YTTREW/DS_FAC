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
      name: json['nombre'] ?? '',
      ingredients:
          json['ingredientes'] != null
              ? (json['ingredientes'] as String)
                  .split(',')
                  .map((e) => e.trim())
                  .where((e) => e.isNotEmpty)
                  .toList()
              : [],
      instructions: json['instrucciones'] ?? '',
      difficulty: json['dificultad'] ?? 1,
      foodType: json['tipo_comida'] ?? 'salado',
      createdAt:
          json['created_at'] != null
              ? DateTime.parse(json['created_at'])
              : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{
      'nombre': name,
      'ingredientes': ingredients.join(','), // String separado por comas
      'instrucciones': instructions,
      'dificultad': difficulty,
      'tipo_comida': foodType,
      'created_at': createdAt.toIso8601String(),
    };

    if (id != null) {
      json['id'] = id;
    }

    return json;
  }
}
