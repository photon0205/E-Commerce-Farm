part of 'profile_edit_bloc.dart';

abstract class ProfileEditEvent extends Equatable {
  const ProfileEditEvent();

  @override
  List<Object> get props => [];
}

class ProfileChangedEvent extends ProfileEditEvent {
  final Seller seller;
  final String tagLine;

  const ProfileChangedEvent(this.seller, this.tagLine);
}

class ProfileSaveChanges extends ProfileEditEvent {
  final Seller seller;
  final String tagLine;

  const ProfileSaveChanges(this.seller, this.tagLine);
}
