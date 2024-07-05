import 'dart:convert';

class CustomerModel {
  String name;
  String phone;
  String email;
  String address;

  CustomerModel({
    required this.name,
    required this.phone,
    required this.email,
    required this.address,
  });

  // Convert a Customer object into a Map object
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'phone': phone,
      'email': email,
      'address': address,
    };
  }

  // Convert a Map object into a Customer object
  factory CustomerModel.fromMap(Map<String, dynamic> map) {
    return CustomerModel(
      name: map['name'] ?? '',
      phone: map['phone'] ?? '',
      email: map['email'] ?? '',
      address: map['address'] ?? '',
    );
  }

  // Convert a Customer object into a JSON object
  String toJson() => json.encode(toMap());

  // Convert a JSON object into a Customer object
  factory CustomerModel.fromJson(String source) =>
      CustomerModel.fromMap(json.decode(source));
}
