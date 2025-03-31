import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:medilink/models/medicine.model.dart';
import 'package:medilink/models/order.model.dart';
import 'package:medilink/models/prescription.model.dart';
import 'package:medilink/services/order.service.dart';
import 'package:medilink/services/prescription.service.dart';
import 'package:medilink/utils/prefs.dart';

enum PaymentMethod { cod, card }

// Enum for delivery options
enum DeliveryOption { delivery, pickup }

class OrderPlacementModal extends StatefulWidget {
  final Medicine medicine;

  const OrderPlacementModal({Key? key, required this.medicine})
      : super(key: key);

  @override
  _OrderPlacementModalState createState() => _OrderPlacementModalState();
}

class _OrderPlacementModalState extends State<OrderPlacementModal> {
  final _formKey = GlobalKey<FormState>();

  // Order details controllers
  final TextEditingController _quantityController =
      TextEditingController(text: '1');
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _cardNameController = TextEditingController();
  final TextEditingController _cardExpiryController = TextEditingController();
  final TextEditingController _cardCvvController = TextEditingController();

  // Selected options
  PaymentMethod _selectedPaymentMethod = PaymentMethod.cod;
  DeliveryOption _selectedDeliveryOption = DeliveryOption.delivery;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Order ${widget.medicine.name}',
                  style: Theme.of(context).textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),

                // Quantity Input
                TextFormField(
                  controller: _quantityController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: const InputDecoration(
                    labelText: 'Quantity',
                    prefixIcon: Icon(Icons.numbers),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter quantity';
                    }
                    int? quantity = int.tryParse(value);
                    if (quantity == null || quantity < 1) {
                      return 'Quantity must be at least 1';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Delivery Option Segmented Control
                const Text('Delivery Option',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: DeliveryOption.values.map((option) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: ChoiceChip(
                        label: Text(option == DeliveryOption.delivery
                            ? 'Home Delivery'
                            : 'Pickup'),
                        selected: _selectedDeliveryOption == option,
                        onSelected: (bool selected) {
                          setState(() {
                            _selectedDeliveryOption = option;
                          });
                        },
                      ),
                    );
                  }).toList(),
                ),

                // Conditional Address Input for Delivery
                if (_selectedDeliveryOption == DeliveryOption.delivery)
                  TextFormField(
                    controller: _addressController,
                    decoration: const InputDecoration(
                      labelText: 'Delivery Address',
                      prefixIcon: Icon(Icons.home),
                    ),
                    validator:
                        _selectedDeliveryOption == DeliveryOption.delivery
                            ? (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter delivery address';
                                }
                                return null;
                              }
                            : null,
                  ),
                const SizedBox(height: 16),

                // Payment Method Segmented Control
                const Text('Payment Method',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: PaymentMethod.values.map((method) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: ChoiceChip(
                        label: Text(method == PaymentMethod.cod
                            ? 'Cash on Delivery'
                            : 'Card Payment'),
                        selected: _selectedPaymentMethod == method,
                        onSelected: (bool selected) {
                          setState(() {
                            _selectedPaymentMethod = method;
                          });
                        },
                      ),
                    );
                  }).toList(),
                ),

                // Conditional Card Payment Fields
                if (_selectedPaymentMethod == PaymentMethod.card)
                  Column(
                    children: [
                      TextFormField(
                        controller: _cardNumberController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Card Number',
                          prefixIcon: Icon(Icons.credit_card),
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(16),
                        ],
                        validator: _selectedPaymentMethod == PaymentMethod.card
                            ? (value) {
                                if (value == null || value.length != 16) {
                                  return 'Enter a valid 16-digit card number';
                                }
                                return null;
                              }
                            : null,
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _cardNameController,
                        decoration: const InputDecoration(
                          labelText: 'Name on Card',
                          prefixIcon: Icon(Icons.person),
                        ),
                        validator: _selectedPaymentMethod == PaymentMethod.card
                            ? (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Enter name on card';
                                }
                                return null;
                              }
                            : null,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _cardExpiryController,
                              decoration: const InputDecoration(
                                labelText: 'MM/YY',
                                prefixIcon: Icon(Icons.calendar_today),
                              ),
                              validator: _selectedPaymentMethod ==
                                      PaymentMethod.card
                                  ? (value) {
                                      if (value == null || value.length != 5) {
                                        return 'Invalid expiry';
                                      }
                                      return null;
                                    }
                                  : null,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextFormField(
                              controller: _cardCvvController,
                              decoration: const InputDecoration(
                                labelText: 'CVV',
                                prefixIcon: Icon(Icons.lock),
                              ),
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(3),
                              ],
                              validator: _selectedPaymentMethod ==
                                      PaymentMethod.card
                                  ? (value) {
                                      if (value == null || value.length != 3) {
                                        return 'Invalid CVV';
                                      }
                                      return null;
                                    }
                                  : null,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                const SizedBox(height: 16),
                // Submit Button
                ElevatedButton(
                  onPressed: _submitOrder,
                  child: Text(
                      'Place Order - \$${(widget.medicine.price * int.parse(_quantityController.text)).toStringAsFixed(2)}'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _submitOrder() async {
    if (_formKey.currentState!.validate()) {
      final prescription = await PrescriptionService.createPrescription(
        Prescription(
            userId: SharedPreferencesHelper.getString("userId") ?? '0',
            text: widget.medicine.name),
      );
      Order order = Order(
        userId: int.parse(SharedPreferencesHelper.getString("userId") ?? '0'),
        pharmacyId: widget.medicine.pharmacyId,
        paymentMethod:
            _selectedPaymentMethod == PaymentMethod.cod ? 'COD' : 'CARD',
        deliveryOption: _selectedDeliveryOption == DeliveryOption.delivery
            ? _addressController.text
            : 'PICKUP',
        medicines: [
          OrderMedicine(
            medicineId: widget.medicine.id!,
            quantity: int.parse(_quantityController.text),
          )
        ],
        prescriptionId: prescription.id!,
        status: 'pending',
      );

      try {
        OrderService.createOrder(order).then((_) {
          Navigator.of(context).pop(); // Close the modal
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content:
                  Text('Order placed successfully for ${widget.medicine.name}'),
            ),
          );
        }).catchError((error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Order failed: $error')),
          );
        });
      } catch (e) {
        debugPrint("Order placement error: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Something went wrong. Please try again.')),
        );
      }
    }
  }

  @override
  void dispose() {
    _quantityController.dispose();
    _addressController.dispose();
    _cardNumberController.dispose();
    _cardNameController.dispose();
    _cardExpiryController.dispose();
    _cardCvvController.dispose();
    super.dispose();
  }
}

// Custom formatter for card expiry input
class CardExpiryInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    var text = newValue.text;

    if (text.length == 3 && !text.contains('/')) {
      text = '${text.substring(0, 2)}/${text.substring(2)}';
    }

    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }
}
