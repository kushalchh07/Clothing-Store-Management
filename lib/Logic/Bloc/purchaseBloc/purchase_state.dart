part of 'purchase_bloc.dart';

@immutable
sealed class PurchaseState {}

final class PurchaseInitialState extends PurchaseState {}

final class PurchaseLoadingState extends PurchaseState {}

final class PurchaseLoadErrorState extends PurchaseState {}

final class PurchaseLoadSuccessState extends PurchaseState {
  PurchaseLoadSuccessState({
    required this.purchases,
  });
  final List<PurchaseModel> purchases;
}


final class PurchaseDeletedActionState extends PurchaseState {}
final class PurchaseEditedActionState extends PurchaseState {}
 final class PurchaseAddedActionState extends PurchaseState {}
 final class PurchaseErrorActionState extends PurchaseState {}
