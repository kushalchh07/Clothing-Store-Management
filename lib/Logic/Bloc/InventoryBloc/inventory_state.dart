part of 'inventory_bloc.dart';

@immutable
sealed class InventoryState {}

final class InventoryInitial extends InventoryState {}
class InventoryLoadingState extends InventoryState {}

class InventoryLoadedState extends InventoryState {
  final List<Inventory> inventory;
  InventoryLoadedState(this.inventory);
}

class InventoryErrorState extends InventoryState {
  final String message;
  InventoryErrorState(this.message);
}
final class InventoryDeletedActionState extends InventoryState {}
final class InventoryEditedActionState extends InventoryState {}
 final class InventoryAddedActionState extends InventoryState {}
 final class InventoryErrorActionState extends InventoryState {}