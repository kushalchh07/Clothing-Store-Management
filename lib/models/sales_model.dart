import 'dart:convert';

class SalesModel {
  String id;
  String nameCustomer;
  String nameProduct;
  String quantity;
  String perPiecePrice;
  String totalAmount;
  String date;

  SalesModel({
    required this.id,
    required this.nameCustomer,
    required this.nameProduct,
    required this.quantity,
    required this.perPiecePrice,
    required this.totalAmount,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'nameCustomer': nameCustomer,
      'nameProduct': nameProduct,
      'quantity': quantity,
      'perPiecePrice': perPiecePrice,
      'totalAmount': totalAmount,
      'date': date,
    };
  }

  factory SalesModel.fromMap(String id, Map<String, dynamic> map) {
    return SalesModel(
      id: id,
      nameCustomer: map['nameCustomer'] ?? '',
      nameProduct: map['nameProduct'] ?? '',
      quantity: map['quantity'] ?? '',
      perPiecePrice: map['perPiecePrice'] ?? '',
      totalAmount: map['totalAmount'] ?? '',
      date: map['date'] ?? '',
    );
  }
}
