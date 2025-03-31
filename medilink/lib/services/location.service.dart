import 'package:flutter/services.dart';
import 'package:location/location.dart';

class LocationService {
  final Location _location = Location();

  Future<Map<String, double>?> getCurrentLocation() async {
    try {
      // Check and request location permissions
      PermissionStatus permissionStatus = await _location.hasPermission();

      if (permissionStatus == PermissionStatus.denied) {
        permissionStatus = await _location.requestPermission();

        if (permissionStatus != PermissionStatus.granted) {
          print('Location permissions not granted');
          return null;
        }
      }

      // Check if location services are enabled
      bool serviceEnabled = await _location.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await _location.requestService();

        if (!serviceEnabled) {
          print('Location services are disabled');
          return null;
        }
      }

      // Get current location
      LocationData? locationData = await _location.getLocation();

      // Return latitude and longitude
      return {
        'latitude': locationData.latitude ?? 0.0,
        'longitude': locationData.longitude ?? 0.0
      };
    } on PlatformException catch (e) {
      // Handle platform-specific exceptions
      print('Error getting location: ${e.code} - ${e.message}');
      return null;
    } catch (e) {
      // Handle any other unexpected errors
      print('Unexpected error in getCurrentLocation: $e');
      return null;
    }
  }

  // Optional: Method to continuously track location
  Stream<LocationData?> trackLocation() {
    try {
      // Configure location tracking settings
      _location.changeSettings(
          accuracy: LocationAccuracy.high,
          interval: 1000, // 1 second
          distanceFilter: 10 // meters
          );

      return _location.onLocationChanged;
    } catch (e) {
      print('Error setting up location tracking: $e');
      return Stream.empty();
    }
  }
}
