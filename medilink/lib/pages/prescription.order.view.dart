import 'package:flutter/material.dart';
import 'package:medilink/models/prescription.order.model.dart';
import 'package:medilink/services/prescription.order.service.dart';

class PrescriptionOrderListView extends StatefulWidget {
  final int prescriptionId;
  const PrescriptionOrderListView({super.key, required this.prescriptionId});

  @override
  _PrescriptionOrderListViewState createState() =>
      _PrescriptionOrderListViewState();
}

class _PrescriptionOrderListViewState extends State<PrescriptionOrderListView> {
  List<PrescriptionOrder> _orders = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchPrescriptionOrders();
  }

  Future<void> _fetchPrescriptionOrders() async {
    try {
      final orders = await PrescriptionOrderService.getPrescriptionOrders(
          widget.prescriptionId);
      setState(() {
        _orders = orders;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to fetch prescription orders: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Prescription Orders'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(child: Text(_errorMessage!))
              : _orders.isEmpty
                  ? const Center(child: Text('No orders found'))
                  : ListView.builder(
                      padding: const EdgeInsets.all(8),
                      itemCount: _orders.length,
                      itemBuilder: (context, index) {
                        return _buildOrderCard(_orders[index]);
                      },
                    ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'completed':
        return Colors.green;
      case 'processing':
        return Colors.blue;
      case 'delivered':
        return Colors.purple;
      default:
        return Colors.grey; // Fallback color
    }
  }

  Widget _buildOrderCard(PrescriptionOrder order) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ExpansionTile(
        title: Text(
          'Order ID: ${order.id}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Row(
          children: [
            Chip(
              label: Text(order.status),
              backgroundColor: _getStatusColor(order.status),
              labelStyle: const TextStyle(color: Colors.white),
            ),
          ],
        ),
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Pharmacy : ${order.pharmacy.name}'),
                Text('Prescription ID: ${order.prescriptionId}'),
                Text('Payment Method: ${order.paymentMethod}'),
                Text('Delivery Option: ${order.deliveryOption}'),
                const SizedBox(height: 8),
                const Text(
                  'Prescription Details:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                if (order.prescription.imageUrl != null)
                  Image.network(
                    'http://44.201.186.18:5001${order.prescription.imageUrl!}',
                    width: MediaQuery.of(context).size.width,
                    height: 100,
                  ),
                Text('Text: ${order.prescription.text ?? 'N/A'}'),
                const SizedBox(height: 8),
                const Text(
                  'Order Medicines:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                ...order.orderMedicines.map((medicine) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Table(
                      border: TableBorder.all(
                          color: Colors.grey), // Add borders to the table
                      columnWidths: const {
                        0: FlexColumnWidth(2), // Adjust column widths as needed
                        1: FlexColumnWidth(1),
                        2: FlexColumnWidth(1),
                        3: FlexColumnWidth(1),
                      },
                      children: [
                        // Table Header Row
                        TableRow(
                          decoration: BoxDecoration(
                              color:
                                  Colors.grey[200]), // Header background color
                          children: const [
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                'Medicine Name',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                'Quantity',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                'Unit Price',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                'Total Price',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                        // Table Data Row
                        TableRow(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(medicine.medicine.name),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(medicine.quantity.toString()),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                  '\$${medicine.medicine.price.toStringAsFixed(2)}'),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                '\$${(medicine.quantity * medicine.medicine.price).toStringAsFixed(2)}',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
