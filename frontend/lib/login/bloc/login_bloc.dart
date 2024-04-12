import 'package:bloc/bloc.dart';
import 'package:email_validator/email_validator.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitialState()) {
    on<LoginTextChangedEvent>((event, emit) {
      if (event.emailValue == "" ||
          EmailValidator.validate(event.emailValue) == false) {
        emit(const LoginErrorState("PLease enter a valid email address"));
      } else if (validatePassword(event.passwordValue)!=null) {
        emit( LoginErrorState(validatePassword(event.passwordValue)!));
      } else {
        emit(LoginValidState());
      }
    });

    on<LoginSubmittedEvent>((event, emit) {
      emit(LoginLoadingState());
    });
  }
}
    String? validatePassword(String value) {
    RegExp regex =
        RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
    if (value.isEmpty) {
      return 'Please enter password';
    } else {
      if (!regex.hasMatch(value)) {
        return 'Enter valid password';
      } else {
        return null;
      }
    }
  }
