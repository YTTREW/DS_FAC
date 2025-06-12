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
    this.variant =
        ChipVariant.selectable, // ✅ Cambio por defecto para nueva pantalla
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
      duration: const Duration(milliseconds: 150), // ✅ Animación más rápida
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
      onDeleted:
          widget.showDelete
              ? (widget.onDeleted ?? () => _removeFromProvider(context))
              : null,
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
      onTap: widget.onTap ?? () => _toggleInProvider(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isAvailable ? Colors.green.shade50 : Colors.red.shade50,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isAvailable ? Colors.green.shade300 : Colors.red.shade300,
            width: 1.5,
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
        _animationController.forward().then((_) {
          _animationController.reverse();
        });

        if (widget.onTap != null) {
          widget.onTap!();
        } else {
          _addToProvider(context);
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
              : Icon(
                Icons.add,
                size: 16,
                color: Theme.of(context).colorScheme.onSurface,
              ),
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
        width: isSelected ? 2 : 1,
      ),
      onSelected: (selected) {
        _animationController.forward().then((_) {
          _animationController.reverse();
        });

        if (widget.onTap != null) {
          widget.onTap!();
        } else {
          _toggleInProvider(context);
        }
      },
      selected: isSelected,
    );
  }

  // ✅ Métodos helper para gestionar el provider
  void _addToProvider(BuildContext context) {
    context.read<IngredientProvider>().addIngredient(widget.ingredient);
    _showSnackBar(
      context,
      '${_formatIngredientName(widget.ingredient)} añadido',
      Icons.check_circle,
      Colors.green,
    );
  }

  void _removeFromProvider(BuildContext context) {
    context.read<IngredientProvider>().removeIngredient(widget.ingredient);
    _showSnackBar(
      context,
      '${_formatIngredientName(widget.ingredient)} eliminado',
      Icons.remove_circle,
      Colors.orange,
    );
  }

  void _toggleInProvider(BuildContext context) {
    final provider = context.read<IngredientProvider>();
    if (provider.hasIngredient(widget.ingredient)) {
      _removeFromProvider(context);
    } else {
      _addToProvider(context);
    }
  }

  String _formatIngredientName(String ingredient) {
    if (ingredient.isEmpty) return ingredient;
    // ✅ Mejorar formato: capitalizar cada palabra
    return ingredient
        .split(' ')
        .map(
          (word) =>
              word.isNotEmpty
                  ? word[0].toUpperCase() + word.substring(1).toLowerCase()
                  : word,
        )
        .join(' ');
  }

  void _showSnackBar(
    BuildContext context,
    String message,
    IconData icon,
    Color color,
  ) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: color,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }
}

// ✅ Enum actualizado
enum ChipVariant {
  available, // Ingrediente disponible (verde, con delete)
  missing, // Ingrediente faltante (naranja, warning)
  recipe, // En contexto de receta (verde/rojo según disponibilidad)
  suggestion, // Sugerencia para añadir (azul, con +)
  selectable, // Chip seleccionable (toggle on/off) - NUEVO DEFECTO
}

// ✅ Widget específico para lista de ingredientes de receta
class RecipeIngredientsChips extends StatelessWidget {
  final List<String> ingredients;
  final bool showAvailability;
  final bool interactive;

  const RecipeIngredientsChips({
    super.key,
    required this.ingredients,
    this.showAvailability = true,
    this.interactive = false,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 6,
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

// ✅ Widget para sugerencias de ingredientes (mejorado)
class IngredientSuggestions extends StatelessWidget {
  final List<String> suggestions;
  final Function(String)? onSuggestionTapped;
  final int maxSuggestions;

  const IngredientSuggestions({
    super.key,
    required this.suggestions,
    this.onSuggestionTapped,
    this.maxSuggestions = 8,
  });

  @override
  Widget build(BuildContext context) {
    if (suggestions.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.lightbulb_outline,
              size: 16,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(width: 4),
            Text(
              'Ingredientes populares:',
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children:
              suggestions.take(maxSuggestions).map((suggestion) {
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

// ✅ Widget para mostrar ingredientes seleccionados
class SelectedIngredientsDisplay extends StatelessWidget {
  final List<String> selectedIngredients;
  final Function(String)? onRemove;
  final String? emptyMessage;

  const SelectedIngredientsDisplay({
    super.key,
    required this.selectedIngredients,
    this.onRemove,
    this.emptyMessage,
  });

  @override
  Widget build(BuildContext context) {
    if (selectedIngredients.isEmpty && emptyMessage != null) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Theme.of(context).dividerColor),
        ),
        child: Row(
          children: [
            Icon(
              Icons.info_outline,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                emptyMessage!,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children:
          selectedIngredients.map((ingredient) {
            return IngredientChip(
              ingredient: ingredient,
              variant: ChipVariant.available,
              onDeleted: onRemove != null ? () => onRemove!(ingredient) : null,
              showDelete: onRemove != null,
            );
          }).toList(),
    );
  }
}
