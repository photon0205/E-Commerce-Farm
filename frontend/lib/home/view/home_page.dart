import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/config/constants.dart';
import 'package:frontend/explore/explore.dart';
import 'package:frontend/profile/bloc/profile_bloc.dart';
import 'package:frontend/search/bloc/search_bloc.dart';

import '../../profile/profile.dart';
import '../bloc/home_bloc.dart';
import 'home_view.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  static Page<void> page() => const MaterialPage<void>(child: HomePage());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          // if (state is SHGPageState) {
          //   return SHGs();
          // }
          if (state is ExplorePageState) {
            return const ExplorePage();
          }
          if (state is ProfilePageState) {
            return const ProfilePage();
          }
          return const HomeView();
        },
      ),
      bottomNavigationBar: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          return BottomNavigationBar(
              // fixedColor: Colors.black,
              showUnselectedLabels: true,
              showSelectedLabels: true,
              selectedItemColor: AppColors.primary,
              unselectedItemColor: CupertinoColors.black,
              selectedLabelStyle: TextStyle(color: AppColors.primary),
              unselectedLabelStyle: const TextStyle(color: Colors.black),
              currentIndex: state is HomePageState
                  ? 0
                  : state is ExplorePageState
                      ? 1
                      : state is ProfilePageState
                          ? 2
                          : 0,
              onTap: (value) {
                switch (value) {
                  case 0:
                    BlocProvider.of<SearchBloc>(context).add(SearchEnd());
                    BlocProvider.of<HomeBloc>(context).add(HomeNavigate());
                    break;
                  // case 1:
                  //   BlocProvider.of<HomeBloc>(context).add(SHGNavigate());
                  //   break;
                  case 1:
                    BlocProvider.of<SearchBloc>(context).add(SearchEnd());
                    BlocProvider.of<HomeBloc>(context).add(ExploreNavigate());
                    break;
                  case 2:
                    BlocProvider.of<SearchBloc>(context).add(SearchEnd());
                    BlocProvider.of<ProfileBloc>(context).add(BackEvent());
                    BlocProvider.of<HomeBloc>(context).add(ProfileNavigate());
                    break;
                  default:
                }
              },
              items: const [
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.home,
                    ),
                    label: "Home"),
                // BottomNavigationBarItem(
                //     icon: Icon(
                //       Icons.handshake,
                //     ),
                //     label: "SHG Product"),
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.explore,
                    ),
                    label: "Explore"),
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.person,
                    ),
                    label: "My Account"),
              ]);
        },
      ),
    );
  }
}
