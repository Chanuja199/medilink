class User {
  final String name;
  final String email;
  final String? password;
  final String? phone;
  final dynamic location;
  final String role;


  User({
    required this.name,
    required this.email,
    required this.password,
    this.phone,
    this.location,
    this.role = "user",
  });

  // Convert User object to a Map
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'password': password,
      'phone': phone,
      'location': location,
      'role': role,
    };
  }

  // Create User object from a Map
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      name: map['name'],
      email: map['email'],
      password: map['password'],
      phone: map['phone'],
      location: map['location'],
      role: map['role'] ?? 'user',
    );
  }
}
