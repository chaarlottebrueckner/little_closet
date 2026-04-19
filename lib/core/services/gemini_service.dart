import 'dart:convert';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../constants/app_constants.dart';
import '../models/clothing_classification.dart';

class GeminiService {
  final Dio _dio;

  GeminiService(this._dio);

  static const _prompt = '''
You are a clothing classification assistant for a wardrobe app.
Analyze the clothing item in this image and respond ONLY with a valid JSON object — no markdown, no explanation.
Use ONLY the exact values listed below. If unsure about a field, omit it (null or empty array).

Category (pick exactly one, or null):
Oberteil, Hose, Rock, Kleid, Jacke / Mantel, Schuhe, Accessoire, Unterwäsche, Sport, Sonstiges

Subcategory (pick exactly one matching the category, or null):
For Oberteil: T-Shirt, Top, Bluse, Hemd, Pullover, Sweatshirt, Crop Top
For Hose: Jeans, Chino, Jogger, Shorts, Leggings, Anzughose
For Rock: Mini, Midi, Maxi, Plissee, Bleistift
For Kleid: Mini, Midi, Maxi, Hemdkleid, Abendkleid
For Jacke / Mantel: Blazer, Jeansjacke, Trenchcoat, Puffer, Lederjacke, Strickjacke
For Schuhe: Sneaker, Pumps, Boots, Sandalen, Loafer, Ballerinas
For Accessoire: Tasche, Gürtel, Schal, Hut, Schmuck, Sonnenbrille
For Unterwäsche: BH, Unterhose, Socken, Strumpfhose
For Sport: Sporttop, Sporthose, Sportjacke, Sport-BH
For Sonstiges: Sonstiges

Color (pick exactly one, or null):
Weiß, Schwarz, Grau, Beige, Braun, Rosa, Rot, Orange, Gelb, Grün, Blau, Lila, Türkis, Gold, Silber, Gemustert, Mehrfarbig
Rules: Use "Gemustert" for any visible pattern (stripes, dots, floral, etc.).
Use "Mehrfarbig" if there are 3+ distinct colors with no dominant one.
Otherwise pick the single most dominant color.

Seasons (conservative — only if highly confident from clear visual cues, else empty array):
Frühling, Sommer, Herbst, Winter, Ganzjährig
Example: a heavy wool coat → Winter. A linen top → Sommer. A plain grey hoodie → omit.

Style tags (suggest 1–3; more only if multiple styles are unambiguously visible):
Casual, Chic, Business, Sport, Party, Romantic, Edgy, Minimalist, Boho, Y2K, Streetwear, Preppy, Grunge
Never guess. Less is more.

DO NOT include weatherTags — omit that field entirely.

Respond with this exact JSON structure:
{"category":"...","subcategory":"...","color":"...","seasons":[...],"styleTags":[...]}
''';

  Future<ClothingClassification?> classifyClothing(XFile imageFile) async {
    final bytes = await imageFile.readAsBytes();
    return _classifyFromBytes(bytes, 'image/jpeg');
  }

  Future<ClothingClassification?> classifyClothingFromBytes(
    Uint8List bytes, {
    String mimeType = 'image/png',
  }) =>
      _classifyFromBytes(bytes, mimeType);

  Future<ClothingClassification?> _classifyFromBytes(
    Uint8List bytes,
    String mimeType,
  ) async {
    try {
      final apiKey = dotenv.env['GEMINI_API_KEY'] ?? '';
      if (apiKey.isEmpty || apiKey == 'YOUR_GEMINI_API_KEY_HERE') return null;

      final base64Image = base64Encode(bytes);

      final response = await _dio.post(
        'https://generativelanguage.googleapis.com/v1beta/models/${AppConstants.geminiModel}:generateContent',
        queryParameters: {'key': apiKey},
        data: {
          'contents': [
            {
              'parts': [
                {
                  'inline_data': {
                    'mime_type': mimeType,
                    'data': base64Image,
                  },
                },
                {'text': _prompt},
              ],
            },
          ],
          'generationConfig': {
            'responseMimeType': 'application/json',
            'temperature': 0.1,
            'maxOutputTokens': 300,
            'thinkingConfig': {'thinkingBudget': 0},
          },
        },
        options: Options(
          sendTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 30),
        ),
      );

      final text = response.data['candidates'][0]['content']['parts'][0]['text'] as String;
      final json = jsonDecode(text) as Map<String, dynamic>;
      final classification = ClothingClassification.fromJson(json);

      final weatherTags = _deriveWeatherTags(classification.category, classification.subcategory);

      return ClothingClassification(
        category: classification.category,
        subcategory: classification.subcategory,
        color: classification.color,
        seasons: classification.seasons,
        styleTags: classification.styleTags,
        weatherTags: weatherTags,
      );
    } catch (_) {
      return null;
    }
  }

  List<String> _deriveWeatherTags(String? category, String? subcategory) {
    return switch (subcategory ?? category) {
      'Puffer'      => ['Schnee', 'Wind', 'Bewölkt'],
      'Trenchcoat'  => ['Regen', 'Wind', 'Bewölkt'],
      'Lederjacke'  => ['Wind', 'Bewölkt'],
      'Strickjacke' => ['Bewölkt', 'Wind'],
      'Blazer'      => ['Sonne', 'Bewölkt'],
      'Jeansjacke'  => ['Bewölkt', 'Wind'],
      'Shorts'      => ['Sonne'],
      'Sandalen'    => ['Sonne'],
      'Ballerinas'  => ['Sonne', 'Bewölkt'],
      'Sneaker'     => ['Sonne', 'Bewölkt'],
      'Pumps'       => ['Sonne', 'Bewölkt'],
      'Loafer'      => ['Sonne', 'Bewölkt'],
      'Boots'       => ['Regen', 'Wind', 'Bewölkt'],
      'Schal'       => ['Wind', 'Schnee', 'Bewölkt'],
      'Hut'         => ['Sonne'],
      _ => [],
    };
  }
}

final geminiServiceProvider = Provider<GeminiService>((ref) {
  return GeminiService(Dio());
});
