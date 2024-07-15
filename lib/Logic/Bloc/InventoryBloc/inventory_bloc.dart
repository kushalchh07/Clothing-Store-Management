import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:firebase_storage/firebase_storage.dart';
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
    on<InventoryUpdateButtonTappedEvent>(_inventoryUpdateButtonTappedEvent);
  }
  CrudServices _crudServices = CrudServices();
  FutureOr<void> _inventoryLoadEvent(
      InventoryLoadEvent event, Emitter<InventoryState> emit) async {
    try {
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
      emit(InventoryAddedActionState());
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
      await _crudServices.deleteProduct(event.id);
      emit(InventoryDeletedActionState());
      log("Product Deleted");
    } catch (e) {
      log("item delete failed");
    }
  }

  FutureOr<void> _inventoryUpdateButtonTappedEvent(
      InventoryUpdateButtonTappedEvent event,
      Emitter<InventoryState> emit) async {
    try {
      await _crudServices.updateProducts(
        event.id,
        event.name,
        event.description,
        event.purPrice,
        event.sellingPrice,
        event.quantity,
        event.productImage,
        event.category,
      );
      emit(InventoryEditedActionState());
      log("Product Updated");
    } catch (e) {
      log(e.toString());
    }
  }
}
