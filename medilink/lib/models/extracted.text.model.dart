// lib/models/extracted_text.dart
class ExtractedText {
  final String text;
  final double confidence;

  ExtractedText({
    required this.text,
    this.confidence = 0.0,
  });

  factory ExtractedText.fromJson(Map<String, dynamic> json) {
    return ExtractedText(
      text: json['text'] ?? '',
      confidence: json['confidence']?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() => {
        'text': text,
        'confidence': confidence,
      };
}
