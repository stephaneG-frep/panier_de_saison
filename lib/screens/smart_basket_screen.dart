import 'package:flutter/material.dart';

import '../data/recipes_data.dart';
import '../data/seasonal_items_data.dart';
import '../models/recipe.dart';
import '../widgets/recipe_card.dart';
import 'recipe_detail_screen.dart';

class SmartBasketScreen extends StatelessWidget {
  const SmartBasketScreen({
    super.key,
    required this.basketItemIds,
    required this.favoriteRecipeIds,
    required this.onToggleBasketItem,
    required this.onToggleRecipeFavorite,
    required this.onAddRecipeIngredients,
  });

  final Set<String> basketItemIds;
  final Set<String> favoriteRecipeIds;
  final Future<void> Function(String id) onToggleBasketItem;
  final Future<void> Function(String id) onToggleRecipeFavorite;
  final Future<bool> Function(Recipe recipe) onAddRecipeIngredients;

  @override
  Widget build(BuildContext context) {
    final basketItems = seasonalItems
        .where((item) => basketItemIds.contains(item.id))
        .toList();
    final matches = recipes.where((recipe) {
      final common = recipe.seasonalItemIds
          .where(basketItemIds.contains)
          .length;
      return common >= 2;
    }).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Panier malin')),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          Text(
            'Ce que tu as deja',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 8),
          if (basketItems.isEmpty)
            const Padding(
              padding: EdgeInsets.all(18),
              child: Text(
                'Ajoute des produits depuis leur fiche pour recevoir des idees de recettes.',
              ),
            )
          else
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: basketItems
                  .map(
                    (item) => InputChip(
                      avatar: Text(item.displayEmoji),
                      label: Text(item.name),
                      onDeleted: () => onToggleBasketItem(item.id),
                    ),
                  )
                  .toList(),
            ),
          const SizedBox(height: 18),
          FilledButton.icon(
            onPressed: basketItemIds.length < 2 ? null : () {},
            icon: const Icon(Icons.auto_awesome),
            label: const Text('Trouver une recette'),
          ),
          const SizedBox(height: 18),
          Text(
            'Suggestions',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 8),
          if (basketItemIds.length < 2)
            const Padding(
              padding: EdgeInsets.all(18),
              child: Text(
                'Deux produits suffisent pour declencher les suggestions.',
              ),
            )
          else if (matches.isEmpty)
            const Padding(
              padding: EdgeInsets.all(18),
              child: Text(
                'Aucune recette ne combine encore deux produits de ton panier.',
              ),
            )
          else
            ...matches.map(
              (recipe) => RecipeCard(
                recipe: recipe,
                isFavorite: favoriteRecipeIds.contains(recipe.id),
                onFavorite: () => onToggleRecipeFavorite(recipe.id),
                onAddIngredients: () => onAddRecipeIngredients(recipe),
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => RecipeDetailScreen(
                      recipe: recipe,
                      isFavorite: favoriteRecipeIds.contains(recipe.id),
                      onToggleFavorite: () => onToggleRecipeFavorite(recipe.id),
                      onAddIngredients: () => onAddRecipeIngredients(recipe),
                    ),
                  ),
                ),
              ),
            ),
          const SizedBox(height: 18),
          Text(
            'Ajouter rapidement',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: seasonalItems
                .where((item) => !basketItemIds.contains(item.id))
                .take(24)
                .map(
                  (item) => ActionChip(
                    avatar: Text(item.displayEmoji),
                    label: Text(item.name),
                    onPressed: () => onToggleBasketItem(item.id),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}
