part of 'sign_up_bloc.dart';

abstract class SignUpEvent extends Equatable {
  const SignUpEvent();

  @override
  List<Object> get props => [];
}

class SignUpTextChangedEvent extends SignUpEvent {
  final String emailValue;
  final String shopNameValue;
  final String addressValue;
  final String aadharValue;
  final String passwordValue;
  final String mobileNoValue;
  final String nameValue;
  final String confirmPassValue;
  final List<String> categories;

  const SignUpTextChangedEvent(
      this.emailValue,
      this.passwordValue,
      this.nameValue,
      this.confirmPassValue,
      this.shopNameValue,
      this.addressValue,
      this.aadharValue,
      this.mobileNoValue,
      this.categories);
}

class SignUpSubmittedEvent extends SignUpEvent {
  final String email;
  final String password;
  final String name;
  final String shopName;
  final String address;
  final String aadhar;
  final String mobileNo;
  final List<String> categories;

  const SignUpSubmittedEvent(this.email, this.password, this.name,
      this.shopName, this.address, this.aadhar, this.mobileNo, this.categories);
}

class Logout extends SignUpEvent {}
