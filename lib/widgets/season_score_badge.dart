import 'package:flutter/material.dart';

import '../models/seasonal_item.dart';

class SeasonScoreBadge extends StatelessWidget {
  const SeasonScoreBadge({super.key, required this.item, required this.month});

  final SeasonalItem item;
  final int month;

  @override
  Widget build(BuildContext context) {
    final isPeak = item.peakMonths.contains(month);
    final isSeason = item.months.contains(month);
    final color = isPeak
        ? Colors.green
        : (isSeason ? Colors.orange : Colors.red);
    final label = isPeak
        ? 'Pleine saison'
        : isSeason
        ? 'Debut/fin de saison'
        : 'Hors saison';

    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(99),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: Text(
          label,
          style: TextStyle(color: color.shade700, fontWeight: FontWeight.w800),
        ),
      ),
    );
  }
}
