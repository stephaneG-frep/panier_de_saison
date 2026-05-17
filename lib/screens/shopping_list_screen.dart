import 'package:flutter/material.dart';

import '../services/local_storage_service.dart';

class ShoppingListScreen extends StatelessWidget {
  const ShoppingListScreen({
    super.key,
    required this.entries,
    required this.onChanged,
  });

  final List<ShoppingEntry> entries;
  final Future<void> Function(List<ShoppingEntry> entries) onChanged;

  static const _order = ['fruits', 'legumes', 'frais', 'epicerie', 'autres'];

  @override
  Widget build(BuildContext context) {
    final grouped = <String, List<ShoppingEntry>>{
      for (final key in _order)
        key: entries.where((entry) => entry.category == key).toList(),
    };

    return Scaffold(
      appBar: AppBar(
        title: const Text('Courses'),
        actions: [
          IconButton(
            tooltip: 'Vider la liste',
            onPressed: entries.isEmpty
                ? null
                : () => onChanged(<ShoppingEntry>[]),
            icon: const Icon(Icons.delete_sweep_outlined),
          ),
        ],
      ),
      body: entries.isEmpty
          ? const Center(
              child: Text(
                'Ta liste est vide. Ajoute un produit ou les ingredients d une recette.',
              ),
            )
          : ListView(
              padding: const EdgeInsets.all(18),
              children: [
                for (final category in _order)
                  if (grouped[category]!.isNotEmpty) ...[
                    Padding(
                      padding: const EdgeInsets.only(top: 12, bottom: 6),
                      child: Text(
                        _label(category),
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w900),
                      ),
                    ),
                    ...grouped[category]!.map(
                      (entry) => Card(
                        child: CheckboxListTile(
                          value: entry.checked,
                          title: Text(entry.name),
                          secondary: IconButton(
                            tooltip: 'Supprimer',
                            icon: const Icon(Icons.close),
                            onPressed: () => onChanged(
                              entries
                                  .where((item) => item.id != entry.id)
                                  .toList(),
                            ),
                          ),
                          onChanged: (value) => onChanged(
                            entries
                                .map(
                                  (item) => item.id == entry.id
                                      ? item.copyWith(checked: value ?? false)
                                      : item,
                                )
                                .toList(),
                          ),
                        ),
                      ),
                    ),
                  ],
              ],
            ),
    );
  }

  String _label(String category) {
    switch (category) {
      case 'fruits':
        return 'Fruits';
      case 'legumes':
        return 'Legumes';
      case 'frais':
        return 'Frais';
      case 'epicerie':
        return 'Epicerie';
      default:
        return 'Autres';
    }
  }
}
