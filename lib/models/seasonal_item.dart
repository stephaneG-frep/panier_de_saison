enum SeasonalItemType { fruit, legume }

class SeasonalItem {
  const SeasonalItem({
    required this.id,
    required this.name,
    required this.emoji,
    required this.type,
    required this.category,
    required this.months,
    required this.peakMonths,
    required this.description,
    required this.benefits,
    required this.conservation,
    required this.preparation,
    required this.recipeIdeas,
  });

  final String id;
  final String name;
  final String emoji;
  final SeasonalItemType type;
  final String category;
  final List<int> months;
  final List<int> peakMonths;
  final String description;
  final String benefits;
  final String conservation;
  final String preparation;
  final List<String> recipeIdeas;

  String get typeLabel => type == SeasonalItemType.fruit ? 'Fruit' : 'Legume';
}
