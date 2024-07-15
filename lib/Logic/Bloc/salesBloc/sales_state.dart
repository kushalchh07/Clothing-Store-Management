part of 'sales_bloc.dart';

@immutable
sealed class SalesState {}

final class SalesInitial extends SalesState {}
class SalesLoadingState extends SalesState {}

final class SalesLoadErrorState extends SalesState {}

final class SalesLoadSuccessState extends SalesState {
  SalesLoadSuccessState({
    required this.sales,
  });
  final List<SalesModel> sales;
}
final class SaleDeletedActionState extends SalesState {}
final class SaleEditedActionState extends SalesState {}
 final class SaleAddedActionState extends SalesState {}
 final class SaleErrorActionState extends SalesState {}