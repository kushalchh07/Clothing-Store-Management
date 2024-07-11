part of 'inventory_bloc.dart';

@immutable
sealed class InventoryEvent {}

final class InventoryLoadEvent extends InventoryEvent {}

final class InventoryAddButtonTappedEvent extends InventoryEvent {
  final String name;
  final String category;
  final String description;
  final String purPrice;
  final String sellingPrice;
  final String quantity;
  final String productImage;
  final String id;
  InventoryAddButtonTappedEvent({
    required this.name,
    required this.category,
    required this.description,
    required this.purPrice,
    required this.sellingPrice,
    required this.quantity,
    required this.productImage,
    required this.id,
  });
}

class InventoryUpdateButtonTappedEvent extends InventoryEvent {
  String id;
  String name;
  String category;
  String description;
  String purPrice;
  String sellingPrice;
  String quantity;
  String productImage;
  InventoryUpdateButtonTappedEvent({required this.id, required this.name, required this.category, required this.description, required this.purPrice, required this.sellingPrice, required this.quantity, required this.productImage});
}

class InventoryDeleteButtonTappedEvent extends InventoryEvent {
  final String id;
  InventoryDeleteButtonTappedEvent({required this.id});
}
