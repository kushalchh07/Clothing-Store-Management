// ignore_for_file: empty_constructor_bodies, empty_catches

import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:meta/meta.dart';

import '../../../constants/color/color.dart';
import '../../../constants/sharedPreferences/sharedPreferences.dart';
import '../../../services/auth_service.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitial()) {
    on<LoginTappedEvent>(_logginTappedEvent);
  }

  FutureOr<void> _logginTappedEvent(
      LoginTappedEvent event, Emitter<LoginState> emit) async {
    final email = event.email;
    final password = event.password;
    try {
      emit(LoginLoadingState());
      if (email == "" || password == "") {
        Fluttertoast.showToast(
          msg: 'Email or Password cannot be empty',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: whiteColor,
        );
        emit(LoginfailureState(message: "Email or Password cannot be empty"));
        return;
      }
      AuthService authService = AuthService();
      await authService.loginWithEmail(email, password).then((value) {
        if (value == "logged") {
          saveEmail(email);

          log("Account Logged in ");

          Fluttertoast.showToast(
            msg: 'Logged in  Sucessfully',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.green,
            textColor: whiteColor,
          );
          saveStatus(true);
          emit(LoginSuccessState());
        } else {
          Fluttertoast.showToast(
            msg: 'Invalid Credentials',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red,
            textColor: whiteColor,
          );
          emit(LoginfailureState(message: "Invalid Email and Password."));
        }
      });

      emit(LoginSuccessState());
    } catch (e) {
      log("Error occured during login $e");
      emit(LoginfailureState(message: e.toString()));
    }
  }
}
