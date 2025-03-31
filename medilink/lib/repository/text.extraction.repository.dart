import 'package:medilink/models/api.response.dart';
import 'package:medilink/models/extracted.text.model.dart';
import 'package:medilink/services/text.extraction.service.dart';

class TextExtractionRepository {
  final TextExtractionService _textExtractionService;

  TextExtractionRepository(
      {required TextExtractionService textExtractionService})
      : _textExtractionService = textExtractionService;

  Future<ApiResponse<ExtractedText>> extractTextFromImage(String imageUrl) {
    return _textExtractionService.extractTextFromImage(imageUrl);
  }
}
