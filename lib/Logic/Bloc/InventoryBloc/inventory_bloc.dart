import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:nepstyle_management_system/services/crud_services.dart';

import '../../../models/inventory_model.dart';

part 'inventory_event.dart';
part 'inventory_state.dart';

class InventoryBloc extends Bloc<InventoryEvent, InventoryState> {
  InventoryBloc() : super(InventoryInitial()) {
    on<InventoryLoadEvent>(_inventoryLoadEvent);
    on<InventoryAddButtonTappedEvent>(_inventoryAddButtonTappedEvent);
    on<InventoryDeleteButtonTappedEvent>(_inventoryDeleteButtonTappedEvent);
  }

  FutureOr<void> _inventoryLoadEvent(
      InventoryLoadEvent event, Emitter<InventoryState> emit) async {
    try {
      CrudServices _crudServices = CrudServices();
      List<Inventory> inventoryList = await _crudServices.getInventory();
      log(inventoryList.toString());
      emit(InventoryLoadedState(inventoryList));
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  FutureOr<void> _inventoryAddButtonTappedEvent(
      InventoryAddButtonTappedEvent event, Emitter<InventoryState> emit) async {
    CrudServices _crudServices = CrudServices();
    try {
      await _crudServices.addProducts(
        event.id,
        event.name,
        event.description,
        event.purPrice,
        event.sellingPrice,
        event.quantity,
        event.productImage,
        event.category,
      );
      log("Add products Added");
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  FutureOr<void> _inventoryDeleteButtonTappedEvent(
      InventoryDeleteButtonTappedEvent event,
      Emitter<InventoryState> emit) async {
    try {
      CrudServices _crudService = CrudServices();
      await _crudService.deleteProduct(event.id);
      log("Product Deleted");
    } catch (e) {}
  }
}
