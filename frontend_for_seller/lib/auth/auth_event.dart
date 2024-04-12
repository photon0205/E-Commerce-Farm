part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  @override
  List<Object> get props => [];
}

// When the user signing in with email and password this event is called and the [AuthRepository] is called to sign in the user
class SignInRequested extends AuthEvent {
  final String email;
  final String password;

  SignInRequested(this.email, this.password);
}

// When the user signing up with email and password this event is called and the [AuthRepository] is called to sign up the user
class SignUpRequested extends AuthEvent {
  final String name;
  final String shopName;
  final String email;
  final String aadhar;
  final String address;
  final String mobileNo;
  final String password;
  final List<String> subCategories;

  SignUpRequested(this.name, this.shopName, this.email, this.aadhar,
      this.address, this.mobileNo, this.password, this.subCategories);
}

// When the user signing in with google this event is called and the [AuthRepository] is called to sign in the user

// When the user signing out this event is called and the [AuthRepository] is called to sign out the user
class SignOutRequested extends AuthEvent {}
