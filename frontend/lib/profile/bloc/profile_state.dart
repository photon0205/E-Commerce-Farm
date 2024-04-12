part of 'profile_bloc.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();
  
  @override
  List<Object> get props => [];
}

class ProfileInitial extends ProfileState {}

class ProfileEdit extends ProfileState {}

class History extends ProfileState {}

class Wishlist extends ProfileState {}

class Help extends ProfileState {}

class Rate extends ProfileState {}

class Feedback extends ProfileState {}

