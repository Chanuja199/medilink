import 'dart:convert';
import 'dart:typed_data';

import 'package:medilink/models/api.response.dart';
import 'package:medilink/models/extracted.text.model.dart';
import 'package:medilink/models/openai.config.dart';
import 'package:medilink/services/openai.client.dart';
import 'package:medilink/services/text.extraction.service.dart';

class OpenAITextExtractionService implements TextExtractionService {
  final ApiClient _apiClient;

  OpenAITextExtractionService({required ApiClient apiClient})
      : _apiClient = apiClient;

  @override
  Future<ApiResponse<ExtractedText>> extractTextFromImage(
      String imageUrl) async {
    // First download the image
    final imageResponse = await _apiClient.downloadImage(imageUrl);

    if (!imageResponse.success || imageResponse.data == null) {
      return ApiResponse<ExtractedText>(
        success: false,
        message: 'Failed to download image: ${imageResponse.message}',
      );
    }

    // Convert image to base64
    final Uint8List imageBytes = imageResponse.data!;
    final String base64Image = base64Encode(imageBytes);

    // Determine MIME type (simplified version - you might need a more robust solution)
    String mimeType = 'image/jpeg';
    if (imageUrl.toLowerCase().endsWith('.png')) {
      mimeType = 'image/png';
    } else if (imageUrl.toLowerCase().endsWith('.gif')) {
      mimeType = 'image/gif';
    }

    // Create data URI
    final String dataUri = 'data:$mimeType;base64,$base64Image';

    // Prepare the API call to OpenAI
    final endpoint = '${OpenAIConfig.baseUrl}/chat/completions';

    final body = {
      'model': OpenAIConfig.gpt4VisionModel,
      'messages': [
        {
          'role': 'user',
          'content': [
            {
              'type': 'text',
              'text':
                  'Extract all text from this image. Only return the text you see in the image, nothing else.'
            },
            {
              'type': 'image_url',
              'image_url': {
                'url': dataUri,
              },
            },
          ],
        },
      ],
      'max_tokens': 300,
    };

    final response = await _apiClient.post(
      endpoint: endpoint,
      body: body,
      fromJson: (json) {
        final content = json['choices'][0]['message']['content'] as String;
        return ExtractedText(text: content.trim());
      },
    );

    return response;
  }
}
