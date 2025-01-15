class User {
  final String id;
  final String fullName;
  final String email;
  final String phoneNumber;
  final String name;
  final String role;
  final String? image;

  User({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.name,
    required this.role,
    this.image,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'],
      fullName: json['full_name'],
      email: json['email'],
      phoneNumber: json['phone_number'],
      name: json['name'],
      role: json['role'],
      image: json['image'],
    );
  }
}
