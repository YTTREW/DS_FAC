import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/recipe.dart';
import '../providers/recipe_provider.dart';
import '../providers/ingredient_provider.dart';
import '../widgets/ingredient_chip.dart';
import '../config/theme.dart';

class RecipeFormScreen extends StatefulWidget {
  final Recipe? recipe; // null para crear, Recipe para editar

  const RecipeFormScreen({super.key, this.recipe});

  @override
  State<RecipeFormScreen> createState() => _RecipeFormScreenState();
}

class _RecipeFormScreenState extends State<RecipeFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _instructionsController = TextEditingController();
  final _ingredientController = TextEditingController();

  List<String> _selectedIngredients = [];
  int _difficulty = 1;
  String _foodType = 'salado';
  bool _isLoading = false;

  // Para sugerencias de ingredientes
  List<String> _ingredientSuggestions = [];
  bool _showSuggestions = false;

  @override
  void initState() {
    super.initState();
    _initializeForm();
    _ingredientController.addListener(_onIngredientTextChanged);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _instructionsController.dispose();
    _ingredientController.dispose();
    super.dispose();
  }

  void _initializeForm() {
    if (widget.recipe != null) {
      // Modo edición
      _nameController.text = widget.recipe!.name;
      _instructionsController.text = widget.recipe!.instructions;
      _selectedIngredients = List.from(widget.recipe!.ingredients);
      _difficulty = widget.recipe!.difficulty;
      _foodType = widget.recipe!.foodType;
    }
  }

  void _onIngredientTextChanged() {
    final text = _ingredientController.text.trim();
    if (text.isNotEmpty) {
      final suggestions = context
          .read<IngredientProvider>()
          .getIngredientSuggestions(text);
      setState(() {
        _ingredientSuggestions = suggestions;
        _showSuggestions = suggestions.isNotEmpty;
      });
    } else {
      setState(() {
        _showSuggestions = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.recipe == null ? 'Nueva Receta' : 'Editar Receta'),
        actions: [
          if (widget.recipe != null)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: _confirmDelete,
              color: Colors.red,
            ),
        ],
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                padding: const EdgeInsets.all(AppDimensions.paddingMedium),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildNameField(),
                      const SizedBox(height: AppDimensions.paddingMedium),
                      _buildInstructionsField(),
                      const SizedBox(height: AppDimensions.paddingMedium),
                      _buildIngredientsSection(),
                      const SizedBox(height: AppDimensions.paddingMedium),
                      _buildDifficultySection(),
                      const SizedBox(height: AppDimensions.paddingMedium),
                      _buildFoodTypeSection(),
                      const SizedBox(height: AppDimensions.paddingLarge),
                      _buildActionButtons(),
                    ],
                  ),
                ),
              ),
    );
  }

  Widget _buildNameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Nombre de la receta',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _nameController,
          decoration: const InputDecoration(
            hintText: 'Ej: Paella Valenciana',
            prefixIcon: Icon(Icons.restaurant),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Por favor, ingresa el nombre de la receta';
            }
            if (value.trim().length < 3) {
              return 'El nombre debe tener al menos 3 caracteres';
            }
            return null;
          },
          textCapitalization: TextCapitalization.words,
        ),
      ],
    );
  }

  Widget _buildInstructionsField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Instrucciones',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _instructionsController,
          decoration: const InputDecoration(
            hintText: 'Describe paso a paso cómo preparar la receta...',
            prefixIcon: Icon(Icons.list_alt),
            alignLabelWithHint: true,
          ),
          maxLines: 5,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Por favor, ingresa las instrucciones';
            }
            return null;
          },
          textCapitalization: TextCapitalization.sentences,
        ),
      ],
    );
  }

  Widget _buildIngredientsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Ingredientes',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        _buildIngredientInput(),
        if (_showSuggestions) ...[
          const SizedBox(height: 8),
          _buildIngredientSuggestions(),
        ],
        const SizedBox(height: 12),
        _buildSelectedIngredients(),
        if (_selectedIngredients.isEmpty)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(
                context,
              ).colorScheme.errorContainer.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Theme.of(
                  context,
                ).colorScheme.error.withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.warning_amber,
                  color: Theme.of(context).colorScheme.error,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'Añade al menos un ingrediente',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.error,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildIngredientInput() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _ingredientController,
            decoration: const InputDecoration(
              hintText: 'Añadir ingrediente...',
              prefixIcon: Icon(Icons.add_shopping_cart),
            ),
            textCapitalization: TextCapitalization.words,
            onSubmitted: _addIngredient,
          ),
        ),
        const SizedBox(width: 8),
        IconButton.filled(
          onPressed: () => _addIngredient(_ingredientController.text),
          icon: const Icon(Icons.add),
          tooltip: 'Añadir ingrediente',
        ),
      ],
    );
  }

  Widget _buildIngredientSuggestions() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(
          context,
        ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Sugerencias:',
            style: Theme.of(
              context,
            ).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 6),
          Wrap(
            spacing: 6,
            runSpacing: 4,
            children:
                _ingredientSuggestions.map((suggestion) {
                  return IngredientChip(
                    ingredient: suggestion,
                    variant: ChipVariant.suggestion,
                    onTap: () => _addIngredientFromSuggestion(suggestion),
                  );
                }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectedIngredients() {
    if (_selectedIngredients.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Ingredientes seleccionados (${_selectedIngredients.length})',
                style: Theme.of(
                  context,
                ).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w500),
              ),
              const Spacer(),
              TextButton.icon(
                onPressed:
                    _selectedIngredients.isNotEmpty
                        ? _clearAllIngredients
                        : null,
                icon: const Icon(Icons.clear_all, size: 16),
                label: const Text('Limpiar'),
                style: TextButton.styleFrom(
                  foregroundColor: Theme.of(context).colorScheme.error,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 6,
            runSpacing: 4,
            children:
                _selectedIngredients.map((ingredient) {
                  return IngredientChip(
                    ingredient: ingredient,
                    variant: ChipVariant.available,
                    onDeleted: () => _removeIngredient(ingredient),
                  );
                }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildDifficultySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Dificultad',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Theme.of(context).dividerColor),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Icon(
                    _getDifficultyIcon(_difficulty),
                    color: _getDifficultyColor(_difficulty),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _getDifficultyLabel(_difficulty),
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: _getDifficultyColor(_difficulty),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '$_difficulty/10',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Slider(
                value: _difficulty.toDouble(),
                min: 1,
                max: 10,
                divisions: 9,
                label: '$_difficulty',
                onChanged: (value) {
                  setState(() {
                    _difficulty = value.round();
                  });
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFoodTypeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tipo de comida',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        SegmentedButton<String>(
          segments: const [
            ButtonSegment<String>(
              value: 'salado',
              label: Text('Salado'),
              icon: Icon(Icons.restaurant),
            ),
            ButtonSegment<String>(
              value: 'dulce',
              label: Text('Dulce'),
              icon: Icon(Icons.cake),
            ),
          ],
          selected: {_foodType},
          onSelectionChanged: (Set<String> selection) {
            setState(() {
              _foodType = selection.first;
            });
          },
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ElevatedButton.icon(
          onPressed: _saveRecipe,
          icon: Icon(widget.recipe == null ? Icons.add : Icons.save),
          label: Text(
            widget.recipe == null ? 'Crear Receta' : 'Guardar Cambios',
          ),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
        ),
        const SizedBox(height: 8),
        OutlinedButton.icon(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.cancel),
          label: const Text('Cancelar'),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
        ),
      ],
    );
  }

  void _addIngredient(String ingredient) {
    final cleanIngredient = ingredient.trim().toLowerCase();
    if (cleanIngredient.isNotEmpty &&
        !_selectedIngredients.contains(cleanIngredient)) {
      setState(() {
        _selectedIngredients.add(cleanIngredient);
        _ingredientController.clear();
        _showSuggestions = false;
      });

      // Añadir al conocimiento del sistema
      context.read<IngredientProvider>().learnIngredientsFromRecipe([
        cleanIngredient,
      ]);
    }
  }

  void _addIngredientFromSuggestion(String ingredient) {
    _addIngredient(ingredient);
    _ingredientController.clear();
  }

  void _removeIngredient(String ingredient) {
    setState(() {
      _selectedIngredients.remove(ingredient);
    });
  }

  void _clearAllIngredients() {
    setState(() {
      _selectedIngredients.clear();
    });
  }

  IconData _getDifficultyIcon(int difficulty) {
    if (difficulty <= 3) return Icons.sentiment_very_satisfied;
    if (difficulty <= 6) return Icons.sentiment_neutral;
    return Icons.sentiment_very_dissatisfied;
  }

  Color _getDifficultyColor(int difficulty) {
    if (difficulty <= 3) return Colors.green;
    if (difficulty <= 6) return Colors.orange;
    return Colors.red;
  }

  String _getDifficultyLabel(int difficulty) {
    if (difficulty <= 3) return 'Fácil';
    if (difficulty <= 6) return 'Intermedio';
    return 'Difícil';
  }

  void _saveRecipe() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedIngredients.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Debes añadir al menos un ingrediente'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final recipe = Recipe(
        id: widget.recipe?.id,
        name: _nameController.text.trim(),
        ingredients: _selectedIngredients,
        instructions: _instructionsController.text.trim(),
        difficulty: _difficulty,
        foodType: _foodType,
        createdAt: widget.recipe?.createdAt ?? DateTime.now(),
      );

      final recipeProvider = context.read<RecipeProvider>();

      if (widget.recipe == null) {
        // Crear nueva receta
        await recipeProvider.addRecipe(recipe);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Receta creada exitosamente'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        // Actualizar receta existente
        await recipeProvider.updateRecipe(recipe);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Receta actualizada exitosamente'),
              backgroundColor: Colors.green,
            ),
          );
        }
      }

      // Añadir ingredientes al conocimiento del sistema
      if (mounted) {
        context.read<IngredientProvider>().learnIngredientsFromRecipe(
          _selectedIngredients,
        );
      }

      if (mounted) {
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _confirmDelete() {
    if (widget.recipe == null) return;

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Confirmar eliminación'),
            content: Text(
              '¿Estás seguro de que quieres eliminar "${widget.recipe!.name}"?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.of(context).pop(); // Cerrar diálogo

                  setState(() {
                    _isLoading = true;
                  });

                  // Guardar referencias antes del await
                  final scaffoldMessenger = ScaffoldMessenger.of(context);
                  final navigator = Navigator.of(context);
                  final recipeProvider = context.read<RecipeProvider>();

                  try {
                    await recipeProvider.deleteRecipe(widget.recipe!);

                    if (!mounted) return;

                    scaffoldMessenger.showSnackBar(
                      const SnackBar(
                        content: Text('Receta eliminada exitosamente'),
                        backgroundColor: Colors.green,
                      ),
                    );
                    navigator.pop(); // Volver a la lista
                  } catch (e) {
                    if (!mounted) return;

                    scaffoldMessenger.showSnackBar(
                      SnackBar(
                        content: Text('Error al eliminar: $e'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  } finally {
                    if (mounted) {
                      setState(() {
                        _isLoading = false;
                      });
                    }
                  }
                },
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: const Text('Eliminar'),
              ),
            ],
          ),
    );
  }
}
