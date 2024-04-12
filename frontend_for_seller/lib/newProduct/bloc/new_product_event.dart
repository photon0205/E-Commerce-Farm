part of 'new_product_bloc.dart';

abstract class NewProductEvent extends Equatable {
  const NewProductEvent();

  @override
  List<Object> get props => [];
}

class ReloadEvent extends NewProductEvent{
  
}

class TextChanged extends NewProductEvent {
  final String prodName;
  final String description;
  final String price;
  final String type;

  const TextChanged(this.prodName, this.price, this.type, this.description);
}

class ImageReceived extends NewProductEvent {
  final List<XFile>? imgFile;

  const ImageReceived(this.imgFile);
}

class SubmittedEvent extends NewProductEvent{
  final String prodName;
  final String description;
  final String price;
  final String type;
  final String category;

  const SubmittedEvent( this.prodName, this.description, this.price, this.type, this.category);
}