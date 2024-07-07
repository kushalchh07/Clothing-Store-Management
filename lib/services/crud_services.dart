// ignore_for_file: empty_catches

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nepstyle_management_system/models/inventory_model.dart';

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

  Future<String> addProducts(
      String id,
      String productName,
      String description,
      String purPrice,
      String sellingPrice,
      String quantity,
      String productImage,
      String category) async {
    log("Inside addproducts");
    try {
      _firestore.collection('products').doc(id).set({
        'id':id,
        'name': productName,
        'description': description,
        'purPrice': purPrice,
        'sellingprice': sellingPrice,
        'quantity': quantity,
        'productImage': productImage,
        'category': category
      });
      log("data added");
      return "Data added";
    } catch (e) {
      return e.toString();
    }
  }

  Future<List<Inventory>> getInventory() async {
    try {
      final snapshot = await _firestore.collection('products').get();
      final products = snapshot.docs.map((doc) {
        return Inventory.fromMap(doc.id, doc.data() as Map<String, dynamic>);
      }).toList();
      log(products.toString());
      return products;
    } catch (e) {
      log('error during geting  invventory');
      rethrow;
    }
  }

  Future<String> deleteProduct(String id) async {
    try {
      await _firestore.collection('products').doc(id).delete();
      return "deleted";
    } catch (e) {
      return e.toString();
    }
  }
}
