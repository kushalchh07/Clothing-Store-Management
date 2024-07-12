class CategoryModel {
  String id;
  String category;
  String quantity;

  CategoryModel({
    required this.id,
    required this.category,
    required this.quantity,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'category': category,
      'quantity': quantity,
    };
  }

  factory CategoryModel.fromMap(String id, Map<String, dynamic> map) {
    return CategoryModel(
      id: id,
      category: map['category'] ?? '',
      quantity: map['quantity'] ?? '0',
    );
  }
}
