class OutfitActiveFilters {
  Set<String> styleTags = {};
  Set<String> weatherTags = {};
  Set<String> seasons = {};

  bool get hasAny =>
      styleTags.isNotEmpty || weatherTags.isNotEmpty || seasons.isNotEmpty;

  int get count => styleTags.length + weatherTags.length + seasons.length;

  void clear() {
    styleTags = {};
    weatherTags = {};
    seasons = {};
  }
}
