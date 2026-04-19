import '../constants/app_constants.dart';

class ClothingClassification {
  final String? category;
  final String? subcategory;
  final List<String> colors;
  final List<String> seasons;
  final List<String> styleTags;
  final List<String> weatherTags;

  const ClothingClassification({
    this.category,
    this.subcategory,
    this.colors = const [],
    this.seasons = const [],
    this.styleTags = const [],
    this.weatherTags = const [],
  });

  bool get hasAnyValue =>
      category != null ||
      subcategory != null ||
      colors.isNotEmpty ||
      seasons.isNotEmpty ||
      styleTags.isNotEmpty ||
      weatherTags.isNotEmpty;

  factory ClothingClassification.fromJson(Map<String, dynamic> json) {
    final rawCategory = json['category'] as String?;
    final category = AppConstants.categories.contains(rawCategory) ? rawCategory : null;

    final rawSubcategory = json['subcategory'] as String?;
    final validSubcats = category != null ? (AppConstants.subcategories[category] ?? []) : <String>[];
    final subcategory = validSubcats.contains(rawSubcategory) ? rawSubcategory : null;

    final rawColors = json['colors'] ?? json['color'];
    List<String> colors;
    if (rawColors is List) {
      colors = rawColors.whereType<String>()
          .where(AppConstants.colorOptions.contains).toList();
    } else if (rawColors is String && AppConstants.colorOptions.contains(rawColors)) {
      colors = [rawColors];
    } else {
      colors = [];
    }

    List<String> validateList(dynamic raw, List<String> validValues) {
      if (raw is! List) return [];
      return raw.whereType<String>().where(validValues.contains).toList();
    }

    return ClothingClassification(
      category: category,
      subcategory: subcategory,
      colors: colors,
      seasons: validateList(json['seasons'], AppConstants.seasons),
      styleTags: validateList(json['styleTags'], AppConstants.styleTags),
      weatherTags: validateList(json['weatherTags'], AppConstants.weatherTags),
    );
  }
}
