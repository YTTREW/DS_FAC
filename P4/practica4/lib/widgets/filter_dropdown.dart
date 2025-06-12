import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/recipe_provider.dart';
import '../providers/ingredient_provider.dart';
import '../patterns/strategy/recipe_filter_strategy.dart';
import '../patterns/strategy/filter_by_name.dart';
import '../patterns/strategy/filter_by_difficulty.dart';
import '../patterns/strategy/filter_by_available_ingredients.dart';

class FilterDropdown extends StatefulWidget {
  const FilterDropdown({super.key});

  @override
  State<FilterDropdown> createState() => _FilterDropdownState();
}

class _FilterDropdownState extends State<FilterDropdown> {
  String _selectedFilter = 'none';

  // Opciones de filtro disponibles (sin búsqueda)
  final Map<String, FilterOption> _filterOptions = {
    'none': FilterOption(
      label: 'Sin filtro',
      icon: Icons.filter_alt_off,
      description: 'Mostrar todas las recetas sin orden específico',
      color: Colors.grey,
    ),
    'name': FilterOption(
      label: 'Ordenar por nombre',
      icon: Icons.sort_by_alpha,
      description: 'Ordenar recetas alfabéticamente (A-Z)',
      color: Colors.blue,
    ),
    'difficulty': FilterOption(
      label: 'Ordenar por dificultad',
      icon: Icons.trending_up,
      description: 'Ordenar de fácil a difícil (1-10)',
      color: Colors.orange,
    ),
    'available_ingredients': FilterOption(
      label: 'Con ingredientes disponibles',
      icon: Icons.check_circle,
      description:
          'Solo recetas que puedes hacer con tus ingredientes actuales',
      color: Colors.green,
    ),
  };

  @override
  Widget build(BuildContext context) {
    return Consumer2<RecipeProvider, IngredientProvider>(
      builder: (context, recipeProvider, ingredientProvider, child) {
        return Container(
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Theme.of(context).dividerColor, width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(recipeProvider),
              const SizedBox(height: 12),
              _buildDropdown(recipeProvider, ingredientProvider),
              const SizedBox(height: 8),
              _buildDescription(),
              if (recipeProvider.hasActiveFilter) ...[
                const SizedBox(height: 8),
                _buildClearButton(recipeProvider),
                const SizedBox(height: 8),
                _buildFilterInfo(recipeProvider),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader(RecipeProvider recipeProvider) {
    final option = _filterOptions[_selectedFilter];
    final hasActiveFilter = recipeProvider.hasActiveFilter;

    return Row(
      children: [
        Icon(
          Icons.tune,
          color:
              hasActiveFilter
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.onSurfaceVariant,
          size: 20,
        ),
        const SizedBox(width: 8),
        Text(
          'Filtros y Ordenamiento',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color:
                hasActiveFilter
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        const Spacer(),
        if (hasActiveFilter)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color:
                  option?.color?.withValues(alpha: 0.1) ??
                  Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color:
                    option?.color?.withValues(alpha: 0.3) ??
                    Theme.of(
                      context,
                    ).colorScheme.primary.withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  option?.icon ?? Icons.filter_alt,
                  size: 12,
                  color: option?.color ?? Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 4),
                Text(
                  'Activo',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color:
                        option?.color ?? Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildDropdown(
    RecipeProvider recipeProvider,
    IngredientProvider ingredientProvider,
  ) {
    return DropdownButtonFormField<String>(
      value: _selectedFilter,
      isExpanded: true,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Theme.of(context).dividerColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.primary,
            width: 2,
          ),
        ),
      ),
      hint: const Text('Selecciona un filtro'),
      selectedItemBuilder: (BuildContext context) {
        // Builder para el elemento seleccionado (cuando el dropdown está cerrado)
        return _filterOptions.entries.map((entry) {
          return Row(
            children: [
              Icon(
                entry.value.icon,
                size: 20,
                color: entry.value.color ?? Theme.of(context).iconTheme.color,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  entry.value.label,
                  style: Theme.of(context).textTheme.bodyMedium,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          );
        }).toList();
      },
      items:
          _filterOptions.entries.map((entry) {
            // Items para la lista desplegable
            return DropdownMenuItem<String>(
              value: entry.key,
              child: Row(
                children: [
                  Icon(
                    entry.value.icon,
                    size: 20,
                    color:
                        entry.value.color ?? Theme.of(context).iconTheme.color,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      entry.value.label,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
      onChanged: (String? newValue) {
        if (newValue != null) {
          setState(() {
            _selectedFilter = newValue;
          });
          _applyFilter(recipeProvider, ingredientProvider, newValue);
        }
      },
    );
  }

  Widget _buildDescription() {
    final option = _filterOptions[_selectedFilter];
    if (option?.description == null) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Theme.of(
          context,
        ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Theme.of(context).dividerColor.withValues(alpha: 0.5),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline,
            size: 16,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              option!.description,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterInfo(RecipeProvider recipeProvider) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Theme.of(
          context,
        ).colorScheme.primaryContainer.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.filter_alt,
            size: 16,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Filtro activo: ${recipeProvider.filterDescription}',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  'Mostrando ${recipeProvider.filteredRecipesCount} de ${recipeProvider.totalRecipes} recetas',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildClearButton(RecipeProvider recipeProvider) {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton.icon(
        onPressed: () {
          setState(() {
            _selectedFilter = 'none';
          });
          recipeProvider.clearFilter();
        },
        icon: const Icon(Icons.clear, size: 16),
        label: const Text('Limpiar filtro'),
        style: TextButton.styleFrom(
          foregroundColor: Theme.of(context).colorScheme.error,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        ),
      ),
    );
  }

  void _applyFilter(
    RecipeProvider recipeProvider,
    IngredientProvider ingredientProvider,
    String filterKey,
  ) {
    RecipeFilterStrategy? strategy;

    switch (filterKey) {
      case 'none':
        strategy = null;
        break;
      case 'name':
        strategy = FilterByName();
        break;
      case 'difficulty':
        strategy = FilterByDifficulty();
        break;
      case 'available_ingredients':
        strategy = FilterByAvailableIngredients(
          ingredientProvider.availableIngredients.toList(),
        );
        break;
    }

    recipeProvider.setFilter(strategy);
  }
}

// Clase auxiliar para definir opciones de filtro
class FilterOption {
  final String label;
  final IconData icon;
  final String description;
  final Color? color;

  const FilterOption({
    required this.label,
    required this.icon,
    required this.description,
    this.color,
  });
}
