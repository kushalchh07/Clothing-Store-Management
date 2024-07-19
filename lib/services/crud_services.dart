// ignore_for_file: empty_catches

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nepstyle_management_system/models/category_model.dart';
import 'package:nepstyle_management_system/models/customerModel.dart';
import 'package:nepstyle_management_system/models/inventory_model.dart';
import 'package:nepstyle_management_system/models/order_model.dart';
import 'package:nepstyle_management_system/models/purchase_model.dart';
import 'package:nepstyle_management_system/models/stock_data_model.dart';
import 'package:nepstyle_management_system/models/sales_model.dart';
import 'package:nepstyle_management_system/models/supplier_model.dart';
import 'package:nepstyle_management_system/pages/Home/sales.dart';

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

  Future<String> updateCustomer(String id, String name, String address,
      String phone, String email) async {
    log("Inside updateCustomer");
    try {
      await _firestore.collection('customers').doc(id).update({
        'name': name,
        'phone': phone,
        'email': email,
        'address': address,
      });
      log("data updated");
      return "Data updated";
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
      // log(customers.toString());
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
    // log("Inside addproducts");
    try {
      _firestore.collection('products').doc(id).set({
        'id': id,
        'name': productName,
        'description': description,
        'purPrice': purPrice,
        'sellingprice': sellingPrice,
        'quantity': quantity,
        'productImage': productImage,
        'category': category
      });
      // log("data added");
      return "Data added";
    } catch (e) {
      return e.toString();
    }
  }

  Future<String> updateProducts(
      String id,
      String productName,
      String description,
      String purPrice,
      String sellingPrice,
      String quantity,
      String productImage,
      String category) async {
    log("Inside updateProducts");
    try {
      _firestore.collection('products').doc(id).update({
        'name': productName,
        'description': description,
        'purPrice': purPrice,
        'sellingprice': sellingPrice,
        'quantity': quantity,
        'productImage': productImage,
        'category': category
      });
      log("data updated");
      return "Data updated";
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
      // log(products.toString());
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

  Future<String> updateSuppliers(String id, String name, String address,
      String phone, String email) async {
    log("Inside updateSuppliers");
    try {
      _firestore.collection('suppliers').doc(id).update({
        'name': name,
        'address': address,
        'phone': phone,
        'email': email,
      });
      log("data updated");
      return "Data updated";
    } catch (e) {
      return e.toString();
    }
  }

  Future<List<SupplierModel>> getSuppliers() async {
    try {
      final snapshot = await _firestore.collection('suppliers').get();
      final suppliers = snapshot.docs.map((doc) {
        return SupplierModel.fromMap(
            doc.id, doc.data() as Map<String, dynamic>);
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

  Future<String> addPurchases(
      String id,
      String date,
      String supplier,
      String category,
      String productName,
      String quantity,
      String perPiecePrice,
      String totalAmount,
      String description) async {
    log("Inside add purchases");
    try {
      _firestore.collection('purchases').doc(id).set({
        'id': id,
        'date': date,
        'supplier': supplier,
        'category': category,
        'productName': productName,
        'quantity': quantity,
        'perPiecePrice': perPiecePrice,
        'totalAmount': totalAmount,
        'description': description
      });
      log("data added");
      return "Data added";
    } catch (e) {
      return e.toString();
    }
  }

  Future<String> updatePurchases(
    String id,
    String date,
    String supplier,
    String category,
    String productName,
    String quantity,
    String perPiecePrice,
    String totalAmount,
    String description,
  ) async {
    log("Inside updatePurchases");
    try {
      _firestore.collection('purchases').doc(id).update({
        'date': date,
        'supplier': supplier,
        'category': category,
        'productName': productName,
        'quantity': quantity,
        'perPiecePrice': perPiecePrice,
        'totalAmount': totalAmount,
        'description': description,
      });
      log("data updated");
      return "Data updated";
    } catch (e) {
      return e.toString();
    }
  }

  Future<List<PurchaseModel>> getPurchases() async {
    try {
      final snapshot = await _firestore.collection('purchases').get();
      final purchases = snapshot.docs.map((doc) {
        return PurchaseModel.fromMap(
            doc.id, doc.data() as Map<String, dynamic>);
      }).toList();
      log(purchases.toString());
      return purchases;
    } catch (e) {
      log('error during geting  purchases');
      rethrow;
    }
  }

  Future<String> deletePurchase(String id) async {
    try {
      await _firestore.collection('purchases').doc(id).delete();
      return "deleted";
    } catch (e) {
      return e.toString();
    }
  }

  Future<String> addSales(
      String id,
      String date,
      String customerName,
      String productName,
      String quantity,
      String perPiecePrice,
      String totalAmount) async {
    log("Inside add sales");
    try {
      _firestore.collection('sales').doc(id).set({
        'id': id,
        'date': date,
        'customerName': customerName,
        'productName': productName,
        'quantity': quantity,
        'perPiecePrice': perPiecePrice,
        'totalAmount': totalAmount,
      });
      log("data added");
      return "Data added";
    } catch (e) {
      return e.toString();
    }
  }

  Future<String> updateSales(
    String id,
    String date,
    String customerName,
    String productName,
    String quantity,
    String perPiecePrice,
    String totalAmount,
  ) async {
    log("Inside updateSales");
    try {
      _firestore.collection('sales').doc(id).update({
        'date': date,
        'customerName': customerName,
        'productName': productName,
        'quantity': quantity,
        'perPiecePrice': perPiecePrice,
        'totalAmount': totalAmount,
      });
      log("data updated");
      return "Data updated";
    } catch (e) {
      return e.toString();
    }
  }

  Future<List<SalesModel>> getSales() async {
    try {
      final snapshot = await _firestore.collection('sales').get();
      final sales = snapshot.docs.map((doc) {
        return SalesModel.fromMap(doc.id, doc.data() as Map<String, dynamic>);
      }).toList();
      log(sales.toString());
      return sales;
    } catch (e) {
      log('error during geting  purchases');
      rethrow;
    }
  }

  Future<String> deleteSales(String id) async {
    try {
      await _firestore.collection('sales').doc(id).delete();
      return "deleted";
    } catch (e) {
      return e.toString();
    }
  }

  Future<String> addOrders(
      String id,
      String date,
      String customerName,
      String orderCode,
      String productName,
      String category,
      String quantity,
      String perPiecePrice,
      String totalAmount) async {
    log("Inside add sales");
    try {
      _firestore.collection('orders').doc(id).set({
        'id': id,
        'date': date,
        'customerName': customerName,
        'orderCode': orderCode,
        'productName': productName,
        'category': category,
        'quantity': quantity,
        'perPiecePrice': perPiecePrice,
        'totalAmount': totalAmount,
      });
      log("data added");
      return "Data added";
    } catch (e) {
      return e.toString();
    }
  }

  Future<String> updateOrder(
    String id,
    String date,
    String customerName,
    String orderCode,
    String productName,
    String category,
    String quantity,
    String perPiecePrice,
    String totalAmount,
  ) async {
    log("Inside updateOrder");
    try {
      _firestore.collection('orders').doc(id).update({
        'date': date,
        'customerName': customerName,
        'orderCode': orderCode,
        'productName': productName,
        'category': category,
        'quantity': quantity,
        'perPiecePrice': perPiecePrice,
        'totalAmount': totalAmount,
      });
      log("data updated");
      return "Data updated";
    } catch (e) {
      return e.toString();
    }
  }

  Future<List<OrderModel>> getOrder() async {
    try {
      final snapshot = await _firestore.collection('orders').get();
      final orders = snapshot.docs.map((doc) {
        return OrderModel.fromMap(doc.id, doc.data() as Map<String, dynamic>);
      }).toList();
      log(orders.toString());
      return orders;
    } catch (e) {
      log('error during geting  orders');
      rethrow;
    }
  }

  Future<String> deleteOrder(String id) async {
    try {
      await _firestore.collection('orders').doc(id).delete();
      return "deleted";
    } catch (e) {
      return e.toString();
    }
  }

  Future<String> addCategory(
    String id,
    String category,
    String quantity,
  ) async {
    log("Inside add sales");
    try {
      _firestore.collection('category').doc(id).set({
        'id': id,
        'category': category,
        'quantity': quantity,
      });
      log("data added");
      return "Data added";
    } catch (e) {
      return e.toString();
    }
  }

  Future<String> updateCategory(
    String id,
    String category,
    String quantity,
  ) async {
    log("Inside updateOrder");
    try {
      _firestore.collection('category').doc(id).update({
        'id': id,
        'category': category,
        'quantity': quantity,
      });
      log("data updated");
      return "Data updated";
    } catch (e) {
      return e.toString();
    }
  }

  Future<List<CategoryModel>> getCategory() async {
    try {
      final snapshot = await _firestore.collection('category').get();
      final category = snapshot.docs.map((doc) {
        return CategoryModel.fromMap(
            doc.id, doc.data() as Map<String, dynamic>);
      }).toList();
      log(category.toString());
      return category;
    } catch (e) {
      log('error during geting  category');
      rethrow;
    }
  }

  Future<String> deleteCategory(String id) async {
    try {
      await _firestore.collection('category').doc(id).delete();
      return "deleted";
    } catch (e) {
      return e.toString();
    }
  }

  Future<List<StockDataModel>> getStockData() async {
    try {
      final categories = await getCategory();
      final stockData = categories.map((category) {
        return StockDataModel(
            category.category, double.parse(category.quantity));
      }).toList();
      return stockData;
    } catch (e) {
      log('error during getting category');
      rethrow;
    }
  }

  Future<int> getCustomerCount() async {
    final QuerySnapshot snapshot =
        await _firestore.collection('customers').get();
    return snapshot.size;
  }

  Future<int> getCategoryCount() async {
    final QuerySnapshot snapshot =
        await _firestore.collection('category').get();
    return snapshot.size;
  }

  Future<int> getProductsCount() async {
    final QuerySnapshot snapshot =
        await _firestore.collection('products').get();
    return snapshot.size;
  }

  Future<int> getSuppliersCount() async {
    final QuerySnapshot snapshot =
        await _firestore.collection('suppliers').get();
    return snapshot.size;
  }
}
