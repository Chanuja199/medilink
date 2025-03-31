import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';
import 'package:medilink/models/pharmacy.model.dart';
import 'package:medilink/services/pharmacy.distance.service.dart';

class PharmacyService {
  final PharmacyDistanceService _pharmacyDistanceService =
      PharmacyDistanceService();

  static const String baseUrl =
      "http://44.201.186.18:5001/api"; // Use 44.201.186.18 for Android emulator

  // Create a new pharmacy
  static Future<Pharmacy> createPharmacy(Pharmacy pharmacy) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/pharmacies'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(pharmacy.toMap()),
      );

      if (response.statusCode == 201) {
        return Pharmacy.fromMap(jsonDecode(response.body));
      } else {
        throw Exception('Failed to create pharmacy: ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to create pharmacy: $e');
    }
  }

  // Get all pharmacies ordered by distance
  Future<List<Pharmacy>> getPharmacies() async {
    try {
      // Get current location
      Location location = Location();
      LocationData? currentLocation = await location.getLocation();

      // Fetch pharmacies
      final response = await http.get(Uri.parse('$baseUrl/pharmacies'));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        final List<Pharmacy> pharmacies =
            data.map((pharmacy) => Pharmacy.fromMap(pharmacy)).toList();

        // Check if current location is available
        if (currentLocation.latitude != null &&
            currentLocation.longitude != null) {
          // Sort pharmacies by distance
          return _pharmacyDistanceService.sortPharmaciesByDistance(pharmacies,
              userLatitude: currentLocation.latitude!,
              userLongitude: currentLocation.longitude!);
        }

        // Return unsorted list if location is not available
        return pharmacies;
      } else {
        throw Exception('Failed to fetch pharmacies: ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to fetch pharmacies: $e');
    }
  }

  // Get a pharmacy by ID
  static Future<Pharmacy> getPharmacyById(int id) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/pharmacies/$id'));

      if (response.statusCode == 200) {
        return Pharmacy.fromMap(jsonDecode(response.body));
      } else {
        throw Exception('Failed to fetch pharmacy: ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to fetch pharmacy: $e');
    }
  }

  // Update a pharmacy
  static Future<Pharmacy> updatePharmacy(int id, Pharmacy pharmacy) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/pharmacies/$id'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(pharmacy.toMap()),
      );

      if (response.statusCode == 200) {
        return Pharmacy.fromMap(jsonDecode(response.body));
      } else {
        throw Exception('Failed to update pharmacy: ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to update pharmacy: $e');
    }
  }

  // Delete a pharmacy
  static Future<void> deletePharmacy(int id) async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl/pharmacies/$id'));

      if (response.statusCode != 204) {
        throw Exception('Failed to delete pharmacy: ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to delete pharmacy: $e');
    }
  }
}
