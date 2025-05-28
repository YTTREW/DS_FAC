class Recipe {
  final String name;
  final List<String> ingredients;
  final int difficulty;
  final String foodType; // 'dulce' o 'salado'
  final DateTime createdAt;

  Recipe({
    required this.name,
    required this.ingredients,
    required this.difficulty,
    required this.foodType,
    required this.createdAt,
  });
}
