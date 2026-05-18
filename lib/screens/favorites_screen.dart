import 'package:flutter/material.dart';

import '../data/recipes_data.dart';
import '../data/seasonal_items_data.dart';
import '../models/recipe.dart';
import '../models/seasonal_item.dart';
import '../widgets/recipe_card.dart';
import '../widgets/seasonal_item_card.dart';
import 'item_detail_screen.dart';
import 'recipe_detail_screen.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({
    super.key,
    required this.favoriteItemIds,
    required this.favoriteRecipeIds,
    required this.basketItemIds,
    required this.onToggleItemFavorite,
    required this.onToggleRecipeFavorite,
    required this.onAddRecipeIngredients,
    required this.onAddItemToShopping,
    required this.onToggleBasketItem,
  });

  final Set<String> favoriteItemIds;
  final Set<String> favoriteRecipeIds;
  final Set<String> basketItemIds;
  final Future<void> Function(String id) onToggleItemFavorite;
  final Future<void> Function(String id) onToggleRecipeFavorite;
  final Future<bool> Function(Recipe recipe) onAddRecipeIngredients;
  final Future<bool> Function(SeasonalItem item) onAddItemToShopping;
  final Future<void> Function(String id) onToggleBasketItem;

  @override
  Widget build(BuildContext context) {
    final month = DateTime.now().month;
    final items = seasonalItems
        .where((item) => favoriteItemIds.contains(item.id))
        .toList();
    final favRecipes = recipes
        .where((recipe) => favoriteRecipeIds.contains(recipe.id))
        .toList();
    return Scaffold(
      appBar: AppBar(title: const Text('Favoris')),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          Text(
            'Produits favoris',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 8),
          if (items.isEmpty)
            const _Empty(message: 'Aucun produit favori pour le moment.')
          else
            ...items.map(
              (item) => SeasonalItemCard(
                item: item,
                month: month,
                isFavorite: true,
                onFavorite: () => onToggleItemFavorite(item.id),
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => ItemDetailScreen(
                      item: item,
                      month: month,
                      isFavorite: true,
                      inBasket: basketItemIds.contains(item.id),
                      onToggleFavorite: () => onToggleItemFavorite(item.id),
                      onAddToShopping: () => onAddItemToShopping(item),
                      onToggleBasket: () => onToggleBasketItem(item.id),
                    ),
                  ),
                ),
              ),
            ),
          const SizedBox(height: 18),
          Text(
            'Recettes favorites',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 8),
          if (favRecipes.isEmpty)
            const _Empty(message: 'Aucune recette favorite pour le moment.')
          else
            ...favRecipes.map(
              (recipe) => RecipeCard(
                recipe: recipe,
                isFavorite: true,
                onFavorite: () => onToggleRecipeFavorite(recipe.id),
                onAddIngredients: () => onAddRecipeIngredients(recipe),
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => RecipeDetailScreen(
                      recipe: recipe,
                      isFavorite: true,
                      onToggleFavorite: () => onToggleRecipeFavorite(recipe.id),
                      onAddIngredients: () => onAddRecipeIngredients(recipe),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _Empty extends StatelessWidget {
  const _Empty({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(18),
      child: Text(message, textAlign: TextAlign.center),
    );
  }
}
