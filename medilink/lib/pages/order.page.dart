import 'package:flutter/material.dart';
import 'package:medilink/models/order.model.dart';
import 'package:medilink/services/order.service.dart';
import 'package:medilink/utils/prefs.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({super.key});

  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  List<Order> _orders = [];
  bool _isLoading = true; // Track loading state
  String? _errorMessage; // Store error messages

  @override
  void initState() {
    super.initState();
    _fetchOrders(); // Fetch orders when the widget is initialized
  }

  // Fetch orders and filter by pharmacyId
  Future<void> _fetchOrders() async {
    try {
      final pharmacyId = SharedPreferencesHelper.getInt("pharmacyId");
      if (pharmacyId == null) {
        throw Exception('Pharmacy ID not found');
      }

      final orders = await OrderService.getOrders();

      // Filter orders by pharmacyId
      final filteredOrders =
          orders.where((order) => order.pharmacyId == pharmacyId).toList();

      setState(() {
        _orders = filteredOrders;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to fetch orders: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Orders'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(child: Text(_errorMessage!))
              : _orders.isEmpty
                  ? const Center(child: Text('No orders found'))
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _orders.length,
                      itemBuilder: (context, index) {
                        final order = _orders[index];
                        return _buildOrderCard(order);
                      },
                    ),
    );
  }

  // Build a card for each order
  Widget _buildOrderCard(Order order) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Order ID: ${order.id}',
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Status:', style: TextStyle(fontSize: 16)),
                _buildStatusDropdown(order),
              ],
            ),
            Text('Payment Method: ${order.paymentMethod}',
                style: const TextStyle(fontSize: 16)),
            Text('Delivery: ${order.deliveryOption}',
                style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 16),
            const Text('Medicines:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            _buildMedicineTable(order.medicines),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusDropdown(Order order) {
    List<String> statusOptions = [
      'pending',
      'processing',
      'delivered',
      'completed'
    ];

    return DropdownButton<String>(
      value: order.status,
      items: statusOptions.map((status) {
        return DropdownMenuItem(
          value: status,
          child: Text(status),
        );
      }).toList(),
      onChanged: (newStatus) async {
        if (newStatus != null) {
          await _updateOrderStatus(order.id!, newStatus, order);
        }
      },
    );
  }

  Future<void> _updateOrderStatus(
      int orderId, String newStatus, Order order) async {
    setState(() {
      _isLoading = true;
    });

    try {
      Order o = order;
      o.status = newStatus;
      await OrderService.updateOrder(orderId, o);
      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Order status updated to $newStatus')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update order status: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Widget _buildMedicineTable(List<OrderMedicine> medicines) {
    return DataTable(
      columns: const [
        DataColumn(
            label: Text('Medicine',
                style: TextStyle(fontWeight: FontWeight.bold))),
        DataColumn(
            label: Text('Quantity',
                style: TextStyle(fontWeight: FontWeight.bold))),
        DataColumn(
            label:
                Text('Price', style: TextStyle(fontWeight: FontWeight.bold))),
      ],
      rows: medicines.map((medicine) {
        return DataRow(cells: [
          DataCell(Text(medicine.medicine?.name ?? 'N/A')),
          DataCell(Text(medicine.quantity.toString())),
          DataCell(Text('\$${medicine.medicine?.price.toStringAsFixed(2)}')),
        ]);
      }).toList(),
    );
  }
}
