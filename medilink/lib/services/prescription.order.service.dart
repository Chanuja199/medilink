import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:medilink/models/prescription.order.model.dart';

class PrescriptionOrderService {
  static const String baseUrl = "http://44.201.186.18:5001/api";

  // Fetch all prescription orders
  static Future<List<PrescriptionOrder>> getPrescriptionOrders(int id) async {
    try {
      final response =
          await http.get(Uri.parse('$baseUrl/prescription-order/$id'));

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        List<PrescriptionOrder> orders = [];
        for (final order in jsonResponse) {
          orders.add(PrescriptionOrder.fromJson(order));
        }
        return orders;
      } else {
        throw Exception(
            'Failed to fetch prescription orders: ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to fetch prescription orders: $e');
    }
  }
}
