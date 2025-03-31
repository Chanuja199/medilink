// pharmacy.model.dart
class Pharmacy {
  final int id;
  final double price;
  final int stock;

  Pharmacy({
    required this.id,
    required this.price,
    required this.stock,
  });

  factory Pharmacy.fromJson(Map<String, dynamic> json) {
    return Pharmacy(
      id: json['pharmacyId'],
      price: json['price'].toDouble(),
      stock: json['stock'],
    );
  }
}

// alternative.model.dart
class Alternative {
  final String name;
  final String reason;
  final List<Pharmacy> availableAt;

  Alternative({
    required this.name,
    required this.reason,
    required this.availableAt,
  });

  factory Alternative.fromJson(Map<String, dynamic> json) {
    final List<dynamic> availableAtJson = json['availableAt'] ?? [];
    final List<Pharmacy> availableAt = availableAtJson
        .map((pharmacyJson) => Pharmacy.fromJson(pharmacyJson))
        .toList();

    return Alternative(
      name: json['name'],
      reason: json['reason'] ?? 'Alternative medicine',
      availableAt: availableAt,
    );
  }
}

// prescribed_medicine.model.dart
class PrescribedMedicine {
  final int medcineId;
  final String name;
  final List<Pharmacy> availableAt;
  final List<Alternative> alternatives;

  PrescribedMedicine({
    required this.medcineId,
    required this.name,
    required this.availableAt,
    required this.alternatives,
  });

  factory PrescribedMedicine.fromJson(Map<String, dynamic> json) {
    final List<dynamic> availableAtJson = json['availableAt'] ?? [];
    final List<Pharmacy> availableAt = availableAtJson
        .map((pharmacyJson) => Pharmacy.fromJson(pharmacyJson))
        .toList();

    final List<dynamic> alternativesJson = json['alternatives'] ?? [];
    final List<Alternative> alternatives = alternativesJson
        .map((alternativeJson) => Alternative.fromJson(alternativeJson))
        .toList();

    return PrescribedMedicine(
      medcineId: json['medicineId'] ?? 1,
      name: json['name'],
      availableAt: availableAt,
      alternatives: alternatives,
    );
  }
}

// prescription_analysis.model.dart
class PrescriptionAnalysis {
  final List<PrescribedMedicine> prescribedMedicines;

  PrescriptionAnalysis({
    required this.prescribedMedicines,
  });

  factory PrescriptionAnalysis.fromJson(Map<String, dynamic> json) {
    final List<dynamic> prescribedMedicinesJson =
        json['prescribedMedicines'] ?? [];
    final List<PrescribedMedicine> prescribedMedicines = prescribedMedicinesJson
        .map((medicineJson) => PrescribedMedicine.fromJson(medicineJson))
        .toList();

    return PrescriptionAnalysis(
      prescribedMedicines: prescribedMedicines,
    );
  }
}
