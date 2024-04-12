part of 'product_bloc.dart';

abstract class ProductState extends Equatable {
  const ProductState();

  @override
  List<Object> get props => [];
}

class ProductInitial extends ProductState {}

class ValueChanged extends ProductState {
  final Product prod;

  const ValueChanged(this.prod);
}

class ErrorState extends ProductState {
  final String error;

  const ErrorState(this.error);
}

class LoadingState extends ProductState {}

class ProdUpdatedState extends ProductState {}
