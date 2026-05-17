enum RecipeDifficulty { facile, moyen, avance }

class Recipe {
  const Recipe({
    required this.id,
    required this.title,
    required this.emoji,
    required this.durationMinutes,
    required this.difficulty,
    required this.ingredients,
    required this.steps,
    required this.seasonalItemIds,
    required this.tags,
  });

  final String id;
  final String title;
  final String emoji;
  final int durationMinutes;
  final RecipeDifficulty difficulty;
  final List<String> ingredients;
  final List<String> steps;
  final List<String> seasonalItemIds;
  final List<String> tags;

  String get difficultyLabel {
    switch (difficulty) {
      case RecipeDifficulty.facile:
        return 'Facile';
      case RecipeDifficulty.moyen:
        return 'Moyen';
      case RecipeDifficulty.avance:
        return 'Avance';
    }
  }
}
