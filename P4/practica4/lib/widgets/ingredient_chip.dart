import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/ingredient_provider.dart';

class IngredientChip extends StatefulWidget {
  final String ingredient;
  final VoidCallback? onDeleted;
  final VoidCallback? onTap;
  final bool showDelete;
  final bool isSelected;
  final bool isAvailable;
  final ChipVariant variant;
  final Color? customColor;

  const IngredientChip({
    super.key,
    required this.ingredient,
    this.onDeleted,
    this.onTap,
    this.showDelete = true,
    this.isSelected = false,
    this.isAvailable = true,
    this.variant = ChipVariant.available,
    this.customColor,
  });

  @override
  State<IngredientChip> createState() => _IngredientChipState();
}

class _IngredientChipState extends State<IngredientChip>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<IngredientProvider>(
      builder: (context, ingredientProvider, child) {
        final isProviderAvailable = ingredientProvider.hasIngredient(
          widget.ingredient,
        );

        return AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: _buildChipContent(context, isProviderAvailable),
            );
          },
        );
      },
    );
  }

  Widget _buildChipContent(BuildContext context, bool isProviderAvailable) {
    switch (widget.variant) {
      case ChipVariant.available:
        return _buildAvailableChip(context);
      case ChipVariant.missing:
        return _buildMissingChip(context);
      case ChipVariant.recipe:
        return _buildRecipeChip(context, isProviderAvailable);
      case ChipVariant.suggestion:
        return _buildSuggestionChip(context);
      case ChipVariant.selectable:
        return _buildSelectableChip(context, isProviderAvailable);
    }
  }

  Widget _buildAvailableChip(BuildContext context) {
    return FilterChip(
      label: Text(
        _formatIngredientName(widget.ingredient),
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          fontWeight: FontWeight.w500,
          color: Colors.green.shade700,
        ),
      ),
      avatar: Icon(Icons.check_circle, size: 18, color: Colors.green.shade600),
      onDeleted: widget.showDelete ? widget.onDeleted : null,
      deleteIcon: const Icon(Icons.close, size: 16),
      deleteIconColor: Colors.green.shade600,
      backgroundColor: Colors.green.shade50,
      selectedColor: Colors.green.shade100,
      side: BorderSide(color: Colors.green.shade200),
      onSelected: widget.onTap != null ? (_) => widget.onTap!() : null,
      selected: widget.isSelected,
    );
  }

  Widget _buildMissingChip(BuildContext context) {
    return FilterChip(
      label: Text(
        _formatIngredientName(widget.ingredient),
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          fontWeight: FontWeight.w500,
          color: Colors.orange.shade700,
        ),
      ),
      avatar: Icon(
        Icons.warning_rounded,
        size: 18,
        color: Colors.orange.shade600,
      ),
      backgroundColor: Colors.orange.shade50,
      side: BorderSide(color: Colors.orange.shade200),
      onSelected: widget.onTap != null ? (_) => widget.onTap!() : null,
      selected: widget.isSelected,
    );
  }

  Widget _buildRecipeChip(BuildContext context, bool isProviderAvailable) {
    final isAvailable = widget.isAvailable || isProviderAvailable;

    return GestureDetector(
      onTapDown: (_) => _animationController.forward(),
      onTapUp: (_) => _animationController.reverse(),
      onTapCancel: () => _animationController.reverse(),
      onTap: widget.onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isAvailable ? Colors.green.shade50 : Colors.red.shade50,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isAvailable ? Colors.green.shade200 : Colors.red.shade200,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isAvailable ? Icons.check_circle : Icons.cancel,
              size: 16,
              color: isAvailable ? Colors.green.shade600 : Colors.red.shade600,
            ),
            const SizedBox(width: 6),
            Text(
              _formatIngredientName(widget.ingredient),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w500,
                color:
                    isAvailable ? Colors.green.shade700 : Colors.red.shade700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSuggestionChip(BuildContext context) {
    return ActionChip(
      label: Text(
        _formatIngredientName(widget.ingredient),
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          fontWeight: FontWeight.w500,
          color: Colors.blue.shade700,
        ),
      ),
      avatar: Icon(
        Icons.add_circle_outline,
        size: 18,
        color: Colors.blue.shade600,
      ),
      backgroundColor: Colors.blue.shade50,
      side: BorderSide(color: Colors.blue.shade200),
      onPressed: () {
        if (widget.onTap != null) {
          widget.onTap!();
        } else {
          // Añadir automáticamente a ingredientes disponibles
          context.read<IngredientProvider>().addIngredient(widget.ingredient);
          _showAddedSnackBar(context);
        }
      },
    );
  }

  Widget _buildSelectableChip(BuildContext context, bool isProviderAvailable) {
    final isSelected = widget.isSelected || isProviderAvailable;

    return FilterChip(
      label: Text(
        _formatIngredientName(widget.ingredient),
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          fontWeight: FontWeight.w500,
          color:
              isSelected
                  ? Theme.of(context).colorScheme.onPrimary
                  : Theme.of(context).colorScheme.onSurface,
        ),
      ),
      avatar:
          isSelected
              ? Icon(
                Icons.check,
                size: 16,
                color: Theme.of(context).colorScheme.onPrimary,
              )
              : null,
      backgroundColor:
          isSelected
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.surface,
      selectedColor: Theme.of(context).colorScheme.primary,
      side: BorderSide(
        color:
            isSelected
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).dividerColor,
      ),
      onSelected: (selected) {
        if (widget.onTap != null) {
          widget.onTap!();
        } else {
          // Toggle automático en provider
          context.read<IngredientProvider>().toggleIngredient(
            widget.ingredient,
          );
        }
      },
      selected: isSelected,
    );
  }

  String _formatIngredientName(String ingredient) {
    // Capitalizar primera letra y limpiar formato
    if (ingredient.isEmpty) return ingredient;
    return ingredient[0].toUpperCase() + ingredient.substring(1).toLowerCase();
  }

  void _showAddedSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                '${_formatIngredientName(widget.ingredient)} añadido a tus ingredientes',
              ),
            ),
          ],
        ),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}

// Enum para diferentes variantes del chip
enum ChipVariant {
  available, // Ingrediente disponible (verde, con delete)
  missing, // Ingrediente faltante (naranja, warning)
  recipe, // En contexto de receta (verde/rojo según disponibilidad)
  suggestion, // Sugerencia para añadir (azul, con +)
  selectable, // Chip seleccionable (toggle on/off)
}

// Widget específico para lista de ingredientes de receta
class RecipeIngredientsChips extends StatelessWidget {
  final List<String> ingredients;
  final bool showAvailability;

  const RecipeIngredientsChips({
    super.key,
    required this.ingredients,
    this.showAvailability = true,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 6,
      runSpacing: 4,
      children:
          ingredients.map((ingredient) {
            return IngredientChip(
              ingredient: ingredient,
              variant:
                  showAvailability
                      ? ChipVariant.recipe
                      : ChipVariant.selectable,
              showDelete: false,
            );
          }).toList(),
    );
  }
}

// Widget para sugerencias de ingredientes
class IngredientSuggestions extends StatelessWidget {
  final List<String> suggestions;
  final Function(String)? onSuggestionTapped;

  const IngredientSuggestions({
    super.key,
    required this.suggestions,
    this.onSuggestionTapped,
  });

  @override
  Widget build(BuildContext context) {
    if (suggestions.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Sugerencias:',
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 4),
        Wrap(
          spacing: 6,
          runSpacing: 4,
          children:
              suggestions.take(5).map((suggestion) {
                return IngredientChip(
                  ingredient: suggestion,
                  variant: ChipVariant.suggestion,
                  onTap: () => onSuggestionTapped?.call(suggestion),
                );
              }).toList(),
        ),
      ],
    );
  }
}
