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
import 'decorator/decorator_difficulty.dart';
import 'decorator/decorator_instructions.dart';
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
    print(data);
    setState(() {
      recipes = data.map((json) => Recipe.fromJson(json)).toList();
    });
  } catch (e) {
    print("Error al cargar recetas: $e");
  }
}

  List<Recipe> recipes = [];

  List<String> availableIngredients = ['huevo', 'patata', 'harina', 'melon', 'arroz', 'aceite', 'especias'];
  final Set<String> favoriteRecipes = {};

  String selectedFilter = 'Nombre';
  String searchTerm = '';

  final TextEditingController ingredientController = TextEditingController();
  final TextEditingController searchController = TextEditingController();
  final TextEditingController instructionsController = TextEditingController();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController ingredientsController = TextEditingController();
  int selectedDifficulty = 1;
  String selectedFoodType = 'salado';

  Recipe? editingRecipe;
  final TextEditingController editNameController = TextEditingController();
  final TextEditingController editIngredientsController = TextEditingController();
  final TextEditingController editInstructionsController = TextEditingController();

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
    final ing = ingredient.toLowerCase().trim();
    if (ing.isNotEmpty && !availableIngredients.contains(ing)) {
      setState(() {
      availableIngredients = List.from(availableIngredients)..add(ing);
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
    final instructions = instructionsController.text.trim();

    if (name.isEmpty || rawIngredients.isEmpty) return;

    final ingredients = rawIngredients
        .split(',')
        .map((e) => e.trim().toLowerCase())
        .where((e) => e.isNotEmpty)
        .toList();

    final nuevaReceta = Recipe(
      name: name,
      ingredients: ingredients,
      instructions: instructions,
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
    editInstructionsController.text = recipe.instructions;
    editIngredientsController.text = recipe.ingredients.join(', ');
    editDifficulty = recipe.difficulty;
    editFoodType = recipe.foodType.toLowerCase();

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
                    TextField(
                      controller: editInstructionsController,
                      decoration: const InputDecoration(labelText: 'Instrucciones'),
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
                        child: Text("Tipo: ${tipo[0].toUpperCase()}${tipo.substring(1)}"), // muestra con mayúscula
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
                  onPressed: () async {
                    final newName = editNameController.text.trim();
                    final raw = editIngredientsController.text.trim();
                    final newInstructions = editInstructionsController.text.trim();

                    if (newName.isEmpty || raw.isEmpty || newInstructions.isEmpty ||editingRecipe == null) return;

                    final newIngredients = raw
                        .split(',')
                        .map((e) => e.trim().toLowerCase())
                        .where((e) => e.isNotEmpty)
                        .toList();

                                    
                    final updatedRecipe = Recipe(
                      id: editingRecipe!.id,
                      name: newName,
                      ingredients: newIngredients,
                      instructions: newInstructions,
                      difficulty: editDifficulty,
                      foodType: editFoodType,
                      createdAt: editingRecipe!.createdAt,
                    );


                      try {
                        // Actualizar en backend
                        await RecetaApi.actualizarReceta(updatedRecipe.id!, {
                          'nombre': updatedRecipe.name,
                          'ingredientes': updatedRecipe.ingredients.join(', '),
                          'instrucciones': updatedRecipe.instructions,
                          'dificultad': updatedRecipe.difficulty,
                          'tipo_comida': updatedRecipe.foodType,
                        });

                        // Actualizar en la lista local y UI
                        setState(() {
                          final index = recipes.indexWhere((r) => r.id == updatedRecipe.id);
                          if (index != -1) {
                            recipes[index] = updatedRecipe;
                          }
                          editingRecipe = null;
                        });

                        Navigator.of(context).pop();
                      } catch (e) {
                        // Manejo de error, muestra mensaje por ejemplo
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Error al actualizar la receta: $e')),
                        );
                      }
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
                TextField(
                  controller: instructionsController,
                  decoration: const InputDecoration(labelText: 'Instrucciones'),
                  maxLines: 3,
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
                  decorated = DifficultyDecorator(decorated, r.difficulty);
                  decorated = InstructionsDecorator(decorated, r.instructions);
                  decorated = IngredientCountDecorator(decorated, r);
                  decorated = CreationDateDecorator(decorated, r.createdAt);
                  decorated = FoodTypeDecorator(decorated, r.foodType);
                  if (isFavorite) {
                    decorated = FavoriteRecipeDecorator(decorated);
                  }
                  if (!hasIngredients) {
                    decorated = NoteRecipeDecorator(decorated, 'Algunos de estos ingredientes no están disponibles actualmente');
                  }

                  return ListTile(
                    title: Text(decorated.getDescription(), maxLines: 10), 
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
                          onPressed: () async {
                            try {
                                await RecetaApi.eliminarReceta(r.id!); // ← ¡importante el ! porque id no puede ser null!
                                setState(() {
                                  recipes.remove(r);
                                  favoriteRecipes.remove(r.name);
                                });
                              } catch (e) {
                                print("Error al eliminar receta: $e");
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("No se pudo eliminar la receta")),
                                );
                              }
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