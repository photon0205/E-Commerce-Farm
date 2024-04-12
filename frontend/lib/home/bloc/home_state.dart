part of 'home_bloc.dart';

abstract class HomeState extends Equatable {
  const HomeState();
  
  @override
  List<Object> get props => [];
}

class HomeInitial extends HomeState {}

class HomePageState extends HomeState {
  
}

class SHGPageState extends HomeState {

}


class ExplorePageState extends HomeState {

}

class ProfilePageState extends HomeState {

}
