class AppConstants {
  AppConstants._();

  static const String appName = 'little closet';

  // Gemini API
  static const String geminiModel = 'gemini-2.5-flash';

  // Image Storage
  static const String imagesDirName = 'little_closet_images';

  // Category options
  static const List<String> categories = [
    'Oberteil',
    'Hose',
    'Rock',
    'Kleid',
    'Jacke / Mantel',
    'Schuhe',
    'Accessoire',
    'Unterwäsche',
    'Sport',
    'Sonstiges',
  ];

  // Subcategories per category
  static const Map<String, List<String>> subcategories = {
    'Oberteil': ['T-Shirt', 'Top', 'Bluse', 'Hemd', 'Pullover', 'Sweatshirt', 'Crop Top'],
    'Hose': ['Jeans', 'Chino', 'Jogger', 'Shorts', 'Leggings', 'Anzughose'],
    'Rock': ['Mini', 'Midi', 'Maxi', 'Plissee', 'Bleistift'],
    'Kleid': ['Mini', 'Midi', 'Maxi', 'Hemdkleid', 'Abendkleid'],
    'Jacke / Mantel': ['Blazer', 'Jeansjacke', 'Trenchcoat', 'Puffer', 'Lederjacke', 'Strickjacke'],
    'Schuhe': ['Sneaker', 'Pumps', 'Boots', 'Sandalen', 'Loafer', 'Ballerinas'],
    'Accessoire': ['Tasche', 'Gürtel', 'Schal', 'Hut', 'Schmuck', 'Sonnenbrille'],
    'Unterwäsche': ['BH', 'Unterhose', 'Socken', 'Strumpfhose'],
    'Sport': ['Sporttop', 'Sporthose', 'Sportjacke', 'Sport-BH'],
    'Sonstiges': ['Sonstiges'],
  };

  // Colors
  static const List<String> colorOptions = [
    'Weiß', 'Schwarz', 'Grau', 'Beige', 'Braun',
    'Rosa', 'Rot', 'Orange', 'Gelb', 'Grün',
    'Blau', 'Lila', 'Türkis', 'Gold', 'Silber',
    'Gemustert', 'Mehrfarbig',
  ];

  // Seasons
  static const List<String> seasons = [
    'Frühling', 'Sommer', 'Herbst', 'Winter', 'Ganzjährig',
  ];

  // Style tags
  static const List<String> styleTags = [
    'Casual', 'Chic', 'Business', 'Sport', 'Party',
    'Romantic', 'Edgy', 'Minimalist', 'Boho', 'Y2K',
    'Streetwear', 'Preppy', 'Grunge',
  ];

  // Weather tags
  static const List<String> weatherTags = [
    'Sonne', 'Bewölkt', 'Regen', 'Schnee', 'Wind',
  ];
}
