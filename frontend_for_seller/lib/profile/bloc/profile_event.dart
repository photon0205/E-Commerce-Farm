part of 'profile_bloc.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object> get props => [];
}

class GotoProfileEdit extends ProfileEvent {}

class GotoOrdersPage extends ProfileEvent {}

class BackToProfilePage extends ProfileEvent{}
