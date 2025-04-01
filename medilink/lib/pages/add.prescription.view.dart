import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:medilink/models/prescription.model.dart';
import 'package:medilink/pages/my.prescriptions.dart';
import 'package:medilink/services/prescription.service.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:medilink/utils/prefs.dart';

class AddPrescriptionView extends StatefulWidget {
  const AddPrescriptionView({super.key});

  @override
  _AddPrescriptionViewState createState() => _AddPrescriptionViewState();
}


class _AddPrescriptionViewState extends State<AddPrescriptionView> {
  final _formKey = GlobalKey<FormState>();
  final _textController = TextEditingController();
  File? _imageFile; // Store the selected image file
  bool _isLoading = false; // Track loading state

  // Pick an image from the gallery
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  // Submit the form
  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      try {
        if (_imageFile != null) {
          // Upload the image and create the prescription
          await _uploadImage(_imageFile!);
        } else {
          // Create the prescription
          final prescription = Prescription(
            userId: SharedPreferencesHelper.getString("userId"),
            imageUrl: null,
            text: _textController.text.trim(),
          );

          await PrescriptionService.createPrescription(prescription);

          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Prescription added successfully!')),
          );

          // Clear the form
          _textController.clear();
          setState(() => _imageFile = null);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const MyPrescriptions()),
          );
        }
      } catch (e) {
        debugPrint(e.toString());
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Failed to add prescription: Please try again')),
        );
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  // Upload image to the backend using multipart/form-data
  Future<void> _uploadImage(File imageFile) async {
    try {
      // Create a multipart request
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('http://44.201.186.18:5001/api/prescriptions'),
      );

      // Add the image file
      request.files.add(
        await http.MultipartFile.fromPath(
          'image', // Field name for the image
          imageFile.path,
        ),
      );

      // Add text and userId as form fields
      request.fields['userId'] =
          SharedPreferencesHelper.getString("userId") ?? "";
      request.fields['text'] = _textController.text.trim();

      // Send the request
      final response = await request.send();

      // Check the response
      if (response.statusCode == 201) {
        final responseData = await response.stream.bytesToString();
        jsonDecode(responseData);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Prescription added successfully!')),
        );

        // Clear the form
        _textController.clear();
        setState(() => _imageFile = null);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const MyPrescriptions()),
        );
      } else {
        throw Exception('Failed to upload image: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to upload image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add your prescription"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Image Picker
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: _imageFile == null
                      ? const Center(
                          child: Icon(Icons.add_a_photo,
                              size: 50, color: Colors.grey),
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.file(_imageFile!, fit: BoxFit.cover),
                        ),
                ),
              ),
              const SizedBox(height: 20),
              // Text Field
              TextFormField(
                controller: _textController,
                decoration: const InputDecoration(
                  labelText: 'Prescription Text (Optional)',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 20),
              // Submit Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _submitForm,
                  child: _isLoading
                      ? const CircularProgressIndicator()
                      : const Text('Add Prescription'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
