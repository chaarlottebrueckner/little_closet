import '../constants/app_constants.dart';

class ClothingClassification {
  final String? category;
  final String? subcategory;
  final String? color;
  final List<String> seasons;
  final List<String> styleTags;
  final List<String> weatherTags;

  const ClothingClassification({
    this.category,
    this.subcategory,
    this.color,
    this.seasons = const [],
    this.styleTags = const [],
    this.weatherTags = const [],
  });

  bool get hasAnyValue =>
      category != null ||
      subcategory != null ||
      color != null ||
      seasons.isNotEmpty ||
      styleTags.isNotEmpty ||
      weatherTags.isNotEmpty;

  factory ClothingClassification.fromJson(Map<String, dynamic> json) {
    final rawCategory = json['category'] as String?;
    final category = AppConstants.categories.contains(rawCategory) ? rawCategory : null;

    final rawSubcategory = json['subcategory'] as String?;
    final validSubcats = category != null ? (AppConstants.subcategories[category] ?? []) : <String>[];
    final subcategory = validSubcats.contains(rawSubcategory) ? rawSubcategory : null;

    final rawColor = json['color'] as String?;
    final color = AppConstants.colorOptions.contains(rawColor) ? rawColor : null;

    List<String> validateList(dynamic raw, List<String> validValues) {
      if (raw is! List) return [];
      return raw.whereType<String>().where(validValues.contains).toList();
    }

    return ClothingClassification(
      category: category,
      subcategory: subcategory,
      color: color,
      seasons: validateList(json['seasons'], AppConstants.seasons),
      styleTags: validateList(json['styleTags'], AppConstants.styleTags),
      weatherTags: validateList(json['weatherTags'], AppConstants.weatherTags),
    );
  }
}
