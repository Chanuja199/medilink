import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:medilink/models/api.response.dart';
import 'package:medilink/models/openai.config.dart';

abstract class ApiClient {
  Future<ApiResponse<T>> post<T>({
    required String endpoint,
    required Map<String, dynamic> body,
    required T Function(Map<String, dynamic>) fromJson,
  });

  Future<ApiResponse<Uint8List>> downloadImage(String imageUrl);
}

class HttpApiClient implements ApiClient {
  final http.Client _client;

  HttpApiClient({http.Client? client}) : _client = client ?? http.Client();

  @override
  Future<ApiResponse<T>> post<T>({
    required String endpoint,
    required Map<String, dynamic> body,
    required T Function(Map<String, dynamic>) fromJson,
  }) async {
    try {
      final response = await _client.post(
        Uri.parse(endpoint),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${OpenAIConfig.apiKey}',
        },
        body: jsonEncode(body),
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final jsonData = jsonDecode(response.body) as Map<String, dynamic>;
        return ApiResponse<T>(
          success: true,
          message: 'Success',
          data: fromJson(jsonData),
        );
      } else {
        return ApiResponse<T>(
          success: false,
          message: 'Error: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      return ApiResponse<T>(
        success: false,
        message: 'Exception: ${e.toString()}',
      );
    }
  }

  @override
  Future<ApiResponse<Uint8List>> downloadImage(String imageUrl) async {
    try {
      final response = await _client.get(Uri.parse(imageUrl));

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return ApiResponse<Uint8List>(
          success: true,
          message: 'Image downloaded successfully',
          data: response.bodyBytes,
        );
      } else {
        return ApiResponse<Uint8List>(
          success: false,
          message: 'Failed to download image: ${response.statusCode}',
        );
      }
    } catch (e) {
      return ApiResponse<Uint8List>(
        success: false,
        message: 'Exception while downloading image: ${e.toString()}',
      );
    }
  }
}
