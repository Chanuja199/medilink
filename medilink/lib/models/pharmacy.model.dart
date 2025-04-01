class Pharmacy {
  final int? id; // Optional for creation, required for updates
  final String name;
  final Map<String, dynamic>? location;
  final Map<String, dynamic>? contactInfo;
  final Map<String, dynamic>? inventory;
  final int userId; // Required user ID for 1-1 relationship


  Pharmacy({
    this.id,
    required this.name,
    this.location,
    this.contactInfo,
    this.inventory,
    required this.userId,
  });

  // Convert Pharmacy object to a Map
  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'name': name,
      if (location != null) 'location': location,
      if (contactInfo != null) 'contactInfo': contactInfo,
      if (inventory != null) 'inventory': inventory,
      'userId': userId,
    };
  }

  // Create Pharmacy object from a Map
  factory Pharmacy.fromMap(Map<String, dynamic> map) {
    return Pharmacy(
      id: map['id'],
      name: map['name'],
      location: map['location'],
      contactInfo: map['contactInfo'],
      inventory: map['inventory'],
      userId: map['userId'],
    );
  }
}
