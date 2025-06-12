import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/recipe.dart';
import '../providers/recipe_provider.dart';
import '../providers/ingredient_provider.dart';
import '../patterns/decorator/recipe_component.dart';
import '../patterns/decorator/base_recipe.dart';
import '../patterns/decorator/decorators/difficulty_decorator.dart';
import '../patterns/decorator/decorators/favorite_recipe_decorator.dart';

class RecipeCard extends StatelessWidget {
  final Recipe recipe;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const RecipeCard({
    super.key,
    required this.recipe,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer2<RecipeProvider, IngredientProvider>(
      builder: (context, recipeProvider, ingredientProvider, child) {
        final isFavorite = recipeProvider.favoriteRecipes.contains(recipe.name);
        final hasAllIngredients = _hasAllIngredients(ingredientProvider);

        // Aplicar patrón Decorator
        RecipeComponent decorated = BaseRecipe(recipe);
        decorated = DifficultyDecorator(decorated, recipe.difficulty);

        if (isFavorite) {
          decorated = FavoriteRecipeDecorator(decorated);
        }

        return Card(
          margin: const EdgeInsets.symmetric(vertical: 4),
          child: ListTile(
            title: Text(
              decorated.getDescription(),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle:
                hasAllIngredients
                    ? null
                    : const Text(
                      'Faltan ingredientes',
                      style: TextStyle(color: Colors.orange),
                    ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: isFavorite ? Colors.red : null,
                  ),
                  onPressed: () => recipeProvider.toggleFavorite(recipe.name),
                ),
                IconButton(icon: const Icon(Icons.edit), onPressed: onEdit),
                IconButton(
                  icon: const Icon(Icons.delete),
                  color: Colors.red,
                  onPressed: onDelete,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  bool _hasAllIngredients(IngredientProvider provider) {
    return recipe.ingredients.every(
      (ingredient) => provider.availableIngredients.contains(ingredient),
    );
  }
}
