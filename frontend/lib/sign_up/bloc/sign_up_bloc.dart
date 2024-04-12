import 'package:bloc/bloc.dart';
import 'package:email_validator/email_validator.dart';
import 'package:equatable/equatable.dart';

part 'sign_up_event.dart';
part 'sign_up_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  SignUpBloc() : super(SignUpInitialState()) {
    on<SignUpTextChangedEvent>((event, emit) {
       
      if (event.nameValue == "") {
        emit(const SignUpErrorState("PLease enter a valid Name"));
      } else 
      if (EmailValidator.validate(event.emailValue) == false) {
        emit(const SignUpErrorState("PLease enter a valid email address"));
      } else
      if (event.passwordValue.length < 8) {
        emit(const SignUpErrorState("Password must be at least 8 characters"));
      } else 
      if (event.confirmPasswordValue!=event.passwordValue) {
        emit(const SignUpErrorState("Password doesn't match"));
      } else 
      {
        emit(SignUpValidState());
      }
    });
    on<SignUpSubmittedEvent>((event, emit) {
      emit(SignUpLoadingState());
    });
  }
}
