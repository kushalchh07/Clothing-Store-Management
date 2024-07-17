part of 'signup_bloc.dart';

@immutable
sealed class SignupState {}

final class SignupInitial extends SignupState {}
final class SignupLoadingState extends SignupState {}

final class SignupLoadedState extends SignupState {
 
}
final class SignupErrorState extends SignupState {}
