import 'package:flutter/material.dart';
import 'api/recetas_api.dart';

// STRATEGY
import 'strategy/recipe.dart';
import 'strategy/estrategia_receta.dart';
import 'strategy/estrategia_nombre.dart';
import 'strategy/estrategia_dificultad.dart';
import 'strategy/estrategia_ingredientes_disponibles.dart';

// DECORATOR
import 'decorator/component.dart';
import 'decorator/concrete_component.dart';
import 'decorator/decorator_favorito.dart';
import 'decorator/decorator_food_type.dart';
import 'decorator/decorator_ingredient_count.dart';
import 'decorator/decorator_creation_date.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App de Recetas',
      theme: ThemeData(primarySwatch: Colors.teal),
      home: const RecipePage(),
    );
  }
}

class RecipePage extends StatefulWidget {
  const RecipePage({super.key});

  @override
  State<RecipePage> createState() => _RecipePageState();
}

class _RecipePageState extends State<RecipePage> {
  @override
  void initState() {
    super.initState();
    _cargarRecetas(); // Llama a la API al iniciar
  }
  Future<void> _cargarRecetas() async {
  try {
    final data = await RecetaApi.obtenerRecetas();
    setState(() {
      recipes = data.map((json) => Recipe.fromJson(json)).toList();
    });
  } catch (e) {
    print("Error al cargar recetas: $e");
  }
}

  List<Recipe> recipes = [];

  List<String> availableIngredients = ['huevo', 'patata'];
  final Set<String> favoriteRecipes = {};

  String selectedFilter = 'Nombre';
  String searchTerm = '';

  final TextEditingController ingredientController = TextEditingController();
  final TextEditingController searchController = TextEditingController();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController ingredientsController = TextEditingController();
  int selectedDifficulty = 1;
  String selectedFoodType = 'salado';

  Recipe? editingRecipe;
  final TextEditingController editNameController = TextEditingController();
  final TextEditingController editIngredientsController = TextEditingController();
  int editDifficulty = 1;
  String editFoodType = 'salado';

  List<Recipe> _getFilteredRecipes() {
    RecipeFilterStrategy strategy;
    switch (selectedFilter) {
      case 'Dificultad':
        strategy = FilterByDifficulty();
        break;
      case 'Disponibles':
        strategy = FilterByAvailableIngredients(availableIngredients);
        break;
      case 'Nombre':
      default:
        strategy = FilterByName();
        break;
    }

    final filtered = strategy.apply([...recipes]);

    if (searchTerm.isNotEmpty) {
      return filtered
          .where((r) => r.name.toLowerCase().contains(searchTerm.toLowerCase()))
          .toList();
    }

    return filtered;
  }

  void _addIngredient(String ingredient) {
    if (ingredient.isNotEmpty && !availableIngredients.contains(ingredient)) {
      setState(() {
        availableIngredients.add(ingredient.toLowerCase());
        ingredientController.clear();
      });
    }
  }

  bool _hasAllIngredients(Recipe recipe) {
    return recipe.ingredients.every((i) => availableIngredients.contains(i));
  }

  void _toggleFavorite(String name) {
    setState(() {
      if (favoriteRecipes.contains(name)) {
        favoriteRecipes.remove(name);
      } else {
        favoriteRecipes.add(name);
      }
    });
  }

  void _addNewRecipe() async {
    final name = nameController.text.trim();
    final rawIngredients = ingredientsController.text.trim();

    if (name.isEmpty || rawIngredients.isEmpty) return;

    final ingredients = rawIngredients
        .split(',')
        .map((e) => e.trim().toLowerCase())
        .where((e) => e.isNotEmpty)
        .toList();

    final nuevaReceta = Recipe(
      name: name,
      ingredients: ingredients,
      difficulty: selectedDifficulty,
      foodType: selectedFoodType,
      createdAt: DateTime.now(),
    );

    try {
      await RecetaApi.crearReceta(nuevaReceta.toJson());
      nameController.clear();
      ingredientsController.clear();
      _cargarRecetas();
    } catch (e) {
      print("Error al crear receta: $e");
    }
  }

  void _editRecipe(Recipe recipe) {
    editingRecipe = recipe;
    editNameController.text = recipe.name;
    editIngredientsController.text = recipe.ingredients.join(', ');
    editDifficulty = recipe.difficulty;
    editFoodType = recipe.foodType;

    showDialog(
      context: context,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setLocalState) {
            return AlertDialog(
              title: const Text('Editar Receta'),
              content: SingleChildScrollView(
                child: Column(
                  children: [
                    TextField(
                      controller: editNameController,
                      decoration: const InputDecoration(labelText: 'Nombre'),
                    ),
                    TextField(
                      controller: editIngredientsController,
                      decoration: const InputDecoration(labelText: 'Ingredientes (coma)'),
                    ),
                    DropdownButton<int>(
                      value: editDifficulty,
                      items: [1, 2, 3]
                          .map((d) => DropdownMenuItem(value: d, child: Text("Dificultad $d")))
                          .toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setLocalState(() => editDifficulty = value);
                        }
                      },
                    ),
                    DropdownButton<String>(
                      value: editFoodType,
                      items: ['dulce', 'salado']
                          .map((tipo) => DropdownMenuItem(
                        value: tipo,
                        child: Text("Tipo: $tipo"),
                      ))
                          .toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setLocalState(() => editFoodType = value);
                        }
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancelar'),
                ),
                ElevatedButton(
                  onPressed: () {
                    final newName = editNameController.text.trim();
                    final raw = editIngredientsController.text.trim();

                    if (newName.isEmpty || raw.isEmpty || editingRecipe == null) return;

                    final newIngredients = raw
                        .split(',')
                        .map((e) => e.trim().toLowerCase())
                        .where((e) => e.isNotEmpty)
                        .toList();

                    setState(() {
                      final index = recipes.indexOf(editingRecipe!);
                      if (index != -1) {
                        recipes[index] = Recipe(
                          name: newName,
                          ingredients: newIngredients,
                          difficulty: editDifficulty,
                          foodType: editFoodType,
                          createdAt: editingRecipe!.createdAt,
                        );
                      }
                      editingRecipe = null;
                    });

                    Navigator.of(context).pop();
                  },
                  child: const Text('Guardar'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredRecipes = _getFilteredRecipes();

    return Scaffold(
      appBar: AppBar(title: const Text('Recetas')),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            TextField(
              controller: searchController,
              decoration: const InputDecoration(
                labelText: 'Buscar receta',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                setState(() => searchTerm = value);
              },
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: ingredientController,
                    decoration: const InputDecoration(
                      labelText: 'Añadir ingrediente disponible',
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () => _addIngredient(ingredientController.text),
                ),
              ],
            ),
            Wrap(
              spacing: 6.0,
              children: availableIngredients.map(
                    (i) => Chip(
                  label: Text(i),
                  deleteIcon: const Icon(Icons.close),
                  onDeleted: () {
                    setState(() {
                      availableIngredients.remove(i);
                    });
                  },
                ),
              ).toList(),
            ),
            const SizedBox(height: 10),
            DropdownButton<String>(
              value: selectedFilter,
              items: ['Nombre', 'Dificultad', 'Disponibles']
                  .map((f) => DropdownMenuItem(value: f, child: Text(f)))
                  .toList(),
              onChanged: (value) {
                selectedFilter = value!;
                setState(() {});
              },
            ),
            const Divider(),
            ExpansionTile(
              title: const Text("Agregar nueva receta"),
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Nombre de la receta'),
                ),
                TextField(
                  controller: ingredientsController,
                  decoration: const InputDecoration(labelText: 'Ingredientes (coma)'),
                ),
                DropdownButton<int>(
                  value: selectedDifficulty,
                  items: [1, 2, 3]
                      .map((d) => DropdownMenuItem(value: d, child: Text("Dificultad $d")))
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => selectedDifficulty = value);
                    }
                  },
                ),
                DropdownButton<String>(
                  value: selectedFoodType,
                  items: ['dulce', 'salado']
                      .map((tipo) => DropdownMenuItem(
                    value: tipo,
                    child: Text("Tipo: $tipo"),
                  ))
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => selectedFoodType = value);
                    }
                  },
                ),
                ElevatedButton(
                  onPressed: _addNewRecipe,
                  child: const Text('Agregar receta'),
                ),
              ],
            ),
            const Divider(),
            Expanded(
              child: ListView.builder(
                itemCount: filteredRecipes.length,
                itemBuilder: (context, index) {
                  final r = filteredRecipes[index];
                  final isFavorite = favoriteRecipes.contains(r.name);
                  final hasIngredients = _hasAllIngredients(r);

                  RecipeComponent decorated = BasicRecipe(r);
                  decorated = IngredientCountDecorator(decorated, r);
                  decorated = CreationDateDecorator(decorated, r.createdAt);
                  decorated = FoodTypeDecorator(decorated, r.foodType);
                  if (isFavorite) {
                    decorated = FavoriteRecipeDecorator(decorated);
                  }
                  if (!hasIngredients) {
                    decorated = NoteRecipeDecorator(decorated, 'Faltan ingredientes');
                  }

                  return ListTile(
                    title: Text(decorated.getDescription()),
                    subtitle: Text('Ingredientes: ${r.ingredients.join(', ')}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(
                            isFavorite ? Icons.favorite : Icons.favorite_border,
                            color: isFavorite ? Colors.red : null,
                          ),
                          onPressed: () => _toggleFavorite(r.name),
                        ),
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () => _editRecipe(r),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          color: Colors.red,
                          onPressed: () {
                            setState(() {
                              recipes.remove(r);
                              favoriteRecipes.remove(r.name);
                            });
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}