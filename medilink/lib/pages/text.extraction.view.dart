import 'package:flutter/material.dart';
import 'package:medilink/models/prescription.model.dart';
import 'package:medilink/pages/see.availability.view.dart';
import 'package:medilink/repository/text.extraction.repository.dart';
import 'package:medilink/services/openai.client.dart';
import 'package:medilink/services/openi.text.extraction.service.dart';

class TextExtractionScreen extends StatefulWidget {
  final Prescription prescription;
  const TextExtractionScreen({
    Key? key,
    required this.prescription,
  }) : super(key: key);

  @override
  _TextExtractionScreenState createState() => _TextExtractionScreenState();
}

class _TextExtractionScreenState extends State<TextExtractionScreen> {
  final TextEditingController _urlController = TextEditingController();
  final ApiClient apiClient = HttpApiClient();
  String? _extractedText;
  bool _isLoading = false;
  String? _error;
  OpenAITextExtractionService get textExtractionService =>
      OpenAITextExtractionService(apiClient: apiClient);
  TextExtractionRepository get textExtractionRepository =>
      TextExtractionRepository(textExtractionService: textExtractionService);
  @override
  void initState() {
    super.initState();
    // Default to your local server URL for convenience
    if (widget.prescription.imageUrl != null) {
      _urlController.text =
          'http://44.201.186.18:5001${widget.prescription.imageUrl!}';
    }
    setState(() {
      _extractedText = widget.prescription.text;
    });
  }

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  Future<void> _extractText() async {
    setState(() {
      _isLoading = true;
      _error = null;
      _extractedText = null;
    });

    try {
      final imageUrl = _urlController.text.trim();

      final response =
          await textExtractionRepository.extractTextFromImage(imageUrl);

      setState(() {
        _isLoading = false;
        if (response.success && response.data != null) {
          _extractedText = response.data!.text;
        } else {
          _error = response.message;
        }
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _error = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Image Text Extraction'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (widget.prescription.imageUrl != null)
              SizedBox(
                height: 400,
                child: widget.prescription.imageUrl != null
                    ? Image.network(
                        'http://44.201.186.18:5001${widget.prescription.imageUrl}')
                    : Text(widget.prescription.text!),
              ),
            const SizedBox(height: 8),
            const SizedBox(height: 16),
            if (widget.prescription.imageUrl != null)
              ElevatedButton(
                onPressed: _isLoading ? null : _extractText,
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2.0),
                      )
                    : const Text('Extract Text'),
              ),
            const SizedBox(height: 24),
            if (_extractedText != null) ...[
              const Text(
                "Check Availability of below prescription",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: SingleChildScrollView(
                    child: Text(_extractedText!),
                  ),
                ),
              ),
            ],
            if (_error != null) ...[
              const SizedBox(height: 16),
              Text(
                'Error: $_error',
                style: const TextStyle(color: Colors.red),
              ),
            ],
            if (_extractedText != null)
              const SizedBox(
                height: 10,
              ),
            if (_extractedText != null)
              ElevatedButton(
                onPressed: _isLoading || _extractedText == null
                    ? null
                    : () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SeeAvailabilityView(
                                      prescription: _extractedText!,
                                      prescriptionId: widget.prescription.id!,
                                    )));
                      },
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2.0),
                      )
                    : const Text('See availability'),
              ),
          ],
        ),
      ),
    );
  }
}
