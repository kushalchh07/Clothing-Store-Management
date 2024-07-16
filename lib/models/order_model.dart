class OrderModel {
  String id;
  String date;
  String customerName;
  String orderCode;
  String productName;
  String category;
  String quantity;
  double perPiecePrice;
  double totalAmount;
  String orderStatus;
  // String description;

  OrderModel({
    required this.id,
    required this.date,
    required this.customerName,
    required this.productName,
    required this.quantity,
    required this.perPiecePrice,
    required this.totalAmount,
    required this.category,
    required this.orderCode,
    required this.orderStatus,
    // required this.description,
  });

  Map<String, dynamic> toMap() {
    return {
      'date': date,
      'customerName': customerName,
      'productName': productName,
      'quantity': quantity,
      'perPiecePrice': perPiecePrice,
      'totalAmount': totalAmount,
      'category': category,
      'orderCode': orderCode,
      'orderStatus': orderStatus,
      // 'description': description,
      'id': id
    };
  }

  factory OrderModel.fromMap(String id, Map<String, dynamic> map) {
    return OrderModel(
      id: id,
      date: map['date'] ?? '',
      customerName: map['customerName'] ?? '',
      productName: map['productName'] ?? '',
      quantity: map['quantity'] ?? 0,
      perPiecePrice: map['perPiecePrice'] != null
          ? double.tryParse(map['perPiecePrice'].toString()) ?? 0.0
          : 0.0,
      totalAmount: map['totalAmount'] != null
          ? double.tryParse(map['totalAmount'].toString()) ?? 0.0
          : 0.0,
      category: map['category'] ?? '',
      orderCode: map['orderCode'] ?? '',
      orderStatus: map['orderStatus'] ?? '',
      // description: map['description'] ?? '',
    );
  }
}
