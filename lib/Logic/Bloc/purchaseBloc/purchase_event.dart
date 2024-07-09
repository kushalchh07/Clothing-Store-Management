part of 'purchase_bloc.dart';

@immutable
sealed class PurchaseEvent {}

class PurchaseLoadEvent extends PurchaseEvent {}

class PurchaseAddButtonTappedEvent extends PurchaseEvent {
  PurchaseAddButtonTappedEvent({
    required this.productName,
    required this.category,
    required this.description,
    required this.purPrice,
    required this.date,
    required this.quantity,
    required this.supplierName,
    required this.id,
  });
  final String productName;
  final String category;
  final String description;
  final double purPrice;
final String id;
  final int quantity;
  final DateTime date;
  final String supplierName;
}

class PurchaseUpdateButtonTappedEvent extends PurchaseEvent {
    PurchaseUpdateButtonTappedEvent({
    required this.id,
    required this.productName,
    required this.category,
    required this.description,
    required this.purPrice,
    
    required this.quantity,
    required this.date,
    required this.supplierName,
  });
  final String id;
  final String productName;
  final String category;
  final String description;
  final double purPrice;
  final String supplierName;
  final int quantity;
  final DateTime date;
}

class PurchaseDeleteButtonTappedEvent extends PurchaseEvent {
  PurchaseDeleteButtonTappedEvent({
    required this.id,
  });
  final String id;
}
