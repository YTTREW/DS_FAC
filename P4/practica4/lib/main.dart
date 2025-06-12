import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'config/theme.dart';
import 'providers/recipe_provider.dart';
import 'providers/ingredient_provider.dart';
import 'screens/recipe_list_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => RecipeProvider()..loadRecipes()),
        ChangeNotifierProvider(create: (_) => IngredientProvider()),
      ],
      child: MaterialApp(
        title: 'Gestor de Recetas',
        theme: AppTheme.lightTheme,
        home: const RecipeListScreen(),
      ),
    );
  }
}
