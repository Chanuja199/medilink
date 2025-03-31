import 'package:medilink/models/api.response.dart';
import 'package:medilink/models/extracted.text.model.dart';

abstract class TextExtractionService {
  Future<ApiResponse<ExtractedText>> extractTextFromImage(String imageUrl);
}
