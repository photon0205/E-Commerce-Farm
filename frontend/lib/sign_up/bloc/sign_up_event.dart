part of 'sign_up_bloc.dart';

abstract class SignUpEvent extends Equatable {
  const SignUpEvent();

  @override
  List<Object> get props => [];
}

class SignUpTextChangedEvent extends SignUpEvent{
  final String emailValue;
  final String passwordValue;
  final String confirmPasswordValue;
  final String nameValue;


  const SignUpTextChangedEvent(this.emailValue, this.passwordValue, this.nameValue,  this.confirmPasswordValue);
  
}

class SignUpSubmittedEvent extends SignUpEvent{
  final String email;
  final String password;
  final String name;

  const SignUpSubmittedEvent(this.email, this.password, this.name,);

}
