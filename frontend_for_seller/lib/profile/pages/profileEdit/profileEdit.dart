import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend_for_seller/profile/bloc/profile_bloc.dart';
import 'package:frontend_for_seller/profile/pages/profileEdit/bloc/profile_edit_bloc.dart';

import '../../../components/multiSelect/multiSelect.dart';
import '../../../models/seller.dart';

class ProfileEdit extends StatefulWidget {
  const ProfileEdit({Key? key, required this.seller, required this.categories})
      : super(key: key);
  final Seller seller;
  final List<String> categories;
  @override
  State<ProfileEdit> createState() => _ProfileEditState();
}

class _ProfileEditState extends State<ProfileEdit> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController shopNameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController aadharController = TextEditingController();
  final TextEditingController numberController = TextEditingController();
  final TextEditingController taglineController = TextEditingController();
  @override
  void initState() {
    nameController.text = widget.seller.sellerName;
    shopNameController.text = widget.seller.shopName;
    addressController.text = widget.seller.address;
    aadharController.text = widget.seller.aadhar;
    numberController.text = widget.seller.mobileNo;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    List<String> selectedCategories = widget.seller.category!;
    return BlocListener<ProfileEditBloc, ProfileEditState>(
      listener: (context, state) {
        if (state is ProfileErrorState) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(state.error)));
        }
      },
      child: SizedBox(
        height: h,
        width: w,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(35, 0, 0, 15),
              alignment: Alignment.bottomLeft,
              height: 110,
              color: Colors.black,
              child: Row(
                children: [
                  IconButton(
                      onPressed: () {
                        BlocProvider.of<ProfileBloc>(context)
                            .add(BackToProfilePage());
                      },
                      icon: const Icon(Icons.arrow_back_ios,
                          color: Colors.white)),
                  const Text(
                    'PROFILE',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            BlocBuilder<ProfileEditBloc, ProfileEditState>(
                builder: (context, state) {
              if (state is ProfileLoadingState) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              return SizedBox(
                  height: h * 0.75,
                  child: Container(
                    padding: const EdgeInsets.only(left: 45, right: 40),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 30,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: TextField(
                            onChanged: (value) async {
                              BlocProvider.of<ProfileEditBloc>(context)
                                  .add(ProfileChangedEvent(
                                      Seller(
                                        aadhar: aadharController.text,
                                        address: addressController.text,
                                        email: widget.seller.email,
                                        sellerName: nameController.text,
                                        mobileNo: numberController.text,
                                        password: widget.seller.password,
                                        shopName: shopNameController.text,
                                        subCatList: selectedCategories,
                                      ),
                                      taglineController.text));
                            },
                            controller: nameController,
                            style: const TextStyle(
                                fontSize: 18, color: Colors.black),
                            decoration: const InputDecoration(
                              hintText: "Name",
                              contentPadding: EdgeInsets.only(left: 5, top: 8),
                              enabledBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(width: 4, color: Colors.black),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  width: 4,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: TextField(
                            onChanged: (value) async {
                              BlocProvider.of<ProfileEditBloc>(context)
                                  .add(ProfileChangedEvent(
                                      Seller(
                                        aadhar: aadharController.text,
                                        address: addressController.text,
                                        email: widget.seller.email,
                                        sellerName: nameController.text,
                                        mobileNo: numberController.text,
                                        password: widget.seller.password,
                                        shopName: shopNameController.text,
                                        subCatList: selectedCategories,
                                      ),
                                      taglineController.text));
                            },
                            controller: shopNameController,
                            style: const TextStyle(
                                fontSize: 18, color: Colors.black),
                            decoration: const InputDecoration(
                              hintText: "Shop Name",
                              contentPadding: EdgeInsets.only(left: 5, top: 8),
                              enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                width: 4,
                                color: Colors.black,
                              )),
                              focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                width: 4,
                                color: Colors.black,
                              )),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: TextField(
                            onChanged: (value) async {
                              BlocProvider.of<ProfileEditBloc>(context)
                                  .add(ProfileChangedEvent(
                                      Seller(
                                        aadhar: aadharController.text,
                                        address: addressController.text,
                                        email: widget.seller.email,
                                        sellerName: nameController.text,
                                        mobileNo: numberController.text,
                                        password: widget.seller.password,
                                        shopName: shopNameController.text,
                                        subCatList: selectedCategories,
                                      ),
                                      taglineController.text));
                            },
                            controller: addressController,
                            style: const TextStyle(
                                fontSize: 18, color: Colors.black),
                            decoration: const InputDecoration(
                              hintText: "Address",
                              contentPadding: EdgeInsets.only(left: 5, top: 8),
                              enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                width: 4,
                                color: Colors.black,
                              )),
                              focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                width: 4,
                                color: Colors.black,
                              )),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: TextField(
                            onChanged: (value) async {
                              BlocProvider.of<ProfileEditBloc>(context)
                                  .add(ProfileChangedEvent(
                                      Seller(
                                        aadhar: aadharController.text,
                                        address: addressController.text,
                                        email: widget.seller.email,
                                        sellerName: nameController.text,
                                        mobileNo: numberController.text,
                                        password: widget.seller.password,
                                        shopName: shopNameController.text,
                                        subCatList: selectedCategories,
                                      ),
                                      taglineController.text));
                            },
                            controller: aadharController,
                            style: const TextStyle(
                                fontSize: 18, color: Colors.black),
                            decoration: const InputDecoration(
                              hintText: "Aadhar",
                              contentPadding: EdgeInsets.only(left: 5, top: 8),
                              enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                width: 4,
                                color: Colors.black,
                              )),
                              focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                width: 4,
                                color: Colors.black,
                              )),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: TextField(
                            onChanged: (value) async {
                              BlocProvider.of<ProfileEditBloc>(context)
                                  .add(ProfileChangedEvent(
                                      Seller(
                                        aadhar: aadharController.text,
                                        address: addressController.text,
                                        email: widget.seller.email,
                                        sellerName: nameController.text,
                                        mobileNo: numberController.text,
                                        password: widget.seller.password,
                                        shopName: shopNameController.text,
                                        subCatList: selectedCategories,
                                      ),
                                      taglineController.text));
                            },
                            controller: numberController,
                            style: const TextStyle(
                                fontSize: 18, color: Colors.black),
                            decoration: const InputDecoration(
                              hintText: "Mobile No.",
                              contentPadding: EdgeInsets.only(left: 5, top: 8),
                              enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                width: 4,
                                color: Colors.black,
                              )),
                              focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                width: 4,
                                color: Colors.black,
                              )),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 50,
                          child: MultiSelect(
                            choices: widget.categories,
                            selected: selectedCategories,
                          ),
                        ),
                        TextField(
                          onChanged: (value) async {
                            BlocProvider.of<ProfileEditBloc>(context)
                                .add(ProfileChangedEvent(
                                    Seller(
                                      aadhar: aadharController.text,
                                      address: addressController.text,
                                      email: widget.seller.email,
                                      sellerName: nameController.text,
                                      mobileNo: numberController.text,
                                      password: widget.seller.password,
                                      shopName: shopNameController.text,
                                      subCatList: selectedCategories,
                                    ),
                                    taglineController.text));
                          },
                          controller: taglineController,
                          style: const TextStyle(
                              fontSize: 18, color: Colors.black),
                          decoration: const InputDecoration(
                            hintText: "Shop Tagline",
                            contentPadding: EdgeInsets.only(left: 5, top: 8),
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                              width: 4,
                              color: Colors.black,
                            )),
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                              width: 4,
                              color: Colors.black,
                            )),
                          ),
                        ),
                        const SizedBox(
                          height: 50,
                        ),
                        InkWell(
                          onTap: () {
                            BlocProvider.of<ProfileEditBloc>(context)
                                .add(ProfileSaveChanges(
                                    Seller(
                                      aadhar: aadharController.text,
                                      address: addressController.text,
                                      email: widget.seller.email,
                                      sellerName: nameController.text,
                                      mobileNo: numberController.text,
                                      password: widget.seller.password,
                                      shopName: shopNameController.text,
                                      subCatList: selectedCategories,
                                    ),
                                    taglineController.text));
                          },
                          child: Container(
                            alignment: Alignment.center,
                            height: 50,
                            width: 200,
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: const Text(
                              'Save Changes',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 19,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ));
            }),
          ],
        ),
      ),
    );
  }
}
