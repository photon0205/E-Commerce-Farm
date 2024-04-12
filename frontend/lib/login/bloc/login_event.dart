part of 'login_bloc.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object> get props => [];
}

class LoginTextChangedEvent extends LoginEvent {
  final String emailValue;
  final String passwordValue;

  const LoginTextChangedEvent(this.emailValue, this.passwordValue);
}

class LoginSubmittedEvent extends LoginEvent {
  final String email;
  final String password;

  const LoginSubmittedEvent(this.email, this.password);
  
  
}
