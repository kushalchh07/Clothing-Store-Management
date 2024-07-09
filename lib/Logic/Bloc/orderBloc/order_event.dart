part of 'order_bloc.dart';

@immutable
sealed class OrderEvent {}

class OrderLoadEvent extends OrderEvent {}

class OrderAddButtonTappedEvent extends OrderEvent {
  OrderAddButtonTappedEvent({
    required this.productName,
    required this.orderPrice,
    required this.quantity,
    required this.date,
    required this.customerName,
    required this.id,
    required this.orderCode,
    required this.category,
  });
  final String productName;
  final double orderPrice;
  final String id;
  final int quantity;
  final DateTime date;
  final String customerName;
  final String orderCode;
  final String category;
}

class OrderUpdateButtonTappedEvent extends OrderEvent {
  OrderUpdateButtonTappedEvent({
    required this.id,
    required this.productName,
    required this.orderPrice,
    required this.quantity,
    required this.date,
    required this.customerName,
    required this.orderCode,
    required this.category,
  });
  final String id;
  final String productName;
  final double orderPrice;
  final int quantity;
  final DateTime date;
  final String customerName;
  final String orderCode;
  final String category;  

}

class OrderDeleteButtonTappedEvent extends OrderEvent {
  OrderDeleteButtonTappedEvent({
    required this.id,
  });
  final String id;
} 
