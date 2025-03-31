import 'dart:convert';

import 'package:medilink/utils/http.client.dart';

class UserService {
  // Create a new user
  static Future<Map<String, dynamic>> createUser(
      Map<String, dynamic> userData) async {
    try {
      final response = await HttpClient.post('users', jsonEncode(userData));
      if (response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to create user: ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to create user: $e');
    }
  }

  // Get all users
  static Future<List<dynamic>> getUsers() async {
    try {
      final response = await HttpClient.get('users');
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to fetch users: ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to fetch users: $e');
    }
  }

  // Get a user by ID
  static Future<Map<String, dynamic>> getUserById(String id) async {
    try {
      final response = await HttpClient.get('users/$id');
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to fetch user: ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to fetch user: $e');
    }
  }

  // Update a user
  static Future<Map<String, dynamic>> updateUser(
      String id, Map<String, dynamic> userData) async {
    try {
      final response = await HttpClient.put('users/$id', jsonEncode(userData));
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to update user: ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to update user: $e');
    }
  }

  // Delete a user
  static Future<void> deleteUser(String id) async {
    try {
      final response = await HttpClient.delete('users/$id');
      if (response.statusCode != 204) {
        throw Exception('Failed to delete user: ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to delete user: $e');
    }
  }

  // Login a user
  static Future<Map<String, dynamic>> loginUser(
      Map<String, dynamic> credentials) async {
    try {
      final response =
          await HttpClient.post('users/login', jsonEncode(credentials));
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to login: ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to login: $e');
    }
  }
}
