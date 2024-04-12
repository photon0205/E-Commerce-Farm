part of 'new_product_bloc.dart';

abstract class NewProductState extends Equatable {
  const NewProductState();

  @override
  List<Object> get props => [];
}

class NewProductInitial extends NewProductState {}

class InvalidState extends NewProductState {}

class ValidState extends NewProductState {}

class ImageGetState extends NewProductState {
  final List<XFile>? img;

  const ImageGetState(this.img);
}

class LoadingState extends NewProductState {}

class AddedState extends NewProductState {}

class ErrorState extends NewProductState {
  final String errorMessage;

  const ErrorState(this.errorMessage);
}
