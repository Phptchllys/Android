import '../entities/macros_entity.dart';

class Macros {
  final int calories;
  final int carbs;
  final int fat;
  final int protein;

  const Macros({
    required this.calories,
    required this.carbs,
    required this.fat,
    required this.protein,
  });

  static Macros fromEntity(MacrosEntity entity) {
    return Macros(
      calories: entity.calories,
      carbs: entity.carbs,
      fat: entity.fat,
      protein: entity.protein,
    );
  }

  MacrosEntity toEntity() {
    return MacrosEntity(
      calories: calories,
      carbs: carbs,
      fat: fat,
      protein: protein,
    );
  }
}
