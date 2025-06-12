import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/ingredient_provider.dart';
import '../widgets/ingredient_chip.dart';

class IngredientManagementScreen extends StatefulWidget {
  const IngredientManagementScreen({super.key});

  @override
  State<IngredientManagementScreen> createState() =>
      _IngredientManagementScreenState();
}

class _IngredientManagementScreenState
    extends State<IngredientManagementScreen> {
  final TextEditingController _controller = TextEditingController();
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Ingredientes'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        actions: [
          Consumer<IngredientProvider>(
            builder:
                (context, provider, child) => IconButton(
                  onPressed:
                      provider.availableIngredients.isNotEmpty
                          ? () => _showClearDialog(context)
                          : null,
                  icon: const Icon(Icons.clear_all),
                  tooltip: 'Limpiar todos',
                ),
          ),
        ],
      ),
      body: Consumer<IngredientProvider>(
        builder:
            (context, provider, child) => Column(
              children: [
                _buildHeader(provider),
                _buildSearchBar(),
                _buildSelectedIngredients(provider),
                _buildAvailableIngredients(provider),
              ],
            ),
      ),
    );
  }

  Widget _buildHeader(IngredientProvider provider) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: Row(
        children: [
          Icon(Icons.kitchen, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 8),
          Text(
            'Ingredientes disponibles: ${provider.ingredientCount}',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: TextField(
        controller: _controller,
        decoration: InputDecoration(
          labelText: 'Buscar o añadir ingrediente',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: IconButton(
            onPressed: () => _addCustomIngredient(),
            icon: const Icon(Icons.add),
            tooltip: 'Añadir ingrediente personalizado',
          ),
          border: const OutlineInputBorder(),
        ),
        onChanged: (value) {
          setState(() {
            _searchQuery = value.toLowerCase();
          });
        },
        onSubmitted: (value) => _addCustomIngredient(),
      ),
    );
  }

  Widget _buildSelectedIngredients(IngredientProvider provider) {
    if (provider.availableIngredients.isEmpty) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
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
                'No tienes ingredientes seleccionados. Añade algunos de la lista de abajo.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tus ingredientes:',
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children:
                provider.availableIngredients
                    .map(
                      (ingredient) => IngredientChip(
                        ingredient: ingredient,
                        isSelected: true,
                        onTap: () => provider.removeIngredient(ingredient),
                      ),
                    )
                    .toList(),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildAvailableIngredients(IngredientProvider provider) {
    final filteredIngredients =
        IngredientProvider.commonIngredients
            .where(
              (ingredient) =>
                  ingredient.toLowerCase().contains(_searchQuery) &&
                  !provider.hasIngredient(ingredient),
            )
            .toList();

    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Ingredientes disponibles:',
              style: Theme.of(
                context,
              ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children:
                      filteredIngredients
                          .map(
                            (ingredient) => IngredientChip(
                              ingredient: ingredient,
                              isSelected: false,
                              onTap: () => provider.addIngredient(ingredient),
                            ),
                          )
                          .toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _addCustomIngredient() {
    final ingredient = _controller.text.trim();
    if (ingredient.isNotEmpty) {
      context.read<IngredientProvider>().addIngredient(ingredient);
      _controller.clear();
      setState(() {
        _searchQuery = '';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Ingrediente "$ingredient" añadido'),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  void _showClearDialog(BuildContext context) {
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
                  context.read<IngredientProvider>().clearAllIngredients();
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

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
