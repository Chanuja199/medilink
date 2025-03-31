import 'dart:math';

import 'package:medilink/models/pharmacy.model.dart';

class PharmacyDistanceService {
  // Haversine formula to calculate distance between two points on Earth
  double _calculateDistance(double userLatitude, double userLongitude,
      double pharmacyLatitude, double pharmacyLongitude) {
    const double earthRadius = 6371; // Radius of the Earth in kilometers

    // Convert degrees to radians
    double lat1Rad = _degreesToRadians(userLatitude);
    double lon1Rad = _degreesToRadians(userLongitude);
    double lat2Rad = _degreesToRadians(pharmacyLatitude);
    double lon2Rad = _degreesToRadians(pharmacyLongitude);

    // Differences in coordinates
    double latDiff = lat2Rad - lat1Rad;
    double lonDiff = lon2Rad - lon1Rad;

    // Haversine formula
    double a = pow(sin(latDiff / 2), 2) +
        cos(lat1Rad) * cos(lat2Rad) * pow(sin(lonDiff / 2), 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    // Distance in kilometers
    return earthRadius * c;
  }

  // Helper method to convert degrees to radians
  double _degreesToRadians(double degrees) {
    return degrees * (pi / 180);
  }

  // Method to sort pharmacies by distance from user's location
  List<Pharmacy> sortPharmaciesByDistance(List<Pharmacy> pharmacies,
      {required double userLatitude, required double userLongitude}) {
    // Create a new list with distance information
    List<Map<String, dynamic>> pharmacyDistances = pharmacies.map((pharmacy) {
      // Safely extract latitude and longitude
      double? pharmacyLat = pharmacy.location?['latitude'] as double?;
      double? pharmacyLon = pharmacy.location?['longitude'] as double?;

      // Calculate distance if coordinates are available
      double distance = (pharmacyLat != null && pharmacyLon != null)
          ? _calculateDistance(
              userLatitude, userLongitude, pharmacyLat, pharmacyLon)
          : double.infinity;

      return {'pharmacy': pharmacy, 'distance': distance};
    }).toList();

    // Sort by distance
    pharmacyDistances.sort((a, b) => a['distance'].compareTo(b['distance']));

    // Return sorted list of pharmacies
    return pharmacyDistances
        .map((item) => item['pharmacy'] as Pharmacy)
        .toList();
  }

  // Method to get the nearest pharmacy
  Pharmacy? getNearestPharmacy(List<Pharmacy> pharmacies,
      {required double userLatitude, required double userLongitude}) {
    if (pharmacies.isEmpty) return null;

    List<Pharmacy> sortedPharmacies = sortPharmaciesByDistance(pharmacies,
        userLatitude: userLatitude, userLongitude: userLongitude);

    return sortedPharmacies.first;
  }

  // Method to get pharmacies within a specific radius
  List<Pharmacy> getPharmaciesWithinRadius(List<Pharmacy> pharmacies,
      {required double userLatitude,
      required double userLongitude,
      double radiusKm = 10}) {
    return pharmacies.where((pharmacy) {
      // Safely extract latitude and longitude
      double? pharmacyLat = pharmacy.location?['latitude'] as double?;
      double? pharmacyLon = pharmacy.location?['longitude'] as double?;

      // Calculate distance if coordinates are available
      if (pharmacyLat != null && pharmacyLon != null) {
        double distance = _calculateDistance(
            userLatitude, userLongitude, pharmacyLat, pharmacyLon);
        return distance <= radiusKm;
      }

      return false;
    }).toList();
  }
}
