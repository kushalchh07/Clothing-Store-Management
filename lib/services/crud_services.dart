// ignore_for_file: empty_catches

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

class CrudServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<String> addCustomer(String id, String name, String address,
      String phone, String email) async {
    log("Inside addcustomer");
    try {
      _firestore.collection('customers').doc(id).set({
        'name': name,
        'phone': phone,
        'email': email,
        'address': address,
      });
      log("data added");
      return "Data added";
    } catch (e) {
      return e.toString();
    }
  }
}
