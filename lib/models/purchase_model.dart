class PurchaseModel {
  String id;
  DateTime date;
  String supplier;
  String productName;
  String quantity;
  double perPiecePrice;
  double totalAmount;
  String category;
  String description;

  PurchaseModel({
    required this.id,
    required this.date,
    required this.supplier,
    required this.productName,
    required this.quantity,
    required this.perPiecePrice,
    required this.totalAmount,
    required this.category,
    required this.description,
  });

  Map<String, dynamic> toMap() {
    return {
      'date': date.toIso8601String(),
      'supplier': supplier,
      'productName': productName,
      'quantity': quantity,
      'perPiecePrice': perPiecePrice,
      'totalAmount': totalAmount,
      'category': category,
      'description': description,
      'id': id
    };
  }

  factory PurchaseModel.fromMap(String id, Map<String, dynamic> map) {
    return PurchaseModel(
      id: id,
      date: DateTime.parse(map['date'] ?? ''),
      supplier: map['supplier'] ?? '',
      productName: map['productName'] ?? '',
      quantity: map['quantity'] ?? 0,
      perPiecePrice: map['perPiecePrice'] != null
          ? double.tryParse(map['perPiecePrice'].toString()) ?? 0.0
          : 0.0,
      totalAmount: map['totalAmount'] != null
          ? double.tryParse(map['totalAmount'].toString()) ?? 0.0
          : 0.0,
      category: map['category'] ?? '',
      description: map['description'] ?? '',
    );
  }
}
