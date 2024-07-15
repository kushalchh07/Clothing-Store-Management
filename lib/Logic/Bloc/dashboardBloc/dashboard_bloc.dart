// ignore_for_file: empty_constructor_bodies, empty_catches

import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:nepstyle_management_system/services/crud_services.dart';

part 'dashboard_event.dart';
part 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  DashboardBloc() : super(DashboardInitial()) {
    on<DashboardLoadEvent>(_dashBoardLoadEvent);
  }
  CrudServices _crudServices = CrudServices();
  FutureOr<void> _dashBoardLoadEvent(
      DashboardLoadEvent event, Emitter<DashboardState> emit) async {
    try {
      emit(DashboardLoadingState());
 int categorycount = await _crudServices.getCategoryCount();
//  int purchasecount = await _crudServices.getPurchaseCount();
//  int salescount = await _crudServices.getSalesCount();
//  int ordercount = await _crudServices.getOrderCount();
 int productcount= await _crudServices.getProductsCount();
 int suppliercount = await _crudServices.getSuppliersCount();
 int customercount = await _crudServices.getCustomerCount();
      emit(DashboardLoadedState(
          categorycount: categorycount,
          // purchasecount: purchasecount,
          // salescount: salescount,
          // ordercount: ordercount,
          productcount: productcount,
          suppliercount: suppliercount,
          customercount: customercount));

    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }
}
