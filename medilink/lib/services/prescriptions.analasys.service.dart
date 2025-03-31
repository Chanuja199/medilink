import 'dart:convert';

import 'package:medilink/models/api.response.dart';
import 'package:medilink/models/medicine.model.dart';
import 'package:medilink/models/openai.config.dart';
import 'package:medilink/services/openai.client.dart';

class PrescriptionAnalysisService {
  final ApiClient _apiClient;

  PrescriptionAnalysisService({required ApiClient apiClient})
      : _apiClient = apiClient;

  Future<ApiResponse<Map<String, dynamic>>> analyzePrescription(
      String prescription, List<Medicine> availableMedicines) async {
    // Prepare medicines data for the prompt
    final List<Map<String, dynamic>> medicinesData = availableMedicines
        .map((medicine) => {
              'id': medicine.id,
              'name': medicine.name,
              'description': medicine.description,
              'pharmacyId': medicine.pharmacyId,
              'stock': medicine.stock,
              'price': medicine.price,
            })
        .toList();

    // Prepare the API call to OpenAI
    String endpoint = '${OpenAIConfig.baseUrl}/chat/completions';

    final body = {
      'model': OpenAIConfig.gpt3Model,
      'messages': [
        {
          'role': 'system',
          'content': '''You are a medical prescription analyzer.
          You will be given a prescription and a list of available medicines.
          Analyze the prescription and find matching medicines from the list.
          If any prescribed medicine has 0 stock, suggest alternatives that are available.If stock is not 0, you dont have suggest alternatives.
          Format your response as a valid JSON with the following structure:
          {
            "prescribedMedicines": [
              {
                "medicineId": "id of the medcine",
                "name": "medicine name from prescription",
                "availableAt": [
                  {
                    "pharmacyId": pharmacy id where available,
                    "price": price at this pharmacy,
                    "stock": available stock
                  }
                ],
                "alternatives": [
                  {
                    "name": "alternative medicine name",
                    "reason": "brief reason for suggesting this alternative",
                    "availableAt": [
                      {
                        "pharmacyId": pharmacy id where available,
                        "price": price at this pharmacy,
                        "stock": available stock
                      }
                    ]
                  }
                ]
              }
            ]
          }
          Only include alternatives if the prescribed medicine has 0 stock or is not available.
          Include all pharmacies where each medicine is available.
          Return only the JSON, no explanations or additional text.'''
        },
        {
          'role': 'user',
          'content': '''
          Prescription:
          $prescription
          
          Available Medicines:
          ${jsonEncode(medicinesData)}
          '''
        },
      ],
      'response_format': {"type": "json_object"},
      'max_tokens': 1000,
    };

    final response = await _apiClient.post(
      endpoint: endpoint,
      body: body,
      fromJson: (json) {
        final content = json['choices'][0]['message']['content'] as String;
        return jsonDecode(content) as Map<String, dynamic>;
      },
    );

    return response;
  }
}
