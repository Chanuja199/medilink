import 'package:flutter/material.dart';
import 'package:medilink/models/medicine.model.dart';
import 'package:medilink/pages/create.inventory.page.dart';
import 'package:medilink/pages/edit.inventory.page.dart';
import 'package:medilink/services/medicine.service.dart';
import 'package:medilink/utils/prefs.dart';

class InventoryPage extends StatefulWidget {
  const InventoryPage({super.key});

  @override
  State<InventoryPage> createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage> {
  List<Medicine> _medicines = [];
  bool _isLoading = true; // Track loading state
  String _errorMessage = ''; // Store error messages

  @override
  void initState() {
    super.initState();
    _fetchMedicines(); // Fetch medicines when the widget is initialized
  }

  // Fetch medicines for the current pharmacy
  Future<void> _fetchMedicines() async {
    try {
      final pharmacyId = SharedPreferencesHelper.getInt("pharmacyId");
      if (pharmacyId == null) {
        throw Exception('Pharmacy ID not found');
      }

      final medicines =
          await MedicineService.getMedicinesByPharmacy(pharmacyId);
      setState(() {
        _medicines = medicines;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to fetch medicines: $e';
        _isLoading = false;
      });
    }
  }

  // Delete a medicine
  Future<void> _deleteMedicine(int id) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Medicine'),
        content: const Text('Are you sure you want to delete this medicine?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context); // Close the dialog
              try {
                await MedicineService.deleteMedicine(id);

                // Show success message
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Medicine deleted successfully!')),
                );

                // Refresh the list of medicines
                await _fetchMedicines();
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Failed to delete medicine: $e')),
                );
              }
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventory'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CreateInventoryPage(),
            ),
          ).then((_) =>
              _fetchMedicines()); // Refresh the list after creating a new medicine
        },
        child: const Icon(Icons.add),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage.isNotEmpty
              ? Center(child: Text(_errorMessage))
              : _medicines.isEmpty
                  ? const Center(child: Text('No medicines found'))
                  : ListView.builder(
                      itemCount: _medicines.length,
                      itemBuilder: (context, index) {
                        final medicine = _medicines[index];
                        return ListTile(
                          title: Text(medicine.name),
                          subtitle: Text(
                              'Stock: ${medicine.stock}, Price: \$${medicine.price.toStringAsFixed(2)}'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Edit Button
                              IconButton(
                                icon:
                                    const Icon(Icons.edit, color: Colors.blue),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => EditMedicinePage(
                                          medicineId: medicine.id!),
                                    ),
                                  ).then((_) =>
                                      _fetchMedicines()); // Refresh the list after editing
                                },
                              ),
                              // Delete Button
                              IconButton(
                                icon:
                                    const Icon(Icons.delete, color: Colors.red),
                                onPressed: () => _deleteMedicine(medicine.id!),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
    );
  }
}
