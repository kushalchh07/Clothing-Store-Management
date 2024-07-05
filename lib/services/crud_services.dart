// ignore_for_file: empty_catches

import 'package:cloud_firestore/cloud_firestore.dart';

class CrudServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
   Future<String> addCustomer(
      String name, String address, String phone, String email) async {
    try {
      _firestore.collection('customers').doc();
    } catch (e) {}
  }
}
