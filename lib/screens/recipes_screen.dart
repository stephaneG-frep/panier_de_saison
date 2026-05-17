import 'package:flutter/material.dart';

import '../data/recipes_data.dart';
import '../data/seasonal_items_data.dart';
import '../models/recipe.dart';
import '../widgets/recipe_card.dart';
import 'recipe_detail_screen.dart';

class RecipesScreen extends StatefulWidget {
  const RecipesScreen({
    super.key,
    required this.favoriteRecipeIds,
    required this.onToggleRecipeFavorite,
    required this.onAddRecipeIngredients,
  });

  final Set<String> favoriteRecipeIds;
  final Future<void> Function(String id) onToggleRecipeFavorite;
  final Future<void> Function(Recipe recipe) onAddRecipeIngredients;

  @override
  State<RecipesScreen> createState() => _RecipesScreenState();
}

class _RecipesScreenState extends State<RecipesScreen> {
  var _query = '';
  var _selectedTag = 'Tous';
  var _seasonOnly = false;

  @override
  Widget build(BuildContext context) {
    final month = DateTime.now().month;
    final filtered = recipes.where((recipe) {
      final queryOk =
          _query.trim().isEmpty ||
          recipe.title.toLowerCase().contains(_query.trim().toLowerCase());
      final tagOk =
          _selectedTag == 'Tous' || recipe.tags.contains(_selectedTag);
      final seasonOk =
          !_seasonOnly ||
          recipe.seasonalItemIds.any(
            (id) => seasonalItemById(id)?.months.contains(month) ?? false,
          );
      return queryOk && tagOk && seasonOk;
    }).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Recettes')),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          TextField(
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.search),
              hintText: 'Rechercher une recette',
            ),
            onChanged: (value) => setState(() => _query = value),
          ),
          const SizedBox(height: 12),
          SwitchListTile(
            value: _seasonOnly,
            onChanged: (value) => setState(() => _seasonOnly = value),
            title: const Text('Recettes de saison ce mois-ci'),
            contentPadding: EdgeInsets.zero,
          ),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ChoiceChip(
                selected: _selectedTag == 'Tous',
                label: const Text('Tous'),
                onSelected: (_) => setState(() => _selectedTag = 'Tous'),
              ),
              for (final tag in recipeTags)
                ChoiceChip(
                  selected: _selectedTag == tag,
                  label: Text(tag),
                  onSelected: (_) => setState(() => _selectedTag = tag),
                ),
            ],
          ),
          const SizedBox(height: 14),
          if (filtered.isEmpty)
            const Padding(
              padding: EdgeInsets.all(24),
              child: Center(
                child: Text('Aucune recette ne correspond a ces criteres.'),
              ),
            )
          else
            ...filtered.map(
              (recipe) => RecipeCard(
                recipe: recipe,
                isFavorite: widget.favoriteRecipeIds.contains(recipe.id),
                onTap: () => _openRecipe(recipe),
                onFavorite: () => widget.onToggleRecipeFavorite(recipe.id),
                onAddIngredients: () => widget.onAddRecipeIngredients(recipe),
              ),
            ),
        ],
      ),
    );
  }

  void _openRecipe(Recipe recipe) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => RecipeDetailScreen(
          recipe: recipe,
          isFavorite: widget.favoriteRecipeIds.contains(recipe.id),
          onToggleFavorite: () => widget.onToggleRecipeFavorite(recipe.id),
          onAddIngredients: () => widget.onAddRecipeIngredients(recipe),
        ),
      ),
    );
  }
}
