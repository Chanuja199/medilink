import 'package:flutter/material.dart';
import 'package:medilink/models/medicine.model.dart';
import 'package:medilink/services/medicine.service.dart';
import 'package:medilink/utils/prefs.dart';

class EditMedicinePage extends StatefulWidget {
  final int medicineId;

  const EditMedicinePage({super.key, required this.medicineId});

  @override
  _EditMedicinePageState createState() => _EditMedicinePageState();
}

class _EditMedicinePageState extends State<EditMedicinePage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _stockController = TextEditingController();
  final _priceController = TextEditingController();

  bool _isLoading = true; // Track loading state for fetching data
  bool _isUpdating = false; // Track loading state for updating data
  String _errorMessage = ''; // Store error messages

  // Regex for validation
  final _nameRegex = RegExp(r'^[a-zA-Z0-9\s]{1,100}$');
  final _stockRegex = RegExp(r'^\d+$');
  final _priceRegex = RegExp(r'^\d+(\.\d{1,2})?$');

  @override
  void initState() {
    super.initState();
    _fetchMedicineData(); // Fetch medicine data when the widget is initialized
  }

  // Fetch medicine data by ID
  Future<void> _fetchMedicineData() async {
    try {
      final medicine = await MedicineService.getMedicineById(widget.medicineId);

      setState(() {
        _nameController.text = medicine.name;
        _descriptionController.text = medicine.description ?? '';
        _stockController.text = medicine.stock.toString();
        _priceController.text = medicine.price.toString();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to fetch medicine data: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Medicine"),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage.isNotEmpty
              ? Center(child: Text(_errorMessage))
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: ListView(
                      children: [
                        // Name Field
                        TextFormField(
                          controller: _nameController,
                          decoration: const InputDecoration(
                            labelText: 'Medicine Name',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Medicine name is required';
                            }
                            if (!_nameRegex.hasMatch(value)) {
                              return 'Enter a valid name (1-100 characters)';
                            }
                            return null;
                          },
                          textInputAction: TextInputAction.next,
                        ),
                        const SizedBox(height: 20),

                        // Description Field
                        TextFormField(
                          controller: _descriptionController,
                          decoration: const InputDecoration(
                            labelText: 'Description (Optional)',
                            border: OutlineInputBorder(),
                          ),
                          textInputAction: TextInputAction.next,
                        ),
                        const SizedBox(height: 20),

                        // Stock Field
                        TextFormField(
                          controller: _stockController,
                          decoration: const InputDecoration(
                            labelText: 'Stock',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Stock is required';
                            }
                            if (!_stockRegex.hasMatch(value)) {
                              return 'Enter a valid stock number';
                            }
                            return null;
                          },
                          textInputAction: TextInputAction.next,
                        ),
                        const SizedBox(height: 20),

                        // Price Field
                        TextFormField(
                          controller: _priceController,
                          decoration: const InputDecoration(
                            labelText: 'Price',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Price is required';
                            }
                            if (!_priceRegex.hasMatch(value)) {
                              return 'Enter a valid price (e.g., 10.99)';
                            }
                            return null;
                          },
                          textInputAction: TextInputAction.done,
                        ),
                        const SizedBox(height: 20),

                        // Update Button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _isUpdating ? null : _updateMedicine,
                            child: _isUpdating
                                ? const CircularProgressIndicator()
                                : const Text('Update Medicine'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
    );
  }

  // Update Medicine
  Future<void> _updateMedicine() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isUpdating = true);

      try {
        final medicine = Medicine(
          id: widget.medicineId,
          name: _nameController.text.trim(),
          description: _descriptionController.text.trim(),
          pharmacyId: SharedPreferencesHelper.getInt("pharmacyId")!,
          stock: int.parse(_stockController.text.trim()),
          price: double.parse(_priceController.text.trim()),
          deleteStatus: false,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        await MedicineService.updateMedicine(widget.medicineId, medicine);

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Medicine updated successfully!')),
        );

        // Navigate back to the inventory page
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update medicine: $e')),
        );
      } finally {
        setState(() => _isUpdating = false);
      }
    }
  }
}
