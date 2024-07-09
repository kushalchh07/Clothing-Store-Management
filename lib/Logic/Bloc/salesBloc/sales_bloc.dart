// ignore_for_file: empty_catches

import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';
import 'package:nepstyle_management_system/models/sales_model.dart';
import 'package:nepstyle_management_system/services/crud_services.dart';

part 'sales_event.dart';
part 'sales_state.dart';

class SalesBloc extends Bloc<SalesEvent, SalesState> {
  SalesBloc() : super(SalesInitial()) {
    on<SalesLoadEvent>(_onSalesLoadEvent);
    on<SalesAddButtonTappedEvent>(_onSalesAddButtonTappedEvent);
    on<SalesUpdateButtonTappedEvent>(_onSalesUpdateButtonTappedEvent);
    on<SalesDeleteButtonTappedEvent>(_onSalesDeleteButtonTappedEvent);
  }
  final CrudServices _crudServices = CrudServices();
  FutureOr<void> _onSalesLoadEvent(
      SalesLoadEvent event, Emitter<SalesState> emit) async {
    try {
      emit(SalesLoadingState());
      List<SalesModel> sales = await _crudServices.getSales();
      emit(SalesLoadSuccessState(sales: sales));
    } catch (e) {
      log(e.toString());
      emit(SalesLoadErrorState());
    }
  }

  FutureOr<void> _onSalesAddButtonTappedEvent(
      SalesAddButtonTappedEvent event, Emitter<SalesState> emit) async {
    try {
      final perprice = event.salesPrice;
      final quantity = event.quantity;
      final totalAmount = perprice * quantity;
      String formattedDate = DateFormat('yyyy-MM-dd').format(event.date);
      await _crudServices.addSales(
        event.id,
        formattedDate,
        event.customerName,
        event.category,
        event.productName,
        event.quantity.toString(),
        event.salesPrice.toString(),
        totalAmount.toString(),
      );
    } catch (e) {
      log(e.toString());
      emit(SalesLoadErrorState());
    }
  }

  FutureOr<void> _onSalesUpdateButtonTappedEvent(
      SalesUpdateButtonTappedEvent event, Emitter<SalesState> emit) async {}

  FutureOr<void> _onSalesDeleteButtonTappedEvent(
      SalesDeleteButtonTappedEvent event, Emitter<SalesState> emit) async {
    try {
      await _crudServices.deleteSales(event.id);
    } catch (e) {
      log(e.toString());
      emit(SalesLoadErrorState());
    }
  }
}
