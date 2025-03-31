import 'package:flutter/material.dart';
import 'package:medilink/models/pharmacy.model.dart';
import 'package:medilink/services/pharmacy.service.dart';
import 'package:medilink/utils/prefs.dart';

class ShopPage extends StatefulWidget {
  const ShopPage({super.key});

  @override
  _ShopPageState createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _cityController = TextEditingController();
  final _streetController = TextEditingController();
  final _zipController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();

  bool _isLoading = true; // Track loading state for fetching data
  bool _isUpdating = false; // Track loading state for updating data
  String _errorMessage = ''; // Store error messages

  // Regular expressions for validation
  final _nameRegex = RegExp(r'^[a-zA-Z0-9\s]{1,50}$');
  final _cityStreetRegex = RegExp(r'^[a-zA-Z\s]{1,50}$');
  final _zipRegex = RegExp(r'^\d{4,10}$');
  final _phoneRegex = RegExp(r'^\d{10,15}$');
  final _emailRegex = RegExp(r'^[\w\.-]+@[a-zA-Z\d\.-]+\.[a-zA-Z]{2,6}$');

  @override
  void initState() {
    super.initState();
    _fetchPharmacyData(); // Fetch pharmacy data when the widget is initialized
  }

  // Fetch pharmacy data by ID
  Future<void> _fetchPharmacyData() async {
    try {
      final pharmacyId = SharedPreferencesHelper.getInt("pharmacyId");
      if (pharmacyId == null) {
        throw Exception('Pharmacy ID not found');
      }

      final pharmacy = await PharmacyService.getPharmacyById(pharmacyId);

      setState(() {
        _nameController.text = pharmacy.name;
        _cityController.text = pharmacy.location?['city'] ?? '';
        _streetController.text = pharmacy.location?['street'] ?? '';
        _zipController.text = pharmacy.location?['zipCode'] ?? '';
        _phoneController.text = pharmacy.contactInfo?['phone'] ?? '';
        _emailController.text = pharmacy.contactInfo?['email'] ?? '';
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to fetch pharmacy data: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Update Your Pharmacy"),
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
                        const SizedBox(height: 20),
                        _buildTextField("Pharmacy Name", _nameController,
                            _nameRegex, "Enter a valid name (1-50 characters)"),
                        const SizedBox(height: 20),
                        const Text("Location",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 10),
                        _buildTextField("City", _cityController,
                            _cityStreetRegex, "Enter a valid city name"),
                        const SizedBox(height: 10),
                        _buildTextField("Street", _streetController,
                            _cityStreetRegex, "Enter a valid street name"),
                        const SizedBox(height: 10),
                        _buildTextField(
                            "Zip Code",
                            _zipController,
                            _zipRegex,
                            "Enter a valid zip code (4-10 digits)",
                            TextInputType.number),
                        const SizedBox(height: 20),
                        const Text("Contact Info",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 10),
                        _buildTextField(
                            "Phone",
                            _phoneController,
                            _phoneRegex,
                            "Enter a valid phone number (10-15 digits)",
                            TextInputType.phone),
                        const SizedBox(height: 10),
                        _buildTextField("Email", _emailController, _emailRegex,
                            "Enter a valid email", TextInputType.emailAddress),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _isUpdating ? null : _updatePharmacy,
                            child: _isUpdating
                                ? const CircularProgressIndicator()
                                : const Text('Update Pharmacy'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      RegExp regex, String errorMessage,
      [TextInputType keyboardType = TextInputType.text]) {
    return TextFormField(
      controller: controller,
      decoration:
          InputDecoration(labelText: label, border: const OutlineInputBorder()),
      textInputAction: TextInputAction.next,
      keyboardType: keyboardType,
      validator: (value) {
        if (value == null || value.isEmpty) return "$label is required";
        if (!regex.hasMatch(value)) return errorMessage;
        return null;
      },
    );
  }

  // Update pharmacy data
  Future<void> _updatePharmacy() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isUpdating = true);

      try {
        final pharmacyId = SharedPreferencesHelper.getInt("pharmacyId");
        if (pharmacyId == null) {
          throw Exception('Pharmacy ID not found');
        }

        final location = {
          "city": _cityController.text.trim(),
          "street": _streetController.text.trim(),
          "zipCode": _zipController.text.trim(),
        };
        final contactInfo = {
          "phone": _phoneController.text.trim(),
          "email": _emailController.text.trim(),
        };

        final pharmacy = Pharmacy(
          id: pharmacyId,
          name: _nameController.text.trim(),
          location: location,
          contactInfo: contactInfo,
          userId: int.parse(SharedPreferencesHelper.getString("userId")!),
        );

        await PharmacyService.updatePharmacy(pharmacyId, pharmacy);

        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Pharmacy updated successfully!')));
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to update pharmacy: $e')));
      } finally {
        setState(() => _isUpdating = false);
      }
    }
  }
}
