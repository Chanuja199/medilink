import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:medilink/models/medicine.model.dart';

class MedicineService {
  static const String baseUrl = "http://44.201.186.18:5001/api";

  // Create a new medicine
  static Future<Medicine> createMedicine(Medicine medicine) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/medicines'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(medicine.toMap()),
      );

      if (response.statusCode == 201) {
        return Medicine.fromMap(jsonDecode(response.body));
      } else {
        throw Exception('Failed to create medicine: ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to create medicine: $e');
    }
  }

  // Get all medicines for a pharmacy
  static Future<List<Medicine>> getMedicinesByPharmacy(int pharmacyId) async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/medicines?pharmacyId=$pharmacyId'));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((medicine) => Medicine.fromMap(medicine)).toList();
      } else {
        throw Exception('Failed to fetch medicines: ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to fetch medicines: $e');
    }
  }

  static Future<List<Medicine>> getMedicines() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/medicines'));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((medicine) => Medicine.fromMap(medicine)).toList();
      } else {
        throw Exception('Failed to fetch medicines: ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to fetch medicines: $e');
    }
  }

  static Future<Medicine> getMedicineById(int id) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/medicines/$id'));

      if (response.statusCode == 200) {
        return Medicine.fromMap(jsonDecode(response.body));
      } else if (response.statusCode == 404) {
        throw Exception('Medicine not found');
      } else {
        throw Exception('Failed to fetch medicine: ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to fetch medicine: $e');
    }
  }

  // Update a medicine
  static Future<Medicine> updateMedicine(int id, Medicine medicine) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/medicines/$id'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(medicine.toMap()),
      );

      if (response.statusCode == 200) {
        return Medicine.fromMap(jsonDecode(response.body));
      } else {
        throw Exception('Failed to update medicine: ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to update medicine: $e');
    }
  }

  // Delete a medicine (soft delete)
  static Future<void> deleteMedicine(int id) async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl/medicines/$id'));

      if (response.statusCode != 204) {
        throw Exception('Failed to delete medicine: ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to delete medicine: $e');
    }
  }
}
