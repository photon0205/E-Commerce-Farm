import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/config/constants.dart';
import 'package:frontend/filteredProduct/filteredProduct.dart';
import 'package:frontend/services/local_storage.dart';

import '../../bloc/profile_bloc.dart';

class WishlistPage extends StatelessWidget {
  const WishlistPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        height: h,
        width: w,
        color: Colors.white,
        child: Column(
          children: [
            Container(
              alignment: Alignment.bottomCenter,
              color: Colors.black,
              height: h * 0.15,
              child: SizedBox(
                height: h * 0.1,
                child: Row(
                  children: [
                    const SizedBox(
                      width: 20,
                    ),
                    InkWell(
                      onTap: () {
                        BlocProvider.of<ProfileBloc>(context).add(BackEvent());
                      },
                      child: const Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    const Text(
                      "Wishlist",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: h * 0.77,
              width: w,
              child: GridView.builder(
                  itemCount: localStorage.wishListCat.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2),
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(17.0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => FilteredProductPage(
                                subCategory: localStorage.wishListCat[index],
                                wishlist: true),
                          ));
                        },
                        child: Container(
                          padding: const EdgeInsets.only(bottom: 15, left: 10),
                          alignment: Alignment.bottomLeft,
                          height: 159,
                          width: 159,
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Text(
                            localStorage.wishListCat[index],
                            style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.black),
                          ),
                        ),
                      ),
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
