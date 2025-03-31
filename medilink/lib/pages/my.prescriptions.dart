import 'package:flutter/material.dart';
import 'package:medilink/models/prescription.model.dart';
import 'package:medilink/pages/prescription.order.view.dart';
import 'package:medilink/pages/text.extraction.view.dart';
import 'package:medilink/services/prescription.service.dart';

class MyPrescriptions extends StatefulWidget {
  const MyPrescriptions({super.key});

  @override
  _MyPrescriptionsState createState() => _MyPrescriptionsState();
}

class _MyPrescriptionsState extends State<MyPrescriptions>
    with SingleTickerProviderStateMixin {
  List<Prescription> _prescriptions = [];
  bool _isLoading = true;
  String _errorMessage = '';

  // Animation controller
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _fetchPrescriptions();

    // Initialize animation
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );

    // Start animation
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // Fetch prescriptions from API
  Future<void> _fetchPrescriptions() async {
    try {
      final prescriptions = await PrescriptionService.getPrescriptions();
      setState(() {
        _prescriptions = prescriptions.reversed.toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to fetch prescriptions: $e';
        _isLoading = false;
      });
    }
  }

  // Handle "Process" button click
  void _handleProcess(Prescription prescriptionId) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => TextExtractionScreen(
                  prescription: prescriptionId,
                )));
  }

  // Handle Delete with Confirmation Dialog
  Future<void> _confirmDelete(int prescriptionId, int index) async {
    bool? confirmDelete = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Prescription"),
        content:
            const Text("Are you sure you want to delete this prescription?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmDelete == true) {
      _deletePrescription(prescriptionId, index);
    }
  }

  // Delete Prescription with Animation
  Future<void> _deletePrescription(int prescriptionId, int index) async {
    try {
      await PrescriptionService.deletePrescription(prescriptionId);

      // Animate removal
      setState(() {
        _prescriptions.removeAt(index);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Prescription deleted successfully")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to delete prescription: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My Prescriptions and Orders")),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage.isNotEmpty
              ? Center(child: Text(_errorMessage))
              : _prescriptions.isEmpty
                  ? const Center(child: Text('No prescriptions found'))
                  : ListView.builder(
                      padding: const EdgeInsets.all(8),
                      itemCount: _prescriptions.length,
                      itemBuilder: (context, index) {
                        final prescription = _prescriptions[index];
                        return FadeTransition(
                          opacity: _animation,
                          child: ScaleTransition(
                            scale: _animation,
                            child: Card(
                              margin: const EdgeInsets.all(8),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Prescription Image (if available)
                                    if (prescription.imageUrl != null)
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Image.network(
                                          'http://44.201.186.18:5001${prescription.imageUrl}',
                                          fit: BoxFit.cover,
                                          height: 150,
                                          width: double.infinity,
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                            return const Icon(Icons.error,
                                                color: Colors.red);
                                          },
                                        ),
                                      ),
                                    const SizedBox(height: 10),
                                    // Prescription Text
                                    if (prescription.text != null)
                                      Text(
                                        prescription.text!,
                                        style: const TextStyle(
                                            fontSize: 16, color: Colors.grey),
                                      ),
                                    const SizedBox(height: 10),
                                    // Buttons (Process & Delete)
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        (prescription.status == "pending")
                                            ? ElevatedButton(
                                                onPressed: () => _handleProcess(
                                                    prescription),
                                                child: const Text('Process'),
                                              )
                                            : ElevatedButton(
                                                onPressed: () => Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            PrescriptionOrderListView(
                                                              prescriptionId:
                                                                  prescription
                                                                      .id!,
                                                            ))),
                                                child:
                                                    const Text('Check Order'),
                                              ),
                                        IconButton(
                                          icon: const Icon(Icons.delete,
                                              color: Colors.red),
                                          onPressed: () => _confirmDelete(
                                              prescription.id!, index),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
    );
  }
}
