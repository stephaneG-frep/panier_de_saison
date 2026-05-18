import 'package:flutter/material.dart';

import '../data/seasonal_items_data.dart';
import '../models/seasonal_item.dart';
import '../widgets/seasonal_item_card.dart';
import 'item_detail_screen.dart';

class AllItemsScreen extends StatefulWidget {
  const AllItemsScreen({
    super.key,
    required this.favoriteItemIds,
    required this.basketItemIds,
    required this.onToggleItemFavorite,
    required this.onAddItemToShopping,
    required this.onToggleBasketItem,
  });

  final Set<String> favoriteItemIds;
  final Set<String> basketItemIds;
  final Future<void> Function(String id) onToggleItemFavorite;
  final Future<bool> Function(SeasonalItem item) onAddItemToShopping;
  final Future<void> Function(String id) onToggleBasketItem;

  @override
  State<AllItemsScreen> createState() => _AllItemsScreenState();
}

class _AllItemsScreenState extends State<AllItemsScreen> {
  var _query = '';
  var _filter = 'Tous';

  int get _month => DateTime.now().month;

  @override
  Widget build(BuildContext context) {
    final items = seasonalItems.where(_matches).toList()
      ..sort((a, b) => a.name.compareTo(b.name));

    return Scaffold(
      appBar: AppBar(title: const Text('Tous les produits')),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
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
            onSelectionChanged: (value) => setState(() => _filter = value.first),
          ),
          const SizedBox(height: 14),
          Text(
            '${items.length} produits disponibles',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          if (items.isEmpty)
            const Padding(
              padding: EdgeInsets.all(24),
              child: Center(child: Text('Aucun produit ne correspond au filtre.')),
            )
          else
            ...items.map(
              (item) => SeasonalItemCard(
                item: item,
                month: _month,
                isFavorite: widget.favoriteItemIds.contains(item.id),
                onFavorite: () => widget.onToggleItemFavorite(item.id),
                onTap: () => Navigator.of(context).push(
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
                ),
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
}
