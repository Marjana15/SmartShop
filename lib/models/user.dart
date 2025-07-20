// lib/models/user.dart
class User {
  final String email;
  final String password;
  final String firstName;
  final String lastName;
  final String phone;
  final String address;
  final String imageUrl;

  User({
    required this.email,
    required this.password,
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.address,
    required this.imageUrl,
  });

  factory User.fromJson(Map<String, dynamic> j) => User(
    email: j['email'],
    password: j['password'],
    firstName: j['firstName'],
    lastName: j['lastName'],
    phone: j['phone'],
    address: j['address'],
    imageUrl: j['imageUrl'],
  );

  Map<String, dynamic> toJson() => {
    'email': email,
    'password': password,
    'firstName': firstName,
    'lastName': lastName,
    'phone': phone,
    'address': address,
    'imageUrl': imageUrl,
  };
}
