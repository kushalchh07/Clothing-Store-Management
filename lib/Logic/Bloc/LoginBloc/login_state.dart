part of 'login_bloc.dart';

@immutable
sealed class LoginState {}

final class LoginInitial extends LoginState {}

final class LoginLoadingState extends LoginState {}

final class LoginSuccessState extends LoginState {}

class LoginfailureState extends LoginState {
  String message;

  LoginfailureState({required this.message});
}
