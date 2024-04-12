import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:frontend_for_seller/models/seller.dart';
import 'package:frontend_for_seller/repositories/database_repository.dart';

part 'profile_edit_event.dart';
part 'profile_edit_state.dart';

class ProfileEditBloc extends Bloc<ProfileEditEvent, ProfileEditState> {
  ProfileEditBloc() : super(ProfileEditInitial()) {
    on<ProfileChangedEvent>((event, emit) {
      Seller seller = event.seller;
      if (seller.sellerName == "" ||
          seller.shopName == "" ||
          seller.address == "" ||
          seller.aadhar == "" ||
          seller.mobileNo == "" ||
          seller.subCatList == [] ||
          event.tagLine == "") {
        emit(const ProfileErrorState("Please fill all the fields"));
      }
    });
    on<ProfileSaveChanges>((event, emit) async {
      Seller seller = event.seller;
      if (seller.sellerName == "" ||
          seller.shopName == "" ||
          seller.address == "" ||
          seller.aadhar == "" ||
          seller.mobileNo == "" ||
          seller.subCatList == [] ||
          event.tagLine == "") {
        emit(const ProfileErrorState("Please fill all the fields"));
      }
      emit(ProfileLoadingState());
      List<String> subCatList =
          await DatabaseService().retrieveSubCategories(seller.subCatList);

      await DatabaseService().addSellerData(
        Seller(
            aadhar: seller.aadhar,
            address: seller.address,
            email: seller.email,
            mobileNo: seller.mobileNo,
            sellerName: seller.sellerName,
            shopName: seller.shopName,
            password: seller.password,
            subCatList: subCatList),
        tagLine: event.tagLine,
      );
      emit(ProfileUpdatedState());
    });
  }
}
