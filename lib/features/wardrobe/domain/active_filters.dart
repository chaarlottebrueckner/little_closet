class ActiveFilters {
  Set<String> categories = {};
  Set<String> seasons = {};
  Set<String> colors = {};
  Set<String> styleTags = {};
  Set<String> weatherTags = {};

  bool get hasAny =>
      categories.isNotEmpty ||
      seasons.isNotEmpty ||
      colors.isNotEmpty ||
      styleTags.isNotEmpty ||
      weatherTags.isNotEmpty;

  int get count =>
      categories.length +
      seasons.length +
      colors.length +
      styleTags.length +
      weatherTags.length;

  void clear() {
    categories = {};
    seasons = {};
    colors = {};
    styleTags = {};
    weatherTags = {};
  }
}
