import 'package:bloc/bloc.dart';
import 'package:email_validator/email_validator.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend_for_seller/signup/bloc/sign_up_bloc.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitialState()) {
    on<LoginTextChangedEvent>((event, emit) {
      if (event.emailValue == "" ||
          EmailValidator.validate(event.emailValue) == false) {
        emit(const LoginErrorState("PLease enter a valid email address"));
      } else if (validatePassword(event.passwordValue) != null) {
        emit(LoginErrorState(validatePassword(event.passwordValue)!));
      } else {
        emit(LoginValidState());
      }
    });

    on<LoginSubmittedEvent>((event, emit) {
      emit(LoginLoadingState());
    });
    on<LogoutEvent>((event, emit) {
      emit(LoginInitialState());
    });
  }
}
