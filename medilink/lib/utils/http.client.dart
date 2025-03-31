import 'package:http/http.dart' as http;

class HttpClient {
  static const String baseUrl = "http://44.201.186.18:5001/api";

  static Future<http.Response> get(String endpoint) async {
    final response = await http.get(Uri.parse('$baseUrl/$endpoint'));
    return response;
  }

  static Future<http.Response> post(String endpoint, dynamic body) async {
    final response = await http.post(
      Uri.parse('$baseUrl/$endpoint'),
      headers: {'Content-Type': 'application/json'},
      body: body,
    );
    return response;
  }

  static Future<http.Response> put(String endpoint, dynamic body) async {
    final response = await http.put(
      Uri.parse('$baseUrl/$endpoint'),
      headers: {'Content-Type': 'application/json'},
      body: body,
    );
    return response;
  }

  static Future<http.Response> delete(String endpoint) async {
    final response = await http.delete(Uri.parse('$baseUrl/$endpoint'));
    return response;
  }
}
