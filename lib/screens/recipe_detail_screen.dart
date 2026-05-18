import 'package:flutter/material.dart';

import '../app.dart';
import '../data/seasonal_items_data.dart';
import '../models/recipe.dart';
import '../models/seasonal_item.dart';

class RecipeDetailScreen extends StatelessWidget {
  const RecipeDetailScreen({
    super.key,
    required this.recipe,
    required this.isFavorite,
    required this.onToggleFavorite,
    required this.onAddIngredients,
  });

  final Recipe recipe;
  final bool isFavorite;
  final VoidCallback onToggleFavorite;
  final Future<bool> Function() onAddIngredients;

  @override
  Widget build(BuildContext context) {
    final items = recipe.seasonalItemIds
        .map(seasonalItemById)
        .whereType<SeasonalItem>()
        .toList();
    return Scaffold(
      appBar: AppBar(title: Text(recipe.title)),
      floatingActionButton: ValueListenableBuilder<ThemeMode>(
        valueListenable: ThemeController.mode,
        builder: (context, themeMode, _) => FloatingActionButton(
          tooltip: themeMode == ThemeMode.dark
              ? 'Passer en mode clair'
              : 'Passer en mode sombre',
          onPressed: ThemeController.toggle,
          child: Icon(
            themeMode == ThemeMode.dark
                ? Icons.light_mode_outlined
                : Icons.dark_mode_outlined,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Center(
            child: Text(recipe.emoji, style: const TextStyle(fontSize: 92)),
          ),
          const SizedBox(height: 12),
          Text(
            recipe.title,
            textAlign: TextAlign.center,
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            alignment: WrapAlignment.center,
            children: [
              Chip(
                avatar: const Icon(Icons.timer),
                label: Text('${recipe.durationMinutes} min'),
              ),
              Chip(
                avatar: const Icon(Icons.signal_cellular_alt),
                label: Text(recipe.difficultyLabel),
              ),
              for (final tag in recipe.tags) Chip(label: Text(tag)),
            ],
          ),
          const SizedBox(height: 16),
          _Block(
            title: 'Ingredients',
            children: recipe.ingredients.map((e) => Text('• $e')).toList(),
          ),
          _Block(
            title: 'Etapes',
            children: [
              for (var i = 0; i < recipe.steps.length; i++)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text('${i + 1}. ${recipe.steps[i]}'),
                ),
            ],
          ),
          _Block(
            title: 'Produits de saison utilises',
            children: [
              Wrap(
                spacing: 8,
                children: items
                    .map(
                      (item) => Chip(label: Text('${item.displayEmoji} ${item.name}')),
                    )
                    .toList(),
              ),
            ],
          ),
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
                onPressed: () async {
                  final added = await onAddIngredients();
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        added
                            ? 'Ingredients ajoutes aux courses.'
                            : 'Ingredients deja presents dans la liste.',
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.add_shopping_cart),
                label: const Text('Ajouter les ingredients'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Block extends StatelessWidget {
  const _Block({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Card(
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
            const SizedBox(height: 10),
            ...children,
          ],
        ),
      ),
    );
  }
}
