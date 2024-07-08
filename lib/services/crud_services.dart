// ignore_for_file: empty_catches

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nepstyle_management_system/models/customerModel.dart';
import 'package:nepstyle_management_system/models/inventory_model.dart';
import 'package:nepstyle_management_system/models/supplier_model.dart';

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
  Future<List<Customer>> getCustomers() async {
    try {
      final snapshot = await _firestore.collection('customers').get();
      final customers = snapshot.docs.map((doc) {
        return Customer.fromMap(doc.id, doc.data() as Map<String, dynamic>);
      }).toList();
      log(customers.toString());
      return customers;
    } catch (e) {
      log('error during geting  customers');
      rethrow;
    }
  }
Future<String> deleteCustomer(String id) async {
    try {
      await _firestore.collection('customers').doc(id).delete();
      return "Customer deleted";
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
  Future<String> addSuppliers(String id, String name, String address,
      String phone, String email) async {
    log("Inside add Suppliers");
    try {
      _firestore.collection('suppliers').doc(id).set({
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
  Future<List<SupplierModel>> getSuppliers() async {
    try {
      final snapshot = await _firestore.collection('suppliers').get();
      final suppliers = snapshot.docs.map((doc) {
        return SupplierModel.fromMap(doc.id, doc.data() as Map<String, dynamic>);
      }).toList();
      log(suppliers.toString());
      return suppliers;
    } catch (e) {
      log('error during geting  suppliers');
      rethrow;
    }
  }
  Future<String> deleteSupplier(String id) async {
    try {
      await _firestore.collection('suppliers').doc(id).delete();
      return "deleted";
    } catch (e) {
      return e.toString();
    }
  }
}
