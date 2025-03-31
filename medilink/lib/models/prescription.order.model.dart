import 'package:medilink/models/pharmacy.model.dart';

class PrescriptionOrder {
  final int id;
  final int userId;
  final int pharmacyId;
  final int prescriptionId;
  final String status;
  final String paymentMethod;
  final String deliveryOption;
  final bool deleteStatus;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Prescription prescription;
  final List<OrderMedicine> orderMedicines;
  final Pharmacy pharmacy;

  PrescriptionOrder({
    required this.id,
    required this.userId,
    required this.pharmacyId,
    required this.prescriptionId,
    required this.status,
    required this.paymentMethod,
    required this.deliveryOption,
    required this.deleteStatus,
    required this.createdAt,
    required this.updatedAt,
    required this.prescription,
    required this.orderMedicines,
    required this.pharmacy,
  });

  // Convert JSON to PrescriptionOrder
  factory PrescriptionOrder.fromJson(Map<String, dynamic> json) {
    return PrescriptionOrder(
      id: json['id'],
      userId: json['userId'],
      pharmacyId: json['pharmacyId'],
      prescriptionId: json['prescriptionId'],
      status: json['status'],
      paymentMethod: json['paymentMethod'],
      deliveryOption: json['deliveryOption'],
      deleteStatus: json['deleteStatus'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      pharmacy: Pharmacy.fromMap(json['pharmacy']),
      prescription: Prescription.fromJson(json['prescription']),
      orderMedicines: (json['orderMedicines'] as List)
          .map((medicine) => OrderMedicine.fromJson(medicine))
          .toList(),
    );
  }
}

class Prescription {
  final int id;
  final int userId;
  final String? imageUrl;
  final String? text;
  final bool deleteStatus;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String status;

  Prescription({
    required this.id,
    required this.userId,
    this.imageUrl,
    this.text,
    required this.deleteStatus,
    required this.createdAt,
    required this.updatedAt,
    required this.status,
  });

  // Convert JSON to Prescription
  factory Prescription.fromJson(Map<String, dynamic> json) {
    return Prescription(
      id: json['id'],
      userId: json['userId'],
      imageUrl: json['imageUrl'],
      text: json['text'],
      deleteStatus: json['deleteStatus'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      status: json['status'],
    );
  }
}

class OrderMedicine {
  final int orderId;
  final int medicineId;
  final int quantity;
  final double price;
  final bool deleteStatus;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Medicine medicine;

  OrderMedicine({
    required this.orderId,
    required this.medicineId,
    required this.quantity,
    required this.price,
    required this.deleteStatus,
    required this.createdAt,
    required this.updatedAt,
    required this.medicine,
  });

  // Convert JSON to OrderMedicine
  factory OrderMedicine.fromJson(Map<String, dynamic> json) {
    return OrderMedicine(
      orderId: json['orderId'],
      medicineId: json['medicineId'],
      quantity: json['quantity'],
      price: json['price'] * 1.0,
      deleteStatus: json['deleteStatus'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      medicine: Medicine.fromJson(json['medicine']),
    );
  }
}

class Medicine {
  final int id;
  final String name;
  final String description;
  final int pharmacyId;
  final int stock;
  final double price;
  final bool deleteStatus;
  final DateTime createdAt;
  final DateTime updatedAt;

  Medicine({
    required this.id,
    required this.name,
    required this.description,
    required this.pharmacyId,
    required this.stock,
    required this.price,
    required this.deleteStatus,
    required this.createdAt,
    required this.updatedAt,
  });

  // Convert JSON to Medicine
  factory Medicine.fromJson(Map<String, dynamic> json) {
    return Medicine(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      pharmacyId: json['pharmacyId'],
      stock: json['stock'],
      price: json['price'] * 1.0,
      deleteStatus: json['deleteStatus'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}
