part of 'customer_bloc.dart';

@immutable
sealed class CustomerEvent {}
final class CustomerInitial extends CustomerEvent {}
final class CustomerAddButtonTappedEvent extends CustomerEvent {
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
  CustomerAddButtonTappedEvent({
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
