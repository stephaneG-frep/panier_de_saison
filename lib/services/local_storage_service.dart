import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class ShoppingEntry {
  const ShoppingEntry({
    required this.id,
    required this.name,
    required this.category,
    this.checked = false,
  });

  final String id;
  final String name;
  final String category;
  final bool checked;

  ShoppingEntry copyWith({bool? checked}) => ShoppingEntry(
    id: id,
    name: name,
    category: category,
    checked: checked ?? this.checked,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'category': category,
    'checked': checked,
  };

  factory ShoppingEntry.fromJson(Map<String, dynamic> json) => ShoppingEntry(
    id: '${json['id']}',
    name: '${json['name']}',
    category: '${json['category']}',
    checked: json['checked'] == true,
  );
}

class LocalStorageService {
  static const _favoriteItemsKey = 'panier_favorite_item_ids';
  static const _favoriteRecipesKey = 'panier_favorite_recipe_ids';
  static const _shoppingListKey = 'panier_shopping_list';
  static const _smartBasketKey = 'panier_smart_basket_ids';
  static const _legacyFavoritesKey = 'favorites_ids';
  static const _bestQuizScoreKey = 'best_quiz_score';
  static const _chatProviderKey = 'chat_provider_key';
  static const _chatConfigsKey = 'chat_provider_configs_json';

  Future<Set<String>> loadFavoriteItems() => _loadStringSet(_favoriteItemsKey);

  Future<void> saveFavoriteItems(Set<String> ids) =>
      _saveStringSet(_favoriteItemsKey, ids);

  Future<Set<String>> loadFavoriteRecipes() =>
      _loadStringSet(_favoriteRecipesKey);

  Future<void> saveFavoriteRecipes(Set<String> ids) =>
      _saveStringSet(_favoriteRecipesKey, ids);

  Future<Set<String>> loadSmartBasket() => _loadStringSet(_smartBasketKey);

  Future<void> saveSmartBasket(Set<String> ids) =>
      _saveStringSet(_smartBasketKey, ids);

  Future<List<ShoppingEntry>> loadShoppingList() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_shoppingListKey) ?? <String>[];
    return raw
        .map((value) {
          try {
            final decoded = jsonDecode(value);
            if (decoded is Map<String, dynamic>) {
              return ShoppingEntry.fromJson(decoded);
            }
          } catch (_) {}
          return null;
        })
        .whereType<ShoppingEntry>()
        .toList();
  }

  Future<void> saveShoppingList(List<ShoppingEntry> entries) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      _shoppingListKey,
      entries.map((entry) => jsonEncode(entry.toJson())).toList(),
    );
  }

  Future<Set<String>> _loadStringSet(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return (prefs.getStringList(key) ?? <String>[]).toSet();
  }

  Future<void> _saveStringSet(String key, Set<String> ids) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(key, ids.toList()..sort());
  }

  // Compatibilite avec quelques anciens ecrans encore presents dans le projet.
  Future<Set<String>> loadFavorites() => _loadStringSet(_legacyFavoritesKey);

  Future<void> saveFavorites(Set<String> ids) =>
      _saveStringSet(_legacyFavoritesKey, ids);

  Future<int> loadBestQuizScore() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_bestQuizScoreKey) ?? 0;
  }

  Future<void> saveBestQuizScore(int score) async {
    final prefs = await SharedPreferences.getInstance();
    final current = prefs.getInt(_bestQuizScoreKey) ?? 0;
    if (score > current) await prefs.setInt(_bestQuizScoreKey, score);
  }

  Future<void> saveChatProvider(String providerName) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_chatProviderKey, providerName);
  }

  Future<String?> loadChatProvider() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_chatProviderKey);
  }

  Future<void> saveChatProviderConfigs(
    Map<String, Map<String, String>> data,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_chatConfigsKey, jsonEncode(data));
  }

  Future<Map<String, Map<String, String>>> loadChatProviderConfigs() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_chatConfigsKey);
    if (raw == null || raw.isEmpty) return <String, Map<String, String>>{};
    try {
      final decoded = jsonDecode(raw);
      if (decoded is! Map) return <String, Map<String, String>>{};
      final result = <String, Map<String, String>>{};
      decoded.forEach((key, value) {
        if (value is Map) {
          result['$key'] = value.map((k, v) => MapEntry('$k', '$v'));
        }
      });
      return result;
    } catch (_) {
      return <String, Map<String, String>>{};
    }
  }
}
