import 'dart:convert';

class Inventory {
  String id;
  String productName;
  String description;
  double purchasePrice;
  double sellingPrice;
  String productImage;
  int quantity;
  String category;
  Inventory(
      {required this.id,
      required this.productName,
      required this.description,
      required this.purchasePrice,
      required this.sellingPrice,
      required this.productImage,
      required this.quantity,
      required this.category});

  Map<String, dynamic> toMap() {
    return {
      'name': productName,
      'description': description,
      'purPrice': purchasePrice,
      'sellingprice': sellingPrice,
      'productImage': productImage,
      'quantity': quantity,
      'category': category
    };
  }

  factory Inventory.fromMap(String id, Map<String, dynamic> map) {
    return Inventory(
      id: id,
      productName: map['name'] ?? '',
      description: map['description'] ?? '',
      purchasePrice: map['purPrice'] != null
          ? double.tryParse(map['purPrice'].toString()) ?? 0.0
          : 0.0,
      sellingPrice: map['sellingprice'] != null
          ? double.tryParse(map['sellingprice'].toString()) ?? 0.0
          : 0.0,
      productImage: map['productImage'] ?? '',
      quantity: map['quantity'] != null
          ? int.tryParse(map['quantity'].toString()) ?? 0
          : 0,
      category: map['category'] ?? '',
    );
  }
}
