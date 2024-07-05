// ignore_for_file: empty_catches

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:nepstyle_management_system/models/customerModel.dart';

part 'customer_event.dart';
part 'customer_state.dart';

class CustomerBloc extends Bloc<CustomerEvent, CustomerState> {
  CustomerBloc() : super(CustomerInitialState()) {
    on<CustomerAddButtonTappedEvent>(_customerAddButtonTappedEvent);
  }

  FutureOr<void> _customerAddButtonTappedEvent(CustomerAddButtonTappedEvent event, Emitter<CustomerState> emit) async{
    try{

    }
    catch(e){
      
    }
  }
}
