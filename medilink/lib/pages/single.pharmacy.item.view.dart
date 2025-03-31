import 'package:flutter/material.dart';
import 'package:medilink/models/medicine.model.dart';
import 'package:medilink/models/prescription.model.dart';
import 'package:medilink/services/medicine.service.dart';
import 'package:medilink/services/prescription.service.dart';
import 'package:medilink/utils/prefs.dart';
import 'package:medilink/widgets/order.placement.modal.dart';

class SingleItemView extends StatefulWidget {
  final int itemId;

  const SingleItemView({super.key, required this.itemId});

  @override
  State<SingleItemView> createState() => _SingleItemViewState();
}

class _SingleItemViewState extends State<SingleItemView> {
  Medicine? _medicine;
  bool _isLoading = true; // Track loading state
  String _errorMessage = ''; // Store error messages

  @override
  void initState() {
    super.initState();
    _fetchMedicineData(); // Fetch medicine data when the widget is initialized
  }

  // Fetch medicine data by ID
  Future<void> _fetchMedicineData() async {
    try {
      final medicine = await MedicineService.getMedicineById(widget.itemId);
      setState(() {
        _medicine = medicine;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to fetch medicine data: $e';
        _isLoading = false;
      });
    }
  }

  // Handle "Buy Now" button click
  void _handleBuyNow() {
    if (_medicine != null) {
      showDialog(
        context: context,
        builder: (context) => OrderPlacementModal(medicine: _medicine!),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Medicine Details'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage.isNotEmpty
              ? Center(child: Text(_errorMessage))
              : _medicine == null
                  ? const Center(child: Text('Medicine not found'))
                  : Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Medicine Image (Placeholder)
                          Container(
                            height: 200,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.blue.shade100,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: Text(
                                _medicine!.name[0].toUpperCase(),
                                style: const TextStyle(
                                  fontSize: 48,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          // Medicine Name
                          Text(
                            _medicine!.name,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          // Medicine Description (Optional)
                          if (_medicine!.description != null)
                            Text(
                              _medicine!.description!,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                          const SizedBox(height: 20),
                          // Medicine Price
                          Text(
                            'Price: \$${_medicine!.price.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                          const SizedBox(height: 10),
                          // Medicine Stock
                          Text(
                            'Stock: ${_medicine!.stock}',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 20),
                          // Buy Now Button
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _handleBuyNow,
                              style: ElevatedButton.styleFrom(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white,
                              ),
                              child: const Text(
                                'Buy Now',
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
    );
  }
}
