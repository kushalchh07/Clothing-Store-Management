import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:nepstyle_management_system/services/auth_service.dart';

part 'signup_event.dart';
part 'signup_state.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  SignupBloc() : super(SignupInitial()) {
    on<SignupAddButtonTappedEvent>(_signUpButtonTappedEvent);
  }

  FutureOr<void> _signUpButtonTappedEvent(
      SignupAddButtonTappedEvent event, Emitter<SignupState> emit) async {
    emit(SignupLoadingState());
    try {
      await AuthService.createAccountWithEmail(
        event.email,
        event.password,
        event.name,
        event.phone,
        event.address,
        event.shopName,
      );
      emit(SignupLoadedState());
    } catch (e) {
      emit(SignupErrorState());
    }
  }
}
