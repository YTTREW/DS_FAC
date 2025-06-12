import 'package:flutter/material.dart';
import 'package:practica4/patterns/decorator/decorators/creation_date_decorator.dart';
import 'package:practica4/patterns/decorator/decorators/food_type_decorator.dart';
import 'package:practica4/patterns/decorator/decorators/ingredient_count_decorator.dart';
import 'package:practica4/patterns/decorator/decorators/instructions_decorator.dart';
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
        decorated = FoodTypeDecorator(decorated, recipe.foodType);
        decorated = IngredientCountDecorator(decorated, recipe);
        decorated = InstructionsDecorator(decorated, recipe.instructions);
        decorated = CreationDateDecorator(decorated, recipe.createdAt);

        if (isFavorite) {
          decorated = FavoriteRecipeDecorator(decorated);
        }

        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
          elevation: 2,
          child: ExpansionTile(
            title: Text(
              recipe.name,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            subtitle: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color:
                        hasAllIngredients
                            ? Colors.green.shade50
                            : Colors.orange.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    hasAllIngredients ? 'Listo' : 'Faltan ingredientes',
                    style: TextStyle(
                      fontSize: 12,
                      color:
                          hasAllIngredients
                              ? Colors.green.shade700
                              : Colors.orange.shade700,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                if (isFavorite)
                  Icon(Icons.favorite, color: Colors.red, size: 16),
              ],
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
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Theme.of(context)
                            .colorScheme
                            .surfaceContainerHighest
                            .withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        decorated.getDescription(),
                        style: Theme.of(
                          context,
                        ).textTheme.bodySmall?.copyWith(height: 1.4),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Creada: ${recipe.createdAt.day}/${recipe.createdAt.month}/${recipe.createdAt.year}',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
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
