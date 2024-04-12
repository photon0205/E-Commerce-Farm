part of 'sign_up_bloc.dart';

abstract class SignUpState extends Equatable {
  const SignUpState();

  @override
  List<Object> get props => [];
}

class SignUpInitialState extends SignUpState {}

class SignUpInvalidState extends SignUpState {}

class SignUpValidState extends SignUpState {}

class SignUpErrorState extends SignUpState {
  final String errorMessage;

  const SignUpErrorState(this.errorMessage);
  
}

class SignUpLoadingState extends SignUpState {}
