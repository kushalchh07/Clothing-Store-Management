part of 'sales_bloc.dart';

@immutable
sealed class SalesEvent {}
class SalesLoadEvent extends SalesEvent{}

class SalesAddButtonTappedEvent extends SalesEvent{
  SalesAddButtonTappedEvent({
    required this.productName,
    required this.salesPrice,
    required this.date,
    required this.quantity,
    required this.customerName,
    required this.id,
    
  });
  final String productName;
  final double salesPrice;
  final String id;
  final int quantity;
  final DateTime date;
  final String customerName;
}

class SalesUpdateButtonTappedEvent extends SalesEvent{
  SalesUpdateButtonTappedEvent({
    required this.id,
    required this.productName,
 
    required this.salesPrice,
    required this.quantity,
    required this.date,
    required this.customerName,
  });
  final String id;
  final String productName;
  
  final double salesPrice;
  final String customerName;
  final int quantity;
  final DateTime date;
}

class SalesDeleteButtonTappedEvent extends SalesEvent{
  SalesDeleteButtonTappedEvent({
    required this.id,
  });
  final String id;
}