class MacrosEntity {
  int calories;
  int carbs;
  int fat;
  int protein;

  MacrosEntity({
    required this.calories,
    required this.carbs,
    required this.fat,
    required this.protein,
  });

  static MacrosEntity fromDocument(Map<String, dynamic> doc) {
    return MacrosEntity(
      calories: (doc['calories'] as num?)?.toInt() ?? 0,
      carbs: (doc['carbs'] as num?)?.toInt() ?? 0,
      fat: (doc['fat'] as num?)?.toInt() ?? 0,
      protein: (doc['protein'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, Object?> toDocument() {
    return {
      'calories': calories,
      'carbs': carbs,
      'fat': fat,
      'protein': protein,
    };
  }
}
