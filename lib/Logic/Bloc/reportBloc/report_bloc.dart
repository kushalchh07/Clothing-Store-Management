// ignore_for_file: empty_catches

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:nepstyle_management_system/models/category_model.dart';
import 'package:nepstyle_management_system/models/stock_data_model.dart';
import 'package:nepstyle_management_system/services/crud_services.dart';

part 'report_event.dart';
part 'report_state.dart';

class ReportBloc extends Bloc<ReportEvent, ReportState> {
  ReportBloc() : super(ReportInitial()) {
    on<ReportLoadEvent>(_reportLoadEvent);
  }
  CrudServices _crudServices = CrudServices();
  FutureOr<void> _reportLoadEvent(
      ReportLoadEvent event, Emitter<ReportState> emit) async {
    try {
      await _crudServices.getStockData().then((value) {
        emit(ReportLoaded(report: value));
      });
    } catch (e) {
      emit(ReportError(message: e.toString()));
    }
  }
}
