part of 'home_bloc.dart';

abstract class HomeState extends Equatable {
  const HomeState();
  
  @override
  List<Object> get props => [];
}

class HomeInitial extends HomeState {}

class Home_Page extends HomeState {}

class ProfilePage extends HomeState {}

class AddProductPage extends HomeState {}


