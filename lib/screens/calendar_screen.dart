import 'package:flutter/material.dart';

import '../data/seasonal_items_data.dart';
import '../models/seasonal_item.dart';
import '../widgets/month_selector.dart';
import '../widgets/seasonal_item_card.dart';
import 'item_detail_screen.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({
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
  final Future<void> Function(SeasonalItem item) onAddItemToShopping;
  final Future<void> Function(String id) onToggleBasketItem;

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  var _selectedMonth = DateTime.now().month;
  var _filter = 'Tous';

  @override
  Widget build(BuildContext context) {
    final items = itemsForMonth(_selectedMonth).where((item) {
      return _filter == 'Tous' ||
          (_filter == 'Fruits' && item.type == SeasonalItemType.fruit) ||
          (_filter == 'Legumes' && item.type == SeasonalItemType.legume);
    }).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Calendrier')),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          Text(
            'Choisis un mois',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 12),
          MonthSelector(
            selectedMonth: _selectedMonth,
            onSelected: (month) => setState(() => _selectedMonth = month),
          ),
          const SizedBox(height: 16),
          SegmentedButton<String>(
            segments: const [
              ButtonSegment(value: 'Tous', label: Text('Tous')),
              ButtonSegment(value: 'Fruits', label: Text('Fruits')),
              ButtonSegment(value: 'Legumes', label: Text('Legumes')),
            ],
            selected: {_filter},
            onSelectionChanged: (value) =>
                setState(() => _filter = value.first),
          ),
          const SizedBox(height: 16),
          Text(
            '${items.length} produits en ${monthNames[_selectedMonth - 1]}',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 8),
          if (items.isEmpty)
            const Padding(
              padding: EdgeInsets.all(24),
              child: Center(child: Text('Aucun produit pour ce filtre.')),
            )
          else
            ...items.map(
              (item) => SeasonalItemCard(
                item: item,
                month: _selectedMonth,
                isFavorite: widget.favoriteItemIds.contains(item.id),
                onFavorite: () => widget.onToggleItemFavorite(item.id),
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => ItemDetailScreen(
                      item: item,
                      month: _selectedMonth,
                      isFavorite: widget.favoriteItemIds.contains(item.id),
                      inBasket: widget.basketItemIds.contains(item.id),
                      onToggleFavorite: () =>
                          widget.onToggleItemFavorite(item.id),
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
}
