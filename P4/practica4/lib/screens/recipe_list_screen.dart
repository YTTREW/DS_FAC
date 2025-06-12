import 'package:flutter/material.dart';
import 'package:practica4/providers/ingredient_provider.dart';
import 'package:practica4/screens/ingredient_management_screen.dart';
import 'package:provider/provider.dart';
import '../providers/recipe_provider.dart';
import '../widgets/filter_dropdown.dart';
import '../widgets/recipe_card.dart';
import '../models/recipe.dart';
import 'recipe_form_screen.dart';

class RecipeListScreen extends StatelessWidget {
  const RecipeListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recetas'),
        backgroundColor: Colors.teal,
        actions: [
          IconButton(
            onPressed:
                () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const RecipeFormScreen(),
                  ),
                ),
            icon: const Icon(Icons.add),
            tooltip: 'Crear nueva receta',
          ),
          Consumer<IngredientProvider>(
            builder:
                (context, provider, child) => IconButton(
                  onPressed:
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => const IngredientManagementScreen(),
                        ),
                      ),
                  icon: Stack(
                    children: [
                      const Icon(Icons.kitchen),
                      if (provider.ingredientCount > 0)
                        Positioned(
                          right: 0,
                          top: 0,
                          child: Container(
                            padding: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            constraints: const BoxConstraints(
                              minWidth: 12,
                              minHeight: 12,
                            ),
                            child: Text(
                              '${provider.ingredientCount}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 8,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                    ],
                  ),
                  tooltip: 'Gestionar ingredientes',
                ),
          ),
        ],
      ),
      body: Column(
        children: [
          const FilterDropdown(),
          Expanded(
            child: Consumer<RecipeProvider>(
              builder: (context, provider, child) {
                if (provider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (provider.error != null) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error, size: 64, color: Colors.red),
                        const SizedBox(height: 16),
                        Text('Error: ${provider.error}'),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => provider.loadRecipes(),
                          child: const Text('Reintentar'),
                        ),
                      ],
                    ),
                  );
                }

                final recipes =
                    provider.filteredRecipes; // Usar filteredRecipes

                if (recipes.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.restaurant_menu,
                          size: 64,
                          color: Colors.grey,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          provider.hasActiveFilter
                              ? 'No hay recetas que coincidan con el filtro'
                              : 'No hay recetas disponibles',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        if (provider.hasActiveFilter) ...[
                          const SizedBox(height: 8),
                          TextButton(
                            onPressed: () => provider.clearFilter(),
                            child: const Text('Limpiar filtro'),
                          ),
                        ],
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: recipes.length,
                  itemBuilder: (context, index) {
                    final recipe = recipes[index];
                    return RecipeCard(
                      recipe: recipe,
                      onEdit: () => _navigateToEditRecipe(context, recipe),
                      onDelete: () => _confirmDeleteRecipe(context, recipe),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Métodos auxiliares en RecipeListScreen
  void _navigateToEditRecipe(BuildContext context, Recipe recipe) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RecipeFormScreen(recipe: recipe)),
    );
  }

  void _confirmDeleteRecipe(BuildContext context, Recipe recipe) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Confirmar eliminación'),
            content: Text(
              '¿Estás seguro de que quieres eliminar "${recipe.name}"?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _deleteRecipe(context, recipe);
                },
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: const Text('Eliminar'),
              ),
            ],
          ),
    );
  }

  void _deleteRecipe(BuildContext context, Recipe recipe) async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final recipeProvider = context.read<RecipeProvider>();

    try {
      await recipeProvider.deleteRecipe(recipe);
      scaffoldMessenger.showSnackBar(
        const SnackBar(
          content: Text('Receta eliminada exitosamente'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text('Error al eliminar: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
