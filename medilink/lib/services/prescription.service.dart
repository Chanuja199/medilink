import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:medilink/models/prescription.model.dart';

class PrescriptionService {
  static const String baseUrl =
      "http://44.201.186.18:5001/api"; // Use 44.201.186.18 for Android emulator

  // Create a new prescription
  static Future<Prescription> createPrescription(
      Prescription prescription) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/prescriptions'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(prescription.toMap()),
      );

      if (response.statusCode == 201) {
        return Prescription.fromMap(jsonDecode(response.body));
      } else {
        throw Exception('Failed to create prescription: ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to create prescription: $e');
    }
  }

  // Get all prescriptions
  static Future<List<Prescription>> getPrescriptions() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/prescriptions'));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data
            .map((prescription) => Prescription.fromMap(prescription))
            .toList();
      } else {
        throw Exception('Failed to fetch prescriptions: ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to fetch prescriptions: $e');
    }
  }

  // Get a prescription by ID
  static Future<Prescription> getPrescriptionById(int id) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/prescriptions/$id'));

      if (response.statusCode == 200) {
        return Prescription.fromMap(jsonDecode(response.body));
      } else {
        throw Exception('Failed to fetch prescription: ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to fetch prescription: $e');
    }
  }

  // Update a prescription
  static Future<Prescription> updatePrescription(
      int id, Prescription prescription) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/prescriptions/$id'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(prescription.toMap()),
      );

      if (response.statusCode == 200) {
        return Prescription.fromMap(jsonDecode(response.body));
      } else {
        throw Exception('Failed to update prescription: ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to update prescription: $e');
    }
  }

  // Delete a prescription
  static Future<void> deletePrescription(int id) async {
    try {
      final response =
          await http.delete(Uri.parse('$baseUrl/prescriptions/$id'));

      if (response.statusCode != 204) {
        throw Exception('Failed to delete prescription: ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to delete prescription: $e');
    }
  }
}
