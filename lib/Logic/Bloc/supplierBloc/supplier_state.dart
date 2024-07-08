part of 'supplier_bloc.dart';

@immutable
sealed class SupplierState {}

final class SupplierInitialState extends SupplierState {}

class SupplierLoadingState extends SupplierState {}

class SupplierLoadedState extends SupplierState {
  final List<SupplierModel> suppliersList;
  // final List customers;

  SupplierLoadedState(this.suppliersList);
}

class SupplierErrorState extends SupplierState {
  final String message;
  SupplierErrorState(this.message);
}

