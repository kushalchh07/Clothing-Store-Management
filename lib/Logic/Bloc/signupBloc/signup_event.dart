part of 'signup_bloc.dart';

@immutable
sealed class SignupEvent {}

final class SignupLoadEvent extends SignupEvent {}

final class SignupAddButtonTappedEvent extends SignupEvent {
  final String id;
  final String name;
  final String address;
  final String phone;
  final String email;
  final String shopName;
  final String shopAddress;
  final String password;
  SignupAddButtonTappedEvent(
      {required this.id,
      required this.name,
      required this.address,
      required this.phone,
      required this.email,
      required this.shopName,
      required this.shopAddress,
      required this.  password});
}
