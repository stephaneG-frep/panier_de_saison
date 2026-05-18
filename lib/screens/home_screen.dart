import 'package:flutter/material.dart';

import '../data/recipes_data.dart';
import '../data/seasonal_items_data.dart';
import '../models/recipe.dart';
import '../models/seasonal_item.dart';
import '../widgets/daily_idea_card.dart';
import '../widgets/month_selector.dart';
import '../widgets/seasonal_item_card.dart';
import 'all_items_screen.dart';
import 'favorites_screen.dart';
import 'item_detail_screen.dart';
import 'recipe_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
    required this.favoriteItemIds,
    required this.favoriteRecipeIds,
    required this.basketItemIds,
    required this.onToggleItemFavorite,
    required this.onToggleRecipeFavorite,
    required this.onAddItemToShopping,
    required this.onAddRecipeIngredients,
    required this.onToggleBasketItem,
  });

  final Set<String> favoriteItemIds;
  final Set<String> favoriteRecipeIds;
  final Set<String> basketItemIds;
  final Future<void> Function(String id) onToggleItemFavorite;
  final Future<void> Function(String id) onToggleRecipeFavorite;
  final Future<bool> Function(SeasonalItem item) onAddItemToShopping;
  final Future<bool> Function(Recipe recipe) onAddRecipeIngredients;
  final Future<void> Function(String id) onToggleBasketItem;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var _query = '';
  var _filter = 'Tous';

  int get _month => DateTime.now().month;

  @override
  Widget build(BuildContext context) {
    final monthItems = itemsForMonth(_month).where(_matches).toList();
    final seasonalRecipe = recipes.firstWhere(
      (recipe) => recipe.seasonalItemIds.any(
        (id) => seasonalItemById(id)?.months.contains(_month) ?? false,
      ),
      orElse: () => recipes.first,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Panier de Saison'),
        actions: [
          IconButton(
            tooltip: 'Tous les produits',
            icon: const Icon(Icons.list_alt),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => AllItemsScreen(
                  favoriteItemIds: widget.favoriteItemIds,
                  basketItemIds: widget.basketItemIds,
                  onToggleItemFavorite: widget.onToggleItemFavorite,
                  onAddItemToShopping: widget.onAddItemToShopping,
                  onToggleBasketItem: widget.onToggleBasketItem,
                ),
              ),
            ),
          ),
          IconButton(
            tooltip: 'Favoris',
            icon: const Icon(Icons.favorite),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => FavoritesScreen(
                  favoriteItemIds: widget.favoriteItemIds,
                  favoriteRecipeIds: widget.favoriteRecipeIds,
                  onToggleItemFavorite: widget.onToggleItemFavorite,
                  onToggleRecipeFavorite: widget.onToggleRecipeFavorite,
                  onAddRecipeIngredients: widget.onAddRecipeIngredients,
                  onAddItemToShopping: widget.onAddItemToShopping,
                  onToggleBasketItem: widget.onToggleBasketItem,
                  basketItemIds: widget.basketItemIds,
                ),
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          Text(
            'Bienvenue dans ton panier de saison',
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 4),
          Text(
            'Nous sommes en ${monthNames[_month - 1]} : le bon moment pour cuisiner simple, local et savoureux.',
          ),
          const SizedBox(height: 18),
          DailyIdeaCard(
            recipe: seasonalRecipe,
            onTap: () => _openRecipe(seasonalRecipe),
          ),
          const SizedBox(height: 18),
          Text(
            'Produits de saison ce mois-ci',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 12),
          TextField(
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.search),
              hintText: 'Rechercher un fruit ou un legume',
            ),
            onChanged: (value) => setState(() => _query = value),
          ),
          const SizedBox(height: 12),
          SegmentedButton<String>(
            segments: const [
              ButtonSegment(value: 'Tous', label: Text('Tous')),
              ButtonSegment(value: 'Fruits', label: Text('Fruits')),
              ButtonSegment(value: 'Legumes', label: Text('Legumes')),
              ButtonSegment(
                value: 'Legumes anciens',
                label: Text('Legumes anciens'),
              ),
            ],
            selected: {_filter},
            onSelectionChanged: (value) =>
                setState(() => _filter = value.first),
          ),
          const SizedBox(height: 12),
          if (monthItems.isEmpty)
            const _EmptyState(
              message: 'Aucun produit ne correspond a ta recherche.',
            )
          else
            ...monthItems.map(
              (item) => SeasonalItemCard(
                item: item,
                month: _month,
                isFavorite: widget.favoriteItemIds.contains(item.id),
                onTap: () => _openItem(item),
                onFavorite: () => widget.onToggleItemFavorite(item.id),
              ),
            ),
        ],
      ),
    );
  }

  bool _matches(SeasonalItem item) {
    final typeOk =
        _filter == 'Tous' ||
        (_filter == 'Fruits' && item.type == SeasonalItemType.fruit) ||
        (_filter == 'Legumes' && item.type == SeasonalItemType.legume) ||
        (_filter == 'Legumes anciens' && isAncientVegetable(item));
    final queryOk =
        _query.trim().isEmpty ||
        item.name.toLowerCase().contains(_query.trim().toLowerCase());
    return typeOk && queryOk;
  }

  void _openItem(SeasonalItem item) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ItemDetailScreen(
          item: item,
          month: _month,
          isFavorite: widget.favoriteItemIds.contains(item.id),
          inBasket: widget.basketItemIds.contains(item.id),
          onToggleFavorite: () => widget.onToggleItemFavorite(item.id),
          onAddToShopping: () => widget.onAddItemToShopping(item),
          onToggleBasket: () => widget.onToggleBasketItem(item.id),
        ),
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

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Center(child: Text(message, textAlign: TextAlign.center)),
    );
  }
}
