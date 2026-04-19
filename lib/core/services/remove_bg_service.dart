import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RemoveBgService {
  final Dio _dio;
  RemoveBgService(this._dio);

  Future<Uint8List?> removeBackground(Uint8List imageBytes) async {
    try {
      final apiKey = dotenv.env['REMOVE_BG_API_KEY'] ?? '';
      if (apiKey.isEmpty || apiKey == 'YOUR_REMOVE_BG_KEY_HERE') return null;

      final response = await _dio.post(
        'https://api.remove.bg/v1.0/removebg',
        data: FormData.fromMap({
          'image_file': MultipartFile.fromBytes(imageBytes, filename: 'image.jpg'),
          'size': 'auto',
        }),
        options: Options(
          headers: {'X-Api-Key': apiKey},
          responseType: ResponseType.bytes,
          validateStatus: (s) => s != null && s < 500,
          sendTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 30),
        ),
      );

      if (response.statusCode == 200) {
        return Uint8List.fromList(response.data as List<int>);
      }
      return null;
    } catch (_) {
      return null;
    }
  }
}

final removeBgServiceProvider = Provider<RemoveBgService>(
  (ref) => RemoveBgService(Dio()),
);
