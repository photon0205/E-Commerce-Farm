import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend_for_seller/auth/auth_bloc.dart';
import 'package:frontend_for_seller/constants/appColor.dart';
import 'package:frontend_for_seller/login/bloc/login_bloc.dart';
import 'package:frontend_for_seller/profile/pages/orders/orders.dart';
import 'package:frontend_for_seller/profile/pages/profileEdit/profileEdit.dart';
import 'package:frontend_for_seller/repositories/database_repository.dart';
import 'package:frontend_for_seller/repositories/local_storage.dart';
import 'package:frontend_for_seller/signup/bloc/sign_up_bloc.dart';

import '../models/seller.dart';
import 'bloc/profile_bloc.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  Seller? seller;
  List<String>? category;
  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    List<String> words = localStorage.username.split(" ");
    String initials = words[0][0].toUpperCase();
    if (words.length > 1) {
      initials = words[0][0] + words[1][0];
      initials = initials.toUpperCase();
    }
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        if (state is ProfileEditPageState) {
          return ProfileEdit(
            seller: seller!,
            categories: category!,
          );
        }
        if (state is OrdersPageState) {
          return const OrdersPage();
        }
        return SizedBox(
          height: h,
          width: w,
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: h * 0.1,
                ),
                InkWell(
                  onTap: () async {
                    category = await DatabaseService().retrieveCategories();
                    seller = await DatabaseService().retrieveSellerData();
                    BlocProvider.of<ProfileBloc>(context)
                        .add(GotoProfileEdit());
                  },
                  child: Container(
                    padding: const EdgeInsets.only(left: 35),
                    height: 60,
                    child: Row(
                      children: [
                        Container(
                          alignment: Alignment.center,
                          height: 60,
                          width: 60,
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            initials,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 12,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              localStorage.username,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const Text(
                              "View Profile >",
                              style: TextStyle(
                                color: Color.fromARGB(255, 82, 0, 247),
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 35, right: 35, top: 16),
                  child: Container(
                    height: 2,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(
                  height: 35,
                ),
                InkWell(
                  onTap: () {
                    BlocProvider.of<ProfileBloc>(context).add(GotoOrdersPage());
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 40),
                    child: Container(
                      height: 60,
                      padding: const EdgeInsets.only(
                        left: 35,
                      ),
                      child: Row(
                        children: [
                          Container(
                            height: 60,
                            width: 60,
                            decoration: const BoxDecoration(
                              color: Colors.black,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.receipt,
                              color: const Color(0xffFFFFFF).withOpacity(0.9),
                            ),
                          ),
                          const SizedBox(
                            width: 12,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Text(
                                "Orders",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Text(
                                "Check the Orders",
                                style: TextStyle(
                                  color: Color.fromARGB(255, 82, 0, 247),
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 40),
                  child: Container(
                    height: 60,
                    padding: const EdgeInsets.only(
                      left: 35,
                    ),
                    child: Row(
                      children: [
                        Container(
                          height: 60,
                          width: 60,
                          decoration: const BoxDecoration(
                            color: Colors.black,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.question_mark,
                            color: const Color(0xffFFFFFF).withOpacity(0.9),
                          ),
                        ),
                        const SizedBox(
                          width: 12,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text(
                              "Help",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              "Ask your query",
                              style: TextStyle(
                                color: Color.fromARGB(255, 82, 0, 247),
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 40),
                  child: Container(
                    height: 60,
                    padding: const EdgeInsets.only(
                      left: 35,
                    ),
                    child: Row(
                      children: [
                        Container(
                          height: 60,
                          width: 60,
                          decoration: const BoxDecoration(
                            color: Colors.black,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.star_rate,
                            color: const Color(0xffFFFFFF).withOpacity(0.9),
                          ),
                        ),
                        const SizedBox(
                          width: 12,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text(
                              "Rate us",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              "Rate our app now",
                              style: TextStyle(
                                color: Color.fromARGB(255, 82, 0, 247),
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () => {
                    BlocProvider.of<AuthBloc>(context).add(SignOutRequested()),
                    BlocProvider.of<LoginBloc>(context).add(LogoutEvent()),
                    BlocProvider.of<SignUpBloc>(context).add(Logout())
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 40),
                    child: Container(
                      height: 60,
                      padding: const EdgeInsets.only(
                        left: 35,
                      ),
                      child: Row(
                        children: [
                          Container(
                            height: 60,
                            width: 60,
                            decoration: const BoxDecoration(
                              color: Colors.black,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.exit_to_app,
                              color: const Color(0xffFFFFFF).withOpacity(0.9),
                            ),
                          ),
                          const SizedBox(
                            width: 12,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Text(
                                "Sign out",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
