// ignore_for_file: empty_catches

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:nepstyle_management_system/models/customerModel.dart';
import 'package:nepstyle_management_system/services/crud_services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:oktoast/oktoast.dart';
part 'customer_event.dart';
part 'customer_state.dart';

class CustomerBloc extends Bloc<CustomerEvent, CustomerState> {
  CustomerBloc() : super(CustomerInitialState()) {
    on<CustomerAddButtonTappedEvent>(_customerAddButtonTappedEvent);
  }

  FutureOr<void> _customerAddButtonTappedEvent(
      CustomerAddButtonTappedEvent event, Emitter<CustomerState> emit) async {
    try {
      CrudServices _crudService = CrudServices();
      await _crudService
          .addCustomer(event.name, event.address, event.phone, event.email)
          .then((value) {
        if (value == "Data added") {
          //   Fluttertoast.showToast(
          //     msg: "Customer Added",
          //     toastLength: Toast.LENGTH_SHORT,
          //     gravity: ToastGravity.BOTTOM,
          //     timeInSecForIosWeb: 1,
          //     backgroundColor: Colors.green,
          //     textColor: Colors.white,
          //     fontSize: 16.0,
          //   );
          showToast(
            "Customer Added",
            duration: Duration(seconds: 2),
            position: ToastPosition.bottom,
            backgroundColor: Colors.green,
            radius: 8.0,
            textStyle: TextStyle(color: Colors.white),
          );
          emit(CustomerLoadedState([]));
        } else {
          // Fluttertoast.showToast(
          //   msg: value,
          //   toastLength: Toast.LENGTH_SHORT,
          //   gravity: ToastGravity.BOTTOM,
          //   timeInSecForIosWeb: 1,
          //   backgroundColor: Colors.red,
          //   textColor: Colors.white,
          //   fontSize: 16.0,
          // );
          showToast(
            value,
            duration: Duration(seconds: 2),
            position: ToastPosition.bottom,
            backgroundColor: Colors.red,
            radius: 8.0,
            textStyle: TextStyle(color: Colors.white),
          );
          emit(CustomerErrorState(value));
        }
      });
    } catch (e) {}
  }
}
