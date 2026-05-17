import 'package:flutter/material.dart';

const monthNames = [
  'Janvier',
  'Fevrier',
  'Mars',
  'Avril',
  'Mai',
  'Juin',
  'Juillet',
  'Aout',
  'Septembre',
  'Octobre',
  'Novembre',
  'Decembre',
];

class MonthSelector extends StatelessWidget {
  const MonthSelector({
    super.key,
    required this.selectedMonth,
    required this.onSelected,
  });

  final int selectedMonth;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (var i = 1; i <= 12; i++)
          ChoiceChip(
            selected: selectedMonth == i,
            label: Text(monthNames[i - 1]),
            onSelected: (_) => onSelected(i),
          ),
      ],
    );
  }
}
