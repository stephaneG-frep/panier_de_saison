import 'package:flutter/material.dart';

import '../models/seasonal_item.dart';
import '../widgets/month_selector.dart';
import '../widgets/season_score_badge.dart';

class ItemDetailScreen extends StatelessWidget {
  const ItemDetailScreen({
    super.key,
    required this.item,
    required this.month,
    required this.isFavorite,
    required this.inBasket,
    required this.onToggleFavorite,
    required this.onAddToShopping,
    required this.onToggleBasket,
  });

  final SeasonalItem item;
  final int month;
  final bool isFavorite;
  final bool inBasket;
  final VoidCallback onToggleFavorite;
  final VoidCallback onAddToShopping;
  final VoidCallback onToggleBasket;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(item.name)),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Center(child: Text(item.emoji, style: const TextStyle(fontSize: 96))),
          const SizedBox(height: 12),
          Center(
            child: Column(
              children: [
                Text(
                  item.name,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  alignment: WrapAlignment.center,
                  children: [
                    Chip(label: Text(item.typeLabel)),
                    Chip(label: Text(item.category)),
                    SeasonScoreBadge(item: item, month: month),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          _Section(
            title: 'Mois de saison',
            child: Text(item.months.map((m) => monthNames[m - 1]).join(', ')),
          ),
          _Section(title: 'Description', child: Text(item.description)),
          _Section(title: 'Bienfaits', child: Text(item.benefits)),
          _Section(title: 'Conservation', child: Text(item.conservation)),
          _Section(title: 'Preparation', child: Text(item.preparation)),
          _Section(
            title: 'Idees recettes',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: item.recipeIdeas
                  .map((idea) => Text('• $idea'))
                  .toList(),
            ),
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              FilledButton.icon(
                onPressed: onToggleFavorite,
                icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border),
                label: Text(
                  isFavorite ? 'Retirer des favoris' : 'Ajouter aux favoris',
                ),
              ),
              FilledButton.tonalIcon(
                onPressed: onAddToShopping,
                icon: const Icon(Icons.add_shopping_cart),
                label: const Text('Ajouter aux courses'),
              ),
              FilledButton.tonalIcon(
                onPressed: onToggleBasket,
                icon: Icon(
                  inBasket
                      ? Icons.remove_shopping_cart
                      : Icons.shopping_basket_outlined,
                ),
                label: Text(
                  inBasket ? 'Retirer du panier' : 'Ajouter au panier malin',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 8),
              child,
            ],
          ),
        ),
      ),
    );
  }
}
