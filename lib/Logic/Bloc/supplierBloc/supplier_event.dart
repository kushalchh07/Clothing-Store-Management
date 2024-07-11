part of 'supplier_bloc.dart';

@immutable
sealed class SupplierEvent {}

final class SupplierInitial extends SupplierEvent {}

final class SupplierLoadEvent extends SupplierEvent {}

final class SupplierAddButtonTappedEvent extends SupplierEvent {
  final String name;
  final String address;
  final String phone;
  final String email;
  final String id;
  // final String gst;
  // final String pan;
  // final String city;
  // final String state;
  // final String pincode;
  SupplierAddButtonTappedEvent({
    required this.name,
    required this.address,
    required this.phone,
    required this.email,
    required this.id,
    // required this.gst,
    // required this.pan,
    // required this.city,
    // required this.state,
    // required this.pincode,
  });
}

class SupplierUpdateButtonTappedEvent extends SupplierEvent {
  String id;
  String name;
  String address;
  String phone;
  String email;

  SupplierUpdateButtonTappedEvent({
    required this.id,
    required this.name,
    required this.address,
    required this.phone,
    required this.email,
  });
}

class SupplierDeleteButtonTappedEvent extends SupplierEvent {
  final String id;
  SupplierDeleteButtonTappedEvent({required this.id});
}
