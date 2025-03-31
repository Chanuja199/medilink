class Medicine {
  final int? id; // Optional for creation, required for updates
  final String name;
  final String? description;
  final int pharmacyId;
  final int stock;
  final double price;
  final bool deleteStatus;
  final DateTime createdAt;
  final DateTime updatedAt;

  Medicine({
    this.id,
    required this.name,
    this.description,
    required this.pharmacyId,
    required this.stock,
    required this.price,
    this.deleteStatus = false,
    required this.createdAt,
    required this.updatedAt,
  });

  // Convert Medicine object to a Map
  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'name': name,
      if (description != null) 'description': description,
      'pharmacyId': pharmacyId,
      'stock': stock,
      'price': price,
      'deleteStatus': deleteStatus,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  // Create Medicine object from a Map
  factory Medicine.fromMap(Map<String, dynamic> map) {
    return Medicine(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      pharmacyId: map['pharmacyId'],
      stock: map['stock'],
      price: map['price'] * 1.0,
      deleteStatus: map['deleteStatus'],
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
    );
  }
}
