// ignore_for_file: empty_constructor_bodies, empty_catches

import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:nepstyle_management_system/services/crud_services.dart';

import '../../../models/supplier_model.dart';
import '../../../pages/Home/supplier.dart';

part 'supplier_event.dart';
part 'supplier_state.dart';

class SupplierBloc extends Bloc<SupplierEvent, SupplierState> {
  SupplierBloc() : super(SupplierInitialState()) {
    on<SupplierLoadEvent>(_supplierLoadEvent);
    on<SupplierAddButtonTappedEvent>(_supplierAddButtonTappedEvent);
    on<SupplierDeleteButtonTappedEvent>(_supplierDeleteButtonTappedEvent);
    on<SupplierUpdateButtonTappedEvent>(_supplierUpdateButtonTappedEvent);
  }
  CrudServices _crudServices = CrudServices();
  FutureOr<void> _supplierLoadEvent(
      SupplierLoadEvent event, Emitter<SupplierState> emit) async {
    try {
      List<SupplierModel> suppliers = await _crudServices.getSuppliers();
      print(suppliers);
      emit(SupplierLoadedState(suppliers));
    } catch (e) {
      print(e);
      log(e.toString());
      rethrow;
    }
  }

  FutureOr<void> _supplierAddButtonTappedEvent(
      SupplierAddButtonTappedEvent event, Emitter<SupplierState> emit) async {
    try {
      await _crudServices.addSuppliers(
        event.id,
        event.name,
        event.address,
        event.phone,
        event.email,
      );

      emit(SupplierAddedActionState());
      log("Add supplier Added");
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  FutureOr<void> _supplierDeleteButtonTappedEvent(
      SupplierDeleteButtonTappedEvent event,
      Emitter<SupplierState> emit) async {
    try {
      await _crudServices.deleteSupplier(event.id);
      log("supplier deleted");
      emit(SupplierDeletedActionState());
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  FutureOr<void> _supplierUpdateButtonTappedEvent(
      SupplierUpdateButtonTappedEvent event,
      Emitter<SupplierState> emit) async {
    try {
      await _crudServices.updateSuppliers(
          event.id, event.name, event.address, event.phone, event.email);
          emit(SupplierEditedActionState());
      log("supplier updated");
    } catch (e) {
      log("U[pdate failed]");
    }
  }
}
