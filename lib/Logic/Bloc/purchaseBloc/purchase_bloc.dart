// ignore_for_file: empty_catches

import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';
import 'package:nepstyle_management_system/models/purchase_model.dart';
import 'package:nepstyle_management_system/services/crud_services.dart';

part 'purchase_event.dart';
part 'purchase_state.dart';

class PurchaseBloc extends Bloc<PurchaseEvent, PurchaseState> {
  PurchaseBloc() : super(PurchaseInitialState()) {
    on<PurchaseLoadEvent>(_onPurchaseLoadEvent);
    on<PurchaseAddButtonTappedEvent>(_onPurchaseAddButtonTappedEvent);
    on<PurchaseUpdateButtonTappedEvent>(_onPurchaseUpdateButtonTappedEvent);
    on<PurchaseDeleteButtonTappedEvent>(_onPurchaseDeleteButtonTappedEvent);
  }
  CrudServices _crudServices = CrudServices();
  FutureOr<void> _onPurchaseLoadEvent(
      PurchaseLoadEvent event, Emitter<PurchaseState> emit) async {
    try {
      emit(PurchaseLoadingState());
      List<PurchaseModel> purchases = await _crudServices.getPurchases();
      emit(PurchaseLoadSuccessState(purchases: purchases));
    } catch (e) {
      log(e.toString());
      emit(PurchaseLoadErrorState());
    }
  }

  FutureOr<void> _onPurchaseAddButtonTappedEvent(
      PurchaseAddButtonTappedEvent event, Emitter<PurchaseState> emit) async {
    final perPrice = event.purPrice;
    final quantity = event.quantity;
    final totalAmount = perPrice * quantity;
    String formattedDate = DateFormat('yyyy-MM-dd').format(event.date);

    try {
      await _crudServices.addPurchases(
        event.id,
        formattedDate,
        event.supplierName,
        event.category,
        event.productName,
        event.quantity.toString(),
        event.purPrice.toString(),
        totalAmount.toString(),
        event.description,
      );
    } catch (e) {
      log("Bloc bhitra error");
      log(e.toString());
      rethrow;
    }
  }

  FutureOr<void> _onPurchaseUpdateButtonTappedEvent(
      PurchaseUpdateButtonTappedEvent event,
      Emitter<PurchaseState> emit) async {
    try {
      final perPrice = event.purPrice;
      final quantity = event.quantity;
      final totalAmount = perPrice * quantity;
      log("Inside Purchase Update bloc Supplier Name: ${event.supplierName}");
      String formattedDate = DateFormat('yyyy-MM-dd').format(event.date);
      await _crudServices.updatePurchases(
        event.id,
        formattedDate,
        event.supplierName,
        event.category,
        event.productName,
        event.quantity.toString(),
        event.purPrice.toString(),
        totalAmount.toString(),
        event.description,
      );
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  FutureOr<void> _onPurchaseDeleteButtonTappedEvent(
      PurchaseDeleteButtonTappedEvent event,
      Emitter<PurchaseState> emit) async {
    try {
      await _crudServices.deletePurchase(event.id);
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }
}
