import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:frontend_for_seller/models/product.dart';
import 'package:frontend_for_seller/repositories/database_repository.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  ProductBloc() : super(ProductInitial()) {
    on<ProdChangedEvent>((event, emit) {
      Product product = event.prod;
      if (product.name == "" ||
          product.description == "" ||
          product.price == "") {
        emit(const ErrorState("Please Fill All The Fields"));
      }
    });
    on<ProductSubmittedEvent>((event, emit) async {
      Product product = event.prod;
      if (product.name == "" ||
          product.description == "" ||
          product.price == "") {
        emit(const ErrorState("Please Fill All The Fields"));
      }
      emit(LoadingState());
      await DatabaseService().updateProduct(product);
      emit(ProdUpdatedState());
    });
  }
}
