import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:medilink/models/order.model.dart';

class OrderService {
  static const String baseUrl = "http://44.201.186.18:5001/api";

  // Create a new order
  static Future<Order> createOrder(Order order) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/orders'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(order.toMap()),
      );

      if (response.statusCode == 201) {
        return Order.fromMap(jsonDecode(response.body));
      } else {
        throw Exception('Failed to create order: ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to create order: $e');
    }
  }

  // Get all orders
  static Future<List<Order>> getOrders() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/orders'));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((order) => Order.fromMap(order)).toList();
      } else {
        throw Exception('Failed to fetch orders: ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to fetch orders: $e');
    }
  }

  // Get an order by ID
  static Future<Order> getOrderById(int id) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/orders/$id'));

      if (response.statusCode == 200) {
        return Order.fromMap(jsonDecode(response.body));
      } else {
        throw Exception('Failed to fetch order: ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to fetch order: $e');
    }
  }

  // Update an order
  static Future<bool> updateOrder(int id, Order order) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/orders/$id'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(order.toMap()),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception('Failed to update order: ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to update order: $e');
    }
  }

  // Delete an order
  static Future<void> deleteOrder(int id) async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl/orders/$id'));

      if (response.statusCode != 204) {
        throw Exception('Failed to delete order: ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to delete order: $e');
    }
  }
}
