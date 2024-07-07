import 'dart:convert';

class Customer {
  String id;
  String name;
  String phone;
  String email;
  String address;

  Customer({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    required this.address,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'phone': phone,
      'email': email,
      'address': address,
    };
  }

  factory Customer.fromMap(String id, Map<String, dynamic> map) {
    return Customer(
      id: id,
      name: map['name'] ?? '',
      phone: map['phone'] ?? '',
      email: map['email'] ?? '',
      address: map['address'] ?? '',
    );
  }
}
