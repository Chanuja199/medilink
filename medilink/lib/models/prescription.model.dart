class Prescription {
  final int? id; // Optional for creation, required for updates
  final dynamic userId;
  final String? imageUrl;
  final String? text;
  final String status;

  Prescription({
    this.id,
    required this.userId,
    this.imageUrl,
    this.text,
    this.status = "pending",
  });

  // Convert Prescription object to a Map
  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'userId': userId,
      if (imageUrl != null) 'imageUrl': imageUrl,
      if (text != null) 'text': text,
    };
  }

  // Create Prescription object from a Map
  factory Prescription.fromMap(Map<String, dynamic> map) {
    return Prescription(
        id: map['id'],
        userId: map['userId'],
        imageUrl: map['imageUrl'],
        text: map['text'],
        status: map['status']);
  }
}
