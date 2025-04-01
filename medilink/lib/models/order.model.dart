import 'package:medilink/models/medicine.model.dart';
import 'package:medilink/models/user.model.dart';

class OrderMedicine {
  final int medicineId;
  final int quantity;
  final Medicine? medicine;


  OrderMedicine({
    required this.medicineId,
    required this.quantity,
    this.medicine,
  });

  // Convert OrderMedicine object to a Map
  Map<String, dynamic> toMap() {
    try {
      return {
        'medicineId': medicineId,
        'quantity': quantity,
        // Optionally include medicine details if needed
        if (medicine != null) 'medicine': medicine?.toMap(),
      };
    } catch (e) {
      print('Error in OrderMedicine toMap: $e');
      throw "Error while converting order medicine to map: $e";
    }
  }

  // Create OrderMedicine object from a Map
  factory OrderMedicine.fromMap(Map<String, dynamic> map) {
    return OrderMedicine(
      medicineId: map['medicineId'],
      quantity: map['quantity'],
      medicine:
          map['medicine'] != null ? Medicine.fromMap(map['medicine']) : null,
    );
  }
}

class Order {
  final int? id; // Optional for creation, required for updates
  final int userId;
  final int pharmacyId;
  String status;
  final String paymentMethod;
  final String deliveryOption;
  final List<OrderMedicine> medicines;
  final int prescriptionId;
  final User? user;

  Order({
    this.id,
    required this.userId,
    required this.pharmacyId,
    this.status = 'pending',
    required this.paymentMethod,
    required this.deliveryOption,
    required this.medicines,
    required this.prescriptionId,
    this.user,
  });

  // Convert Order object to a Map
  Map<String, dynamic> toMap() {
    try {
      return {
        if (id != null) 'id': id,
        'userId': userId,
        'pharmacyId': pharmacyId,
        'status': status,
        'paymentMethod': paymentMethod,
        'deliveryOption': deliveryOption,
        'prescriptionId': prescriptionId,
        // Convert medicines to a list of maps using toList()
        'medicines': medicines.map((medicine) => medicine.toMap()).toList(),
      };
    } catch (e) {
      print('Error in Order toMap: $e');
      throw "Error while converting order to map: $e";
    }
  }

  // Create Order object from a Map
  factory Order.fromMap(Map<String, dynamic> map) {
    return Order(
      id: map['id'],
      userId: map['userId'],
      pharmacyId: map['pharmacyId'],
      status: map['status'],
      paymentMethod: map['paymentMethod'],
      deliveryOption: map['deliveryOption'],
      // Handle both 'medicines' and 'orderMedicines' keys
      medicines: ((map['medicines'] ?? map['orderMedicines']) as List)
          .map((medicine) => OrderMedicine.fromMap(medicine))
          .toList(),
      prescriptionId: map['prescriptionId'] ?? 1,
      user: map['user'] != null ? User.fromMap(map['user']) : null,
    );
  }
}
