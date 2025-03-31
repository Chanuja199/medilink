import 'package:flutter/material.dart';
import 'package:medilink/models/medicine.model.dart';
import 'package:medilink/services/medicine.service.dart';
import 'package:medilink/utils/prefs.dart';

class CreateInventoryPage extends StatefulWidget {
  const CreateInventoryPage({super.key});

  @override
  State<CreateInventoryPage> createState() => _CreateInventoryPageState();
}

class _CreateInventoryPageState extends State<CreateInventoryPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _stockController = TextEditingController();
  final _priceController = TextEditingController();

  bool _isLoading = false; // Track loading state

  // Regex for validation
  final _nameRegex = RegExp(
      r'^[a-zA-Z0-9\s]{1,100}$'); // Alphanumeric and spaces, 1-100 characters
  final _stockRegex = RegExp(r'^\d+$'); // Positive integers
  final _priceRegex =
      RegExp(r'^\d+(\.\d{1,2})?$'); // Decimal with up to 2 decimal places

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Inventory"),
      ),
      body: Padding(
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

              // Create Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _createMedicine,
                  child: _isLoading
                      ? const CircularProgressIndicator()
                      : const Text('Create Medicine'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Create Medicine
  Future<void> _createMedicine() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      try {
        final pharmacyId = SharedPreferencesHelper.getInt("pharmacyId");
        if (pharmacyId == null) {
          throw Exception('Pharmacy ID not found');
        }

        final medicine = Medicine(
          name: _nameController.text.trim(),
          description: _descriptionController.text.trim(),
          pharmacyId: pharmacyId,
          stock: int.parse(_stockController.text.trim()),
          price: double.parse(_priceController.text.trim()),
          deleteStatus: false,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        await MedicineService.createMedicine(medicine);

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Medicine created successfully!')),
        );

        // Clear form fields
        _nameController.clear();
        _descriptionController.clear();
        _stockController.clear();
        _priceController.clear();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to create medicine: $e')),
        );
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }
}
