import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';
import 'package:nepstyle_management_system/services/crud_services.dart';

import '../../../models/order_model.dart';

part 'order_event.dart';
part 'order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  OrderBloc() : super(OrderInitial()) {
    on<OrderLoadEvent>(_onOrderLoadEvent);
    on<OrderAddButtonTappedEvent>(_onOrderAddButtonTappedEvent);
    on<OrderUpdateButtonTappedEvent>(_onOrderUpdateButtonTappedEvent);
    on<OrderDeleteButtonTappedEvent>(_onOrderDeleteButtonTappedEvent);
  }
  final CrudServices _crudServices = CrudServices();
  FutureOr<void> _onOrderLoadEvent(
      OrderLoadEvent event, Emitter<OrderState> emit) async {
    try {
      emit(OrderLoadingState());
      List<OrderModel> orders = await _crudServices.getOrder();
      emit(OrderLoadSuccessState(orders: orders));
    } catch (e) {
      log(e.toString());
      emit(OrderLoadErrorState());
    }
  }

  FutureOr<void> _onOrderAddButtonTappedEvent(
      OrderAddButtonTappedEvent event, Emitter<OrderState> emit) async {
    try {
      final totalAmount = event.quantity * event.orderPrice;
      String formattedDate = DateFormat('yyyy-MM-dd').format(event.date);
      await _crudServices.addOrders(
        event.id,
        formattedDate,
        event.customerName,
        event.orderCode,
        event.productName,
        event.category,
        event.quantity.toString(),
        event.orderPrice.toString(),
        totalAmount.toString(),
      );

      emit(OrderAddedActionState());
    } catch (e) {
      log(e.toString());
      emit(OrderLoadErrorState());
    }
  }

  FutureOr<void> _onOrderUpdateButtonTappedEvent(
      OrderUpdateButtonTappedEvent event, Emitter<OrderState> emit) async {
    try {
      final totalAmount = event.quantity * event.orderPrice;
      String formattedDate = DateFormat('yyyy-MM-dd').format(event.date);
      await _crudServices.updateOrder(
        event.id,
        formattedDate,
        event.customerName,
        event.orderCode,
        event.productName,
        event.category,
        event.quantity.toString(),
        event.orderPrice.toString(),
        totalAmount.toString(),
      );

      emit(OrderEditedActionState());
    } catch (e) {
      log(e.toString());
      emit(OrderLoadErrorState());
    }
  }

  FutureOr<void> _onOrderDeleteButtonTappedEvent(
      OrderDeleteButtonTappedEvent event, Emitter<OrderState> emit) async {
    try {
      await _crudServices.deleteOrder(event.id);
      emit(OrderDeletedActionState());
    } catch (e) {
      log(e.toString());
      emit(OrderLoadErrorState());
    }
  }
}
