part of 'product_bloc.dart';

abstract class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object> get props => [];
}

class ProdChangedEvent extends ProductEvent {
  final Product prod;

  const ProdChangedEvent(this.prod);
}

class ProductSubmittedEvent extends ProductEvent {
  final Product prod;

  const ProductSubmittedEvent(this.prod);
}
