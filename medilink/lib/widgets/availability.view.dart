import 'package:flutter/material.dart';
import 'package:medilink/models/order.model.dart';
import 'package:medilink/models/prescription.analasys.model.dart';
import 'package:medilink/pages/welcome.home.page.dart';
import 'package:medilink/services/order.service.dart';
import 'package:medilink/services/pharmacy.service.dart';
import 'package:medilink/utils/prefs.dart';

class AvailabilityResultView extends StatelessWidget {
  final Map<String, dynamic> analysisResult;
  final int prescriptionId;
  const AvailabilityResultView(
      {Key? key, required this.analysisResult, required this.prescriptionId})
      : super(key: key);

  // Method to handle order placement with options
  Future<void> _placeOrder(BuildContext context, int pharmacyId,
      List<PrescribedMedicine> medicines) async {
    // Default values
    String paymentMethod = 'cash';
    String deliveryOption = 'home delivery';
    String deliveryAddress = '';

    // Show dialog for selecting options
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return OrderOptionsDialog(
          onConfirm: (selectedPaymentMethod, selectedDeliveryOption, address) {
            paymentMethod = selectedPaymentMethod;
            deliveryOption = selectedDeliveryOption;
            if (selectedDeliveryOption == 'pickup') {
              deliveryOption = 'pickup at $address';
            } else if (address.isNotEmpty) {
              deliveryAddress = address;
            }
            Navigator.of(context).pop();
          },
          pharmacyId: pharmacyId,
        );
      },
    );

    try {
      // Create a list of OrderMedicine objects
      final orderMedicines = medicines.map((medicine) {
        return OrderMedicine(
          medicineId: medicine.medcineId,
          quantity: 1,
        );
      }).toList();

      print(orderMedicines.length);

      // Create the order with selected options
      final order = Order(
        userId: int.parse(SharedPreferencesHelper.getString("userId")!),
        pharmacyId: pharmacyId,
        paymentMethod: paymentMethod,
        deliveryOption:
            deliveryAddress.isNotEmpty ? deliveryAddress : deliveryOption,
        medicines: orderMedicines,
        prescriptionId: prescriptionId,
        //  deliveryAddress: deliveryAddress,
      );

      // Call the OrderService to create the order
      await OrderService.createOrder(order);

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Order placed successfully!')),
      );

      // Navigate to the order details page or another screen
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => WelcomeHomePage()),
        (Route<dynamic> route) => false,
      );
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to place order')),
      );
    }
  }

  // Rest of the class remains the same
  @override
  Widget build(BuildContext context) {
    // Parse the analysis result using our model
    final analysis = PrescriptionAnalysis.fromJson(analysisResult);

    // Group medicines by pharmacy
    Map<int, List<PrescribedMedicine>> pharmacyMedicinesMap = {};

    // Iterate through all prescribed medicines
    for (var medicine in analysis.prescribedMedicines) {
      // For each medicine, check all pharmacies where it's available
      for (var pharmacy in medicine.availableAt) {
        // If this is the first medicine for this pharmacy, initialize the list
        if (!pharmacyMedicinesMap.containsKey(pharmacy.id)) {
          pharmacyMedicinesMap[pharmacy.id] = [];
        }
        // Add this medicine to the list for this pharmacy
        pharmacyMedicinesMap[pharmacy.id]!.add(medicine);
      }
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // First show all prescribed medicines
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Prescribed Medicines',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: analysis.prescribedMedicines.length,
            itemBuilder: (context, index) {
              final medicine = analysis.prescribedMedicines[index];
              return MedicineCard(medicine: medicine);
            },
          ),

          // Then show medicines grouped by pharmacy
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Available at Pharmacies',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
          ),

          // If no pharmacies have medicines available
          if (pharmacyMedicinesMap.isEmpty)
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'None of your prescribed medicines are available at any pharmacy.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.red,
                ),
              ),
            ),

          // For each pharmacy, show available medicines and a "Place Order" button
          ...pharmacyMedicinesMap.entries.map((entry) {
            int pharmacyId = entry.key;
            List<PrescribedMedicine> medicines = entry.value;

            return PharmacyMedicinesCard(
              pharmacyId: pharmacyId,
              medicines: medicines,
              onPlaceOrder: () => _placeOrder(context, pharmacyId, medicines),
            );
          }).toList(),
        ],
      ),
    );
  }
}

// Dialog for selecting payment method and delivery option
class OrderOptionsDialog extends StatefulWidget {
  final Function(String paymentMethod, String deliveryOption, String address)
      onConfirm;
  final int pharmacyId;

  const OrderOptionsDialog({
    Key? key,
    required this.onConfirm,
    required this.pharmacyId,
  }) : super(key: key);

  @override
  State<OrderOptionsDialog> createState() => _OrderOptionsDialogState();
}

class _OrderOptionsDialogState extends State<OrderOptionsDialog> {
  String _selectedPaymentMethod = 'cash';
  String _selectedDeliveryOption = 'home delivery';
  final TextEditingController _addressController = TextEditingController();

  // Card details controllers
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _cardHolderController = TextEditingController();
  final TextEditingController _expiryDateController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();

  bool _showCardFields = false;
  String _pharmacyAddress = '';

  @override
  void initState() {
    super.initState();
    _loadPharmacyAddress();
  }

  Future<void> _loadPharmacyAddress() async {
    try {
      final pharmacy = await PharmacyService.getPharmacyById(widget.pharmacyId);
      if (pharmacy != null && pharmacy.location != null) {
        setState(() {
          _pharmacyAddress = pharmacy.location!['address'] ?? 'Unknown address';
        });
      }
    } catch (e) {
      print('Error loading pharmacy address: $e');
    }
  }

  @override
  void dispose() {
    _addressController.dispose();
    _cardNumberController.dispose();
    _cardHolderController.dispose();
    _expiryDateController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Order Options'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Payment Method Section
            const Text(
              'Payment Method',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),

            // Payment Options
            RadioListTile<String>(
              title: const Text('Cash on Delivery (COD)'),
              value: 'cod',
              groupValue: _selectedPaymentMethod,
              onChanged: (value) {
                setState(() {
                  _selectedPaymentMethod = value!;
                  _showCardFields = false;
                });
              },
            ),
            RadioListTile<String>(
              title: const Text('Cash at Pharmacy'),
              value: 'cash',
              groupValue: _selectedPaymentMethod,
              onChanged: (value) {
                setState(() {
                  _selectedPaymentMethod = value!;
                  _showCardFields = false;
                });
              },
            ),
            RadioListTile<String>(
              title: const Text('Card Payment'),
              value: 'card',
              groupValue: _selectedPaymentMethod,
              onChanged: (value) {
                setState(() {
                  _selectedPaymentMethod = value!;
                  _showCardFields = true;
                });
              },
            ),

            // Card details section (shown only when card is selected)
            if (_showCardFields) ...[
              const SizedBox(height: 16),
              const Text(
                'Card Details',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _cardNumberController,
                decoration: const InputDecoration(
                  labelText: 'Card Number',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _cardHolderController,
                decoration: const InputDecoration(
                  labelText: 'Card Holder Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _expiryDateController,
                      decoration: const InputDecoration(
                        labelText: 'Expiry Date (MM/YY)',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextField(
                      controller: _cvvController,
                      decoration: const InputDecoration(
                        labelText: 'CVV',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      obscureText: true,
                      maxLength: 3,
                    ),
                  ),
                ],
              ),
            ],

            const SizedBox(height: 24),

            // Delivery Option Section
            const Text(
              'Delivery Option',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),

            // Delivery Options
            RadioListTile<String>(
              title: const Text('Home Delivery'),
              value: 'home delivery',
              groupValue: _selectedDeliveryOption,
              onChanged: (value) {
                setState(() {
                  _selectedDeliveryOption = value!;
                });
              },
            ),
            RadioListTile<String>(
              title: const Text('Pickup from Pharmacy'),
              subtitle: Text('Address: $_pharmacyAddress'),
              value: 'pickup',
              groupValue: _selectedDeliveryOption,
              onChanged: (value) {
                setState(() {
                  _selectedDeliveryOption = value!;
                });
              },
            ),

            // Address field for delivery
            if (_selectedDeliveryOption == 'home delivery') ...[
              const SizedBox(height: 16),
              const Text(
                'Delivery Address',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _addressController,
                decoration: const InputDecoration(
                  labelText: 'Enter your address',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            // Validate card details if card payment is selected
            if (_selectedPaymentMethod == 'card') {
              if (_cardNumberController.text.isEmpty ||
                  _cardHolderController.text.isEmpty ||
                  _expiryDateController.text.isEmpty ||
                  _cvvController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Please fill in all card details')),
                );
                return;
              }
            }

            // Validate delivery address if home delivery is selected
            if (_selectedDeliveryOption == 'home delivery' &&
                _addressController.text.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Please enter your delivery address')),
              );
              return;
            }

            // Call the onConfirm callback with selected options
            widget.onConfirm(
              _selectedPaymentMethod,
              _selectedDeliveryOption,
              _selectedDeliveryOption == 'home delivery'
                  ? _addressController.text
                  : _pharmacyAddress,
            );
          },
          child: const Text('Confirm Order'),
        ),
      ],
    );
  }
}

// Card to display individual medicine information
class MedicineCard extends StatelessWidget {
  final PrescribedMedicine medicine;

  const MedicineCard({Key? key, required this.medicine}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Medicine Name
            Text(
              medicine.name,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 16),

            // Availability Section
            Text(
              'Available at ${medicine.availableAt.length} pharmacies',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),

            // Show pharmacy details if available
            if (medicine.availableAt.isNotEmpty)
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: medicine.availableAt.length > 3
                    ? 3
                    : medicine.availableAt.length, // Limit to 3 pharmacies
                itemBuilder: (context, pharmacyIndex) {
                  final pharmacy = medicine.availableAt[pharmacyIndex];
                  return PharmacyInfoCard(
                    pharmacy: pharmacy,
                    onPlaceOrder: null,
                  );
                },
              )
            else
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  'Not available at any pharmacies',
                  style: TextStyle(color: Colors.red),
                ),
              ),

            // Show more pharmacies button if there are more than 3
            if (medicine.availableAt.length > 3)
              TextButton(
                onPressed: () {
                  // Show a dialog with all pharmacies
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('${medicine.name} - All Pharmacies'),
                      content: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: medicine.availableAt.map((pharmacy) {
                            return PharmacyInfoCard(
                              pharmacy: pharmacy,
                              onPlaceOrder: null,
                            );
                          }).toList(),
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('Close'),
                        ),
                      ],
                    ),
                  );
                },
                child: const Text('Show all pharmacies'),
              ),

            // Alternatives Section (just showing the count, not allowing purchase)
            if (medicine.alternatives.isNotEmpty) ...[
              const SizedBox(height: 16),
              Text(
                '${medicine.alternatives.length} alternatives available',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 8),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: medicine.alternatives.length,
                itemBuilder: (context, altIndex) {
                  final alternative = medicine.alternatives[altIndex];
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.blue[200]!),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          alternative.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Reason: ${alternative.reason}',
                          style: const TextStyle(
                            fontStyle: FontStyle.italic,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// A card to display all medicines available at a specific pharmacy
class PharmacyMedicinesCard extends StatelessWidget {
  final int pharmacyId;
  final List<PrescribedMedicine> medicines;
  final VoidCallback onPlaceOrder;

  const PharmacyMedicinesCard({
    Key? key,
    required this.pharmacyId,
    required this.medicines,
    required this.onPlaceOrder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Pharmacy details
            FutureBuilder(
              future: PharmacyService.getPharmacyById(pharmacyId),
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}',
                      style: const TextStyle(color: Colors.red));
                } else if (!snapshot.hasData || snapshot.data == null) {
                  return Text('Pharmacy ID: $pharmacyId',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ));
                }

                final pharmacyData = snapshot.data!;
                final location =
                    pharmacyData.location ?? {'address': 'Unknown'};

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      pharmacyData.name ?? 'Pharmacy ID: $pharmacyId',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Location: ${location['address'] ?? 'No address available'}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                );
              },
            ),

            const SizedBox(height: 16),
            const Divider(),

            // Available Medicines Section
            Text(
              'Available Medicines (${medicines.length})',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),

            // List of medicines
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: medicines.length,
              itemBuilder: (context, index) {
                final medicine = medicines[index];
                // Find the price for this medicine at this pharmacy
                final pharmacy = medicine.availableAt.firstWhere(
                  (p) => p.id == pharmacyId,
                  orElse: () => Pharmacy(id: pharmacyId, price: 0, stock: 0),
                );

                return ListTile(
                  title: Text(medicine.name),
                  subtitle: Text('Stock: ${pharmacy.stock}'),
                  trailing: Text(
                    '\$${pharmacy.price.toStringAsFixed(2)}',
                    style: const TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 16),

            // Calculate total price
            Builder(builder: (context) {
              double totalPrice = 0;
              for (var medicine in medicines) {
                final pharmacy = medicine.availableAt.firstWhere(
                  (p) => p.id == pharmacyId,
                  orElse: () => Pharmacy(id: pharmacyId, price: 0, stock: 0),
                );
                totalPrice += pharmacy.price;
              }

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total Price:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '\$${totalPrice.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              );
            }),

            const SizedBox(height: 16),

            // Place Order Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onPlaceOrder,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  foregroundColor: Colors.white,
                ),
                child: const Text(
                  'Place Order',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// A card to display pharmacy information
class PharmacyInfoCard extends StatelessWidget {
  final Pharmacy pharmacy;
  final Function(int pharmacyId)? onPlaceOrder; // Callback for placing an order

  const PharmacyInfoCard({
    Key? key,
    required this.pharmacy,
    required this.onPlaceOrder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: FutureBuilder(
              future: PharmacyService.getPharmacyById(pharmacy.id),
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SizedBox(
                    width: 10,
                    height: 10,
                  ); // Show a loading indicator while fetching data
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}',
                      style: const TextStyle(color: Colors.red));
                } else if (!snapshot.hasData || snapshot.data == null) {
                  return const Text('Pharmacy not found',
                      style: TextStyle(fontWeight: FontWeight.bold));
                }

                final pharmacyData = snapshot.data!;
                final location =
                    pharmacyData.location ?? {'address': 'Unknown'};

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${pharmacyData.name}',
                        style: const TextStyle(fontSize: 16)),
                    Text(
                        'Location: ${location['address'] ?? 'No address available'}',
                        style: const TextStyle(
                            fontSize: 14, fontStyle: FontStyle.italic)),
                  ],
                );
              },
            ),
          ),
          Text('Price: \$${pharmacy.price.toStringAsFixed(2)}',
              style: const TextStyle(color: Colors.green)),
          const SizedBox(width: 8),
          if (onPlaceOrder != null)
            // Place Order Button
            ElevatedButton(
              onPressed: () => onPlaceOrder!(pharmacy.id),
              child: const Text('Place Order'),
            ),
        ],
      ),
    );
  }
}

// A card to display alternative medicine information
class AlternativeMedicineCard extends StatelessWidget {
  final Alternative alternative;

  const AlternativeMedicineCard({Key? key, required this.alternative})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            alternative.name,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Reason: ${alternative.reason}',
            style: const TextStyle(
              fontStyle: FontStyle.italic,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Available at ${alternative.availableAt.length} pharmacies:',
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 4),
          // Show pharmacy details for alternatives
          if (alternative.availableAt.isNotEmpty)
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: alternative.availableAt.length,
              itemBuilder: (context, pharmacyIndex) {
                final pharmacy = alternative.availableAt[pharmacyIndex];
                return PharmacyInfoCard(
                  pharmacy: pharmacy,
                  onPlaceOrder: null,
                );
              },
            )
          else
            const Text(
              'Not available at any pharmacies',
              style: TextStyle(color: Colors.red),
            ),
        ],
      ),
    );
  }
}
