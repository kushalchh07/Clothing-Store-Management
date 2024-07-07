// ignore_for_file: unused_element

import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    on<CustomerLoadEvent>(_customerLoadEvent);
    on<CustomerDeleteButtonTappedEvent>(_customerDeleteButtonTappedEvent);
  }

  FutureOr<void> _customerAddButtonTappedEvent(
      CustomerAddButtonTappedEvent event, Emitter<CustomerState> emit) async {
    try {
      log("Inside the bloc");
      FirebaseFirestore _firestore = FirebaseFirestore.instance;

      await _firestore.collection('customers').doc(event.id).set({
        'name': event.name,
        'phone': event.phone,
        'email': event.email,
        'address': event.address,
      });

      log("Data Added");
      // showToast(
      //   "Customer Added",
      //   duration: Duration(seconds: 2),
      //   position: ToastPosition.bottom,
      //   backgroundColor: Colors.green,
      //   radius: 8.0,
      //   textStyle: TextStyle(color: Colors.white),
      // );
                     

      // emit(CustomerLoadedState([]));
    } on FirebaseException catch (e) {
      log("FirebaseException: ${e.message}");
      // showToast(
      //   e.message ?? "Unknown Firebase error",
      //   duration: Duration(seconds: 2),
      //   position: ToastPosition.bottom,
      //   backgroundColor: Colors.red,
      //   radius: 8.0,
      //   textStyle: TextStyle(color: Colors.white),
      // );
      emit(CustomerErrorState(e.message ?? "Unknown Firebase error"));
    } catch (e) {
      log("General Exception: $e");
      // showToast(
      //   "An error occurred: $e",
      //   duration: Duration(seconds: 2),
      //   position: ToastPosition.bottom,
      //   backgroundColor: Colors.red,
      //   radius: 8.0,
      //   textStyle: TextStyle(color: Colors.white),
      // );
      emit(CustomerErrorState("An error occurred: $e"));
    }
  }

  FutureOr<void> _customerLoadEvent(
      CustomerLoadEvent event, Emitter<CustomerState> emit) async {
    try {
      FirebaseFirestore _firestore = FirebaseFirestore.instance;
      final snapshot = await _firestore.collection('customers').get();
      final customers = snapshot.docs.map((doc) {
        return Customer.fromMap(doc.id, doc.data() as Map<String, dynamic>);
      }).toList();
      log("All the customers loaded");
      emit(CustomerLoadedState(customers));
    } catch (_) {
      emit(CustomerErrorState("An error occurred while loading customers"));
    }
  }

  Future<void> _customerDeleteButtonTappedEvent(
      CustomerDeleteButtonTappedEvent event,
      Emitter<CustomerState> emit) async {
    try {
      FirebaseFirestore _firestore = FirebaseFirestore.instance;

      await _firestore.collection('customers').doc(event.id).delete();
    } catch (e) {
      emit(CustomerErrorState("Failed to delete customer: $e"));
    }
  }
}
