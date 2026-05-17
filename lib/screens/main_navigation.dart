import 'package:flutter/material.dart';

import '../models/recipe.dart';
import '../models/seasonal_item.dart';
import '../services/local_storage_service.dart';
import 'calendar_screen.dart';
import 'home_screen.dart';
import 'recipes_screen.dart';
import 'shopping_list_screen.dart';
import 'smart_basket_screen.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  final _storage = LocalStorageService();
  var _index = 0;
  var _favoriteItems = <String>{};
  var _favoriteRecipes = <String>{};
  var _smartBasket = <String>{};
  var _shoppingList = <ShoppingEntry>[];
  var _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final values = await Future.wait([
      _storage.loadFavoriteItems(),
      _storage.loadFavoriteRecipes(),
      _storage.loadSmartBasket(),
      _storage.loadShoppingList(),
    ]);
    if (!mounted) return;
    setState(() {
      _favoriteItems = values[0] as Set<String>;
      _favoriteRecipes = values[1] as Set<String>;
      _smartBasket = values[2] as Set<String>;
      _shoppingList = values[3] as List<ShoppingEntry>;
      _loading = false;
    });
  }

  Future<void> _toggleItemFavorite(String id) async {
    setState(
      () => _favoriteItems.contains(id)
          ? _favoriteItems.remove(id)
          : _favoriteItems.add(id),
    );
    await _storage.saveFavoriteItems(_favoriteItems);
  }

  Future<void> _toggleRecipeFavorite(String id) async {
    setState(
      () => _favoriteRecipes.contains(id)
          ? _favoriteRecipes.remove(id)
          : _favoriteRecipes.add(id),
    );
    await _storage.saveFavoriteRecipes(_favoriteRecipes);
  }

  Future<void> _toggleBasketItem(String id) async {
    setState(
      () => _smartBasket.contains(id)
          ? _smartBasket.remove(id)
          : _smartBasket.add(id),
    );
    await _storage.saveSmartBasket(_smartBasket);
  }

  Future<void> _addItemToShopping(SeasonalItem item) async {
    await _addShoppingEntries([
      ShoppingEntry(
        id: item.id,
        name: item.name,
        category: item.type == SeasonalItemType.fruit ? 'fruits' : 'legumes',
      ),
    ]);
  }

  Future<void> _addRecipeIngredients(Recipe recipe) async {
    await _addShoppingEntries(
      recipe.ingredients.map((name) {
        return ShoppingEntry(
          id: 'ingredient_${name.toLowerCase().replaceAll(' ', '_')}',
          name: name,
          category: _ingredientCategory(name),
        );
      }).toList(),
    );
  }

  Future<void> _addShoppingEntries(List<ShoppingEntry> entries) async {
    final currentIds = _shoppingList
        .map((entry) => entry.id.toLowerCase())
        .toSet();
    final additions = entries
        .where((entry) => !currentIds.contains(entry.id.toLowerCase()))
        .toList();
    if (additions.isEmpty) return;
    setState(() => _shoppingList = [..._shoppingList, ...additions]);
    await _storage.saveShoppingList(_shoppingList);
  }

  Future<void> _updateShoppingList(List<ShoppingEntry> entries) async {
    setState(() => _shoppingList = entries);
    await _storage.saveShoppingList(entries);
  }

  String _ingredientCategory(String raw) {
    final value = raw.toLowerCase();
    const frais = [
      'creme',
      'lait',
      'oeuf',
      'oeufs',
      'fromage',
      'beurre',
      'feta',
      'bechamel',
    ];
    const epicerie = [
      'huile',
      'vinaigre',
      'farine',
      'sucre',
      'chocolat',
      'riz',
      'miel',
      'bouillon',
      'pate',
      'cannelle',
      'cumin',
      'paprika',
      'muscade',
    ];
    if (frais.any(value.contains)) return 'frais';
    if (epicerie.any(value.contains)) return 'epicerie';
    return 'autres';
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final pages = [
      HomeScreen(
        favoriteItemIds: _favoriteItems,
        favoriteRecipeIds: _favoriteRecipes,
        basketItemIds: _smartBasket,
        onToggleItemFavorite: _toggleItemFavorite,
        onToggleRecipeFavorite: _toggleRecipeFavorite,
        onAddItemToShopping: _addItemToShopping,
        onAddRecipeIngredients: _addRecipeIngredients,
        onToggleBasketItem: _toggleBasketItem,
      ),
      CalendarScreen(
        favoriteItemIds: _favoriteItems,
        basketItemIds: _smartBasket,
        onToggleItemFavorite: _toggleItemFavorite,
        onAddItemToShopping: _addItemToShopping,
        onToggleBasketItem: _toggleBasketItem,
      ),
      RecipesScreen(
        favoriteRecipeIds: _favoriteRecipes,
        onToggleRecipeFavorite: _toggleRecipeFavorite,
        onAddRecipeIngredients: _addRecipeIngredients,
      ),
      SmartBasketScreen(
        basketItemIds: _smartBasket,
        favoriteRecipeIds: _favoriteRecipes,
        onToggleBasketItem: _toggleBasketItem,
        onToggleRecipeFavorite: _toggleRecipeFavorite,
        onAddRecipeIngredients: _addRecipeIngredients,
      ),
      ShoppingListScreen(
        entries: _shoppingList,
        onChanged: _updateShoppingList,
      ),
    ];

    return Scaffold(
      body: pages[_index],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (value) => setState(() => _index = value),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Accueil',
          ),
          NavigationDestination(
            icon: Icon(Icons.calendar_month_outlined),
            selectedIcon: Icon(Icons.calendar_month),
            label: 'Calendrier',
          ),
          NavigationDestination(
            icon: Icon(Icons.restaurant_menu_outlined),
            selectedIcon: Icon(Icons.restaurant_menu),
            label: 'Recettes',
          ),
          NavigationDestination(
            icon: Icon(Icons.shopping_basket_outlined),
            selectedIcon: Icon(Icons.shopping_basket),
            label: 'Panier',
          ),
          NavigationDestination(
            icon: Icon(Icons.checklist_outlined),
            selectedIcon: Icon(Icons.checklist),
            label: 'Courses',
          ),
        ],
      ),
    );
  }
}
