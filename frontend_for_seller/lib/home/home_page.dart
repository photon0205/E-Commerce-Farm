import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend_for_seller/home/bloc/home_bloc.dart';
import 'package:frontend_for_seller/home/home_view.dart';
import 'package:frontend_for_seller/login/login_page.dart';
import 'package:frontend_for_seller/newProduct/bloc/new_product_bloc.dart';
import 'package:frontend_for_seller/newProduct/newProduct.dart';
import 'package:frontend_for_seller/profile/bloc/profile_bloc.dart';
import 'package:frontend_for_seller/profile/profile.dart';

import '../auth/auth_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // Getting the user from the FirebaseAuth Instance
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color(0xFFC3A9FF),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is UnAuthenticated) {
            // Navigate to the sign in screen when the user Signs Out
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const LoginPage()),
              (route) => false,
            );
          }
        },
        child: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            if (state is Home_Page) {
              return const HomeView();
            }
            if (state is ProfilePage) {
              return const Profile();
            }
            if (state is AddProductPage) {
              return const NewProduct();
            }
            return const HomeView();
          },
        ),
      ),
      bottomNavigationBar: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          return BottomNavigationBar(
              showSelectedLabels: true,
              showUnselectedLabels: true,
              unselectedLabelStyle:
                  const TextStyle(color: CupertinoColors.white),
              selectedItemColor: CupertinoColors.activeGreen,
              unselectedItemColor: CupertinoColors.white,
              selectedLabelStyle:
                  const TextStyle(color: CupertinoColors.activeGreen),
              currentIndex: state is Home_Page
                  ? 0
                  : state is ProfilePage
                      ? 2
                      : state is AddProductPage
                          ? 1
                          : 0,
              onTap: (value) {
                switch (value) {
                  case 0:
                    BlocProvider.of<HomeBloc>(context).add(HomeNavigate());
                    break;
                  case 1:
                    BlocProvider.of<NewProductBloc>(context).add(ReloadEvent());
                    BlocProvider.of<HomeBloc>(context)
                        .add(AddProductNavigate());
                    break;
                  case 2:
                    BlocProvider.of<ProfileBloc>(context)
                        .add(BackToProfilePage());
                    BlocProvider.of<HomeBloc>(context).add(ProfileNavigate());
                    break;
                  default:
                }
              },
              backgroundColor: Colors.black,
              items: const [
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.home,
                    ),
                    label: "Home"),
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.add_circle,
                    ),
                    label: "New Product"),
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.person,
                    ),
                    label: "Profile"),
              ]);
        },
      ),
    );
  }
}
