import 'package:bloc/bloc.dart';
import 'package:email_validator/email_validator.dart';
import 'package:equatable/equatable.dart';

part 'sign_up_event.dart';
part 'sign_up_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  SignUpBloc() : super(SignUpInitial()) {
    on<SignUpTextChangedEvent>((event, emit) {
      if (event.nameValue == '') {
        emit(const SignUpErrorState('Name is Required'));
      } else if (event.shopNameValue == '') {
        emit(SignUpInitial());
        emit(const SignUpErrorState('Shop Name is Required'));
      } else if (event.addressValue == '') {
        emit(SignUpInitial());
        emit(const SignUpErrorState('Address is Required'));
      } else if (event.aadharValue.length<12) {
        emit(SignUpInitial());
        emit(const SignUpErrorState('Aadhar No. is Required'));
      } else if (event.mobileNoValue.length<10) {
        emit(SignUpInitial());
        emit(const SignUpErrorState('Mobile No. is Required'));
      } else if (event.categories == []) {
        emit(SignUpInitial());
        emit(const SignUpErrorState('Please select at least one category'));
      } else if (EmailValidator.validate(event.emailValue) == false) {
        emit(SignUpInitial());
        emit(const SignUpErrorState('Enter Valid Email'));
      } else if (validatePassword(event.passwordValue) != null) {
        emit(SignUpInitial());
        emit( SignUpErrorState(validatePassword(event.passwordValue)!));
      } else if (event.passwordValue != event.confirmPassValue) {
        emit(SignUpInitial());
        emit(const SignUpErrorState('Password doesn\'t Match'));
      } else {
        emit(SignUpValidState());
      }
    });

    on<SignUpSubmittedEvent>((event, emit) {
      emit(SignUpLoadingState());
    });
    on<Logout>((event, emit) {
      emit(SignUpInitial());
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