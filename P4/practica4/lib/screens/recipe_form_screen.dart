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

  // ✅ Para mostrar ingredientes disponibles del usuario
  bool _showAvailableIngredients = false;

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
    if (text.isNotEmpty && text.length >= 2) {
      // ✅ Mejorar sugerencias combinando ingredientes comunes y disponibles
      final commonSuggestions =
          IngredientProvider.commonIngredients
              .where(
                (ingredient) =>
                    ingredient.toLowerCase().contains(text.toLowerCase()) &&
                    !_selectedIngredients.contains(ingredient.toLowerCase()),
              )
              .take(6)
              .toList();

      final availableSuggestions =
          context
              .read<IngredientProvider>()
              .availableIngredients
              .where(
                (ingredient) =>
                    ingredient.toLowerCase().contains(text.toLowerCase()) &&
                    !_selectedIngredients.contains(ingredient.toLowerCase()),
              )
              .take(4)
              .toList();

      final combinedSuggestions = <String>[];
      combinedSuggestions.addAll(availableSuggestions); // Priorizar disponibles
      combinedSuggestions.addAll(
        commonSuggestions.where((item) => !combinedSuggestions.contains(item)),
      );

      setState(() {
        _ingredientSuggestions = combinedSuggestions.take(8).toList();
        _showSuggestions = _ingredientSuggestions.isNotEmpty;
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
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
        actions: [
          // ✅ Botón para mostrar ingredientes disponibles
          Consumer<IngredientProvider>(
            builder:
                (context, provider, child) => IconButton(
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
                              color: Colors.green,
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
                  onPressed:
                      () => setState(() {
                        _showAvailableIngredients = !_showAvailableIngredients;
                      }),
                  tooltip: 'Mostrar mis ingredientes',
                ),
          ),
          if (widget.recipe != null)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: _confirmDelete,
              color: Colors.red,
              tooltip: 'Eliminar receta',
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
          decoration: InputDecoration(
            hintText: 'Ej: Paella Valenciana',
            prefixIcon: const Icon(Icons.restaurant),
            filled: true,
            fillColor: Theme.of(context).colorScheme.surface,
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
          decoration: InputDecoration(
            hintText: 'Describe paso a paso cómo preparar la receta...',
            prefixIcon: const Icon(Icons.list_alt),
            alignLabelWithHint: true,
            filled: true,
            fillColor: Theme.of(context).colorScheme.surface,
          ),
          maxLines: 5,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Por favor, ingresa las instrucciones';
            }
            if (value.trim().length < 20) {
              return 'Las instrucciones deben ser más detalladas';
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
        Row(
          children: [
            Text(
              'Ingredientes',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            const Spacer(),
            // ✅ Contador de ingredientes
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color:
                    _selectedIngredients.isEmpty
                        ? Theme.of(context).colorScheme.errorContainer
                        : Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${_selectedIngredients.length}',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color:
                      _selectedIngredients.isEmpty
                          ? Theme.of(context).colorScheme.onErrorContainer
                          : Theme.of(context).colorScheme.onPrimaryContainer,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        _buildIngredientInput(),

        // ✅ Mostrar ingredientes disponibles del usuario
        if (_showAvailableIngredients) ...[
          const SizedBox(height: 12),
          _buildAvailableIngredientsSection(),
        ],

        if (_showSuggestions) ...[
          const SizedBox(height: 8),
          _buildIngredientSuggestions(),
        ],
        const SizedBox(height: 12),
        _buildSelectedIngredients(),

        // ✅ Mensaje de error mejorado
        if (_selectedIngredients.isEmpty)
          Container(
            margin: const EdgeInsets.only(top: 8),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(
                context,
              ).colorScheme.errorContainer.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Theme.of(
                  context,
                ).colorScheme.error.withValues(alpha: 0.5),
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
                Expanded(
                  child: Text(
                    'Añade al menos un ingrediente para crear la receta',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  // ✅ Nueva sección para ingredientes disponibles del usuario
  Widget _buildAvailableIngredientsSection() {
    return Consumer<IngredientProvider>(
      builder: (context, provider, child) {
        final availableIngredients =
            provider.availableIngredients
                .where(
                  (ingredient) => !_selectedIngredients.contains(ingredient),
                )
                .toList();

        if (availableIngredients.isEmpty) {
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(
                context,
              ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
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
                    'No tienes ingredientes disponibles. Gestiona tus ingredientes desde el menú principal.',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.green.shade50,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.green.shade200),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.kitchen, color: Colors.green.shade600, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    'Mis ingredientes disponibles (${availableIngredients.length}):',
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Colors.green.shade700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 6,
                runSpacing: 4,
                children:
                    availableIngredients.map((ingredient) {
                      return IngredientChip(
                        ingredient: ingredient,
                        variant: ChipVariant.available,
                        showDelete: false,
                        onTap: () => _addIngredient(ingredient),
                      );
                    }).toList(),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildIngredientInput() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _ingredientController,
            decoration: InputDecoration(
              hintText: 'Buscar o añadir ingrediente...',
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: Theme.of(context).colorScheme.surface,
              suffixIcon:
                  _ingredientController.text.isNotEmpty
                      ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _ingredientController.clear();
                          setState(() {
                            _showSuggestions = false;
                          });
                        },
                      )
                      : null,
            ),
            textCapitalization: TextCapitalization.words,
            onSubmitted: _addIngredient,
          ),
        ),
        const SizedBox(width: 8),
        IconButton.filled(
          onPressed:
              _ingredientController.text.trim().isNotEmpty
                  ? () => _addIngredient(_ingredientController.text)
                  : null,
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
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Column(
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
                'Sugerencias:',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 6,
            runSpacing: 4,
            children:
                _ingredientSuggestions.map((suggestion) {
                  final isAvailable = context
                      .read<IngredientProvider>()
                      .hasIngredient(suggestion);

                  return IngredientChip(
                    ingredient: suggestion,
                    variant:
                        isAvailable
                            ? ChipVariant.available
                            : ChipVariant.suggestion,
                    showDelete: false,
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

    final availableProvider = context.watch<IngredientProvider>();
    final availableIngredients =
        _selectedIngredients
            .where((ingredient) => availableProvider.hasIngredient(ingredient))
            .toList();
    final missingIngredients =
        _selectedIngredients
            .where((ingredient) => !availableProvider.hasIngredient(ingredient))
            .toList();

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
              Icon(
                Icons.shopping_basket,
                size: 16,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: 4),
              Text(
                'Ingredientes de la receta (${_selectedIngredients.length})',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.primary,
                ),
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

          if (availableIngredients.isNotEmpty) ...[
            Row(
              children: [
                Icon(
                  Icons.check_circle,
                  size: 14,
                  color: Colors.green.shade600,
                ),
                const SizedBox(width: 4),
                Text(
                  'Disponibles (${availableIngredients.length}):',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: Colors.green.shade700,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Wrap(
              spacing: 6,
              runSpacing: 4,
              children:
                  availableIngredients.map((ingredient) {
                    return IngredientChip(
                      ingredient: ingredient,
                      variant: ChipVariant.available,
                      onDeleted: () => _removeIngredient(ingredient),
                    );
                  }).toList(),
            ),
            if (missingIngredients.isNotEmpty) const SizedBox(height: 8),
          ],

          if (missingIngredients.isNotEmpty) ...[
            Row(
              children: [
                Icon(
                  Icons.shopping_cart,
                  size: 14,
                  color: Colors.orange.shade600,
                ),
                const SizedBox(width: 4),
                Text(
                  'Por comprar (${missingIngredients.length}):',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: Colors.orange.shade700,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Wrap(
              spacing: 6,
              runSpacing: 4,
              children:
                  missingIngredients.map((ingredient) {
                    return IngredientChip(
                      ingredient: ingredient,
                      variant: ChipVariant.missing,
                      onDeleted: () => _removeIngredient(ingredient),
                    );
                  }).toList(),
            ),
          ],
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
                    size: 24,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _getDifficultyLabel(_difficulty),
                          style: Theme.of(
                            context,
                          ).textTheme.titleSmall?.copyWith(
                            color: _getDifficultyColor(_difficulty),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          _getDifficultyDescription(_difficulty),
                          style: Theme.of(
                            context,
                          ).textTheme.bodySmall?.copyWith(
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: _getDifficultyColor(
                        _difficulty,
                      ).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: _getDifficultyColor(
                          _difficulty,
                        ).withValues(alpha: 0.3),
                      ),
                    ),
                    child: Text(
                      '$_difficulty/10',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: _getDifficultyColor(_difficulty),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Slider(
                value: _difficulty.toDouble(),
                min: 1,
                max: 10,
                divisions: 9,
                label: '$_difficulty - ${_getDifficultyLabel(_difficulty)}',
                onChanged: (value) {
                  setState(() {
                    _difficulty = value.round();
                  });
                },
                activeColor: _getDifficultyColor(_difficulty),
                inactiveColor: _getDifficultyColor(
                  _difficulty,
                ).withValues(alpha: 0.3),
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
          style: SegmentedButton.styleFrom(
            selectedBackgroundColor:
                Theme.of(context).colorScheme.primaryContainer,
            selectedForegroundColor:
                Theme.of(context).colorScheme.onPrimaryContainer,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ElevatedButton.icon(
          onPressed: _selectedIngredients.isNotEmpty ? _saveRecipe : null,
          icon: Icon(widget.recipe == null ? Icons.add : Icons.save),
          label: Text(
            widget.recipe == null ? 'Crear Receta' : 'Guardar Cambios',
          ),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroundColor: Theme.of(context).colorScheme.onPrimary,
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

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.white),
              const SizedBox(width: 8),
              Text('${_formatIngredientName(cleanIngredient)} añadido'),
            ],
          ),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 1),
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
        ),
      );
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
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Limpiar ingredientes'),
            content: const Text(
              '¿Estás seguro de que quieres eliminar todos los ingredientes?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancelar'),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _selectedIngredients.clear();
                  });
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.error,
                  foregroundColor: Theme.of(context).colorScheme.onError,
                ),
                child: const Text('Limpiar'),
              ),
            ],
          ),
    );
  }

  IconData _getDifficultyIcon(int difficulty) {
    if (difficulty <= 2) return Icons.sentiment_very_satisfied;
    if (difficulty <= 4) return Icons.sentiment_satisfied;
    if (difficulty <= 6) return Icons.sentiment_neutral;
    if (difficulty <= 8) return Icons.sentiment_dissatisfied;
    return Icons.sentiment_very_dissatisfied;
  }

  Color _getDifficultyColor(int difficulty) {
    if (difficulty <= 3) return Colors.green;
    if (difficulty <= 6) return Colors.orange;
    if (difficulty <= 8) return Colors.red;
    return Colors.red.shade700;
  }

  String _getDifficultyLabel(int difficulty) {
    if (difficulty <= 2) return 'Muy Fácil';
    if (difficulty <= 4) return 'Fácil';
    if (difficulty <= 6) return 'Intermedio';
    if (difficulty <= 8) return 'Difícil';
    return 'Muy Difícil';
  }

  String _getDifficultyDescription(int difficulty) {
    if (difficulty <= 2) return 'Perfecto para principiantes';
    if (difficulty <= 4) return 'Requiere conocimientos básicos';
    if (difficulty <= 6) return 'Necesita experiencia previa';
    if (difficulty <= 8) return 'Para cocineros experimentados';
    return 'Solo para expertos';
  }

  String _formatIngredientName(String ingredient) {
    if (ingredient.isEmpty) return ingredient;
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

  void _saveRecipe() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedIngredients.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.warning, color: Colors.white),
              SizedBox(width: 8),
              Text('Debes añadir al menos un ingrediente'),
            ],
          ),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
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
      bool success = false;

      if (widget.recipe == null) {
        success = await recipeProvider.addRecipe(recipe);
        if (mounted && success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.white),
                  SizedBox(width: 8),
                  Text('Receta creada exitosamente'),
                ],
              ),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      } else {
        success = await recipeProvider.updateRecipe(recipe);
        if (mounted && success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.white),
                  SizedBox(width: 8),
                  Text('Receta actualizada exitosamente'),
                ],
              ),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }

      if (mounted && success) {
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error, color: Colors.white),
                const SizedBox(width: 8),
                Expanded(child: Text('Error: $e')),
              ],
            ),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.all(16),
          ),
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
              ElevatedButton(
                onPressed: () async {
                  Navigator.of(context).pop(); // Cerrar diálogo

                  setState(() {
                    _isLoading = true;
                  });

                  final scaffoldMessenger = ScaffoldMessenger.of(context);
                  final navigator = Navigator.of(context);
                  final recipeProvider = context.read<RecipeProvider>();

                  try {
                    final success = await recipeProvider.deleteRecipe(
                      widget.recipe!,
                    );

                    if (!mounted) return;

                    if (success) {
                      scaffoldMessenger.showSnackBar(
                        const SnackBar(
                          content: Row(
                            children: [
                              Icon(Icons.check_circle, color: Colors.white),
                              SizedBox(width: 8),
                              Text('Receta eliminada exitosamente'),
                            ],
                          ),
                          backgroundColor: Colors.green,
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                      navigator.pop(); // Volver a la lista
                    }
                  } catch (e) {
                    if (!mounted) return;

                    scaffoldMessenger.showSnackBar(
                      SnackBar(
                        content: Row(
                          children: [
                            const Icon(Icons.error, color: Colors.white),
                            const SizedBox(width: 8),
                            Expanded(child: Text('Error al eliminar: $e')),
                          ],
                        ),
                        backgroundColor: Colors.red,
                        behavior: SnackBarBehavior.floating,
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
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Eliminar'),
              ),
            ],
          ),
    );
  }
}
