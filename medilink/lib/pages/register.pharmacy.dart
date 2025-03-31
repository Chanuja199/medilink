import 'package:flutter/material.dart';
import 'package:medilink/models/pharmacy.model.dart';
import 'package:medilink/pages/pharmacy.home.page.dart';
import 'package:medilink/services/location.service.dart';
import 'package:medilink/services/pharmacy.service.dart';
import 'package:medilink/utils/prefs.dart';

class RegisterPharmacyPage extends StatefulWidget {
  final int userId;

  const RegisterPharmacyPage({super.key, required this.userId});

  @override
  _RegisterPharmacyPageState createState() => _RegisterPharmacyPageState();
}

class _RegisterPharmacyPageState extends State<RegisterPharmacyPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _cityController = TextEditingController();
  final _streetController = TextEditingController();
  final _zipController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();

  bool _isLoading = false;

  // Regular expressions for validation
  final _nameRegex = RegExp(r'^[a-zA-Z0-9\s]{1,50}$');
  final _cityStreetRegex = RegExp(r'^[a-zA-Z\s]{1,50}$');
  final _zipRegex = RegExp(r'^\d{4,10}$');
  final _phoneRegex = RegExp(r'^\d{10,15}$');
  final _emailRegex = RegExp(r'^[\w\.-]+@[a-zA-Z\d\.-]+\.[a-zA-Z]{2,6}$');

  final LocationService _locationService = LocationService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Register Pharmacy"),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildTextField("Pharmacy Name", _nameController, _nameRegex,
                  "Enter a valid name (1-50 characters)"),
              const SizedBox(height: 20),
              const Text("Location",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              _buildTextField("City", _cityController, _cityStreetRegex,
                  "Enter a valid city name"),
              const SizedBox(height: 10),
              _buildTextField("Street", _streetController, _cityStreetRegex,
                  "Enter a valid street name"),
              const SizedBox(height: 10),
              _buildTextField("Zip Code", _zipController, _zipRegex,
                  "Enter a valid zip code (4-10 digits)", TextInputType.number),
              const SizedBox(height: 20),
              const Text("Contact Info",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
                  onPressed: _isLoading ? null : _registerPharmacy,
                  child: _isLoading
                      ? const CircularProgressIndicator()
                      : const Text('Register Pharmacy'),
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

  Future<void> _registerPharmacy() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      try {
        final currentLocation = await _locationService.getCurrentLocation();
        final location = {
          "city": _cityController.text.trim(),
          "street": _streetController.text.trim(),
          "zipCode": _zipController.text.trim(),
          if (currentLocation != null) ...{
            "latitude": currentLocation['latitude'],
            "longitude": currentLocation['longitude']
          }
        };
        final contactInfo = {
          "phone": _phoneController.text.trim(),
          "email": _emailController.text.trim(),
        };

        final pharmacy = Pharmacy(
          name: _nameController.text.trim(),
          location: location,
          contactInfo: contactInfo,
          userId: widget.userId,
        );

        final ph = await PharmacyService.createPharmacy(pharmacy);
        SharedPreferencesHelper.setInt("pharmacyId", ph.id!);

        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Pharmacy registered successfully!')));

        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => PharmacyHomePage()));
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(
                'Failed to register pharmacy,You already have a pharamcy')));
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }
}
