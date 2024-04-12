import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:frontend_for_seller/models/product.dart';
import 'package:frontend_for_seller/repositories/database_impl.dart';
import 'dart:io';

import '../../models/seller.dart';

part 'new_product_event.dart';
part 'new_product_state.dart';

class NewProductBloc extends Bloc<NewProductEvent, NewProductState> {
  NewProductBloc() : super(NewProductInitial()) {
    on<TextChanged>((event, emit) {
      if (event.prodName == "") {
        emit(const ErrorState("Product Name is Required"));
      } else if (event.price == "") {
        emit(const ErrorState("Price is Required"));
      } else if (event.description == "") {
        emit(const ErrorState("About Product is Required"));
      } else {
        emit(ValidState());
      }
    });
    on<ReloadEvent>((event, emit) {
      image = null;
      emit(NewProductInitial());
    });
    on<ImageReceived>((event, emit) {
      if (event.imgFile != null) {
        image = event.imgFile;
        emit(ImageGetState(event.imgFile));
      } else {
        emit(const ErrorState("Please Upload Image"));
      }
    });
    on<SubmittedEvent>((event, emit) async {
      if (event.prodName == "") {
        emit(const ErrorState("Product Name is Required"));
      } else if (event.price == "") {
        emit(const ErrorState("Price is Required"));
      } else if (event.category == "") {
        emit(const ErrorState("Categorey is Required"));
      } else if (event.description == "") {
        emit(const ErrorState("About Product is Required"));
      } else if (image == null) {
        emit(const ErrorState("Please add Image"));
      } else {
        emit(LoadingState());
        Seller seller = await DatabaseRepositoryImpl().getSellerData();
        List<String> urls = [];

        final storageRef = FirebaseStorage.instance.ref();
        int i = 0;
        if (image != null) {
          for (var element in image!) {
            String fileName =
                "${DateTime.now().millisecondsSinceEpoch}${event.prodName}$i.jpg";
            Reference ref = storageRef.child("images").child(fileName);
            UploadTask uploadTask = ref.putFile(File(element.path));
            await uploadTask.whenComplete(() async {
              var url = await uploadTask.snapshot.ref.getDownloadURL();
              urls.add(url);
            });
            i = i + 1;
          }
        }
        Product prod = Product(
            name: event.prodName,
            description: event.description,
            type: event.type,
            price: event.price,
            address: seller.address,
            category: event.category,
            seller: seller.shopName,
            imgUrls: urls,
            open: true);
        DatabaseRepositoryImpl().addProductData(prod);
        emit(AddedState());
      }
    });
  }
  List<XFile>? image;
}
