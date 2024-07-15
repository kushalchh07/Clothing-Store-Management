part of 'customer_bloc.dart';

@immutable
sealed class CustomerState {}

class CustomerInitialState extends CustomerState {}

class CustomerLoadingState extends CustomerState {}

class CustomerLoadedState extends CustomerState {
  final List<Customer> customers;
  // final List customers;

  CustomerLoadedState(this.customers);
}

class CustomerErrorState extends CustomerState {
  final String message;
  CustomerErrorState(this.message);
}


final class CustomerDeletedActionState extends CustomerState {}
final class CustomerEditedActionState extends CustomerState {}
 final class CustomerAddedActionState extends CustomerState {}
 final class CustomerErrorActionState extends CustomerState {}