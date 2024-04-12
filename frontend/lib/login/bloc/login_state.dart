part of 'login_bloc.dart';

abstract class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object> get props => [];
}

class LoginInitialState extends LoginState {}

class LoginInvalidState extends LoginState {}

class LoginValidState extends LoginState {}

class LoginErrorState extends LoginState {
  final String errorMessage;

  const LoginErrorState(this.errorMessage);
  
}

class LoginLoadingState extends LoginState {}
