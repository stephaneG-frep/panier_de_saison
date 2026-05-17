import 'package:flutter/material.dart';

import '../models/seasonal_item.dart';
import 'season_score_badge.dart';

class SeasonalItemCard extends StatelessWidget {
  const SeasonalItemCard({
    super.key,
    required this.item,
    required this.month,
    required this.isFavorite,
    required this.onTap,
    required this.onFavorite,
  });

  final SeasonalItem item;
  final int month;
  final bool isFavorite;
  final VoidCallback onTap;
  final VoidCallback onFavorite;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Card(
      color: scheme.surfaceContainerLowest,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Text(item.emoji, style: const TextStyle(fontSize: 42)),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text('${item.typeLabel} • ${item.category}'),
                    const SizedBox(height: 8),
                    SeasonScoreBadge(item: item, month: month),
                  ],
                ),
              ),
              IconButton(
                tooltip: 'Favori',
                onPressed: onFavorite,
                icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border),
                color: isFavorite ? Colors.red : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
