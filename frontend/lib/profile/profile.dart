import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:frontend/auth/bloc/auth_bloc.dart';
import 'package:frontend/login/bloc/login_bloc.dart';
import 'package:frontend/profile/pages/History/history.dart';
import 'package:frontend/profile/pages/profieEdit/profileEdit.dart';
import 'package:frontend/profile/pages/wishlist/wishlist.dart';
import 'package:frontend/services/local_storage.dart';

import 'bloc/profile_bloc.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    Future<String> getLocation() async {
      bool serviceEnabled;
      LocationPermission permission;
      // Test if location services are enabled.
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        // Location services are not enabled don't continue
        // accessing the position and request users of the
        // App to enable the location services.
        return Future.error('Location services are disabled.');
      }
      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          // Permissions are denied, next time you could try
          // requesting permissions again (this is also where
          // Android's shouldShowRequestPermissionRationale
          // returned true. According to Android guidelines
          // your App should show an explanatory UI now.
          return Future.error('Location permissions are denied');
        }
      }
      if (permission == LocationPermission.deniedForever) {
        // Permissions are denied forever, handle appropriately.
        return Future.error(
            'Location permissions are permanently denied, we cannot request permissions.');
      }
      // When we reach here, permissions are granted and we can
      // continue accessing the position of the device.
      Position? postion = await Geolocator.getLastKnownPosition();
      List<Placemark> placemarks =
          await placemarkFromCoordinates(postion!.latitude, postion.longitude);
      return '${placemarks[0].subLocality}';
    }

    List<String> list = localStorage.username.split(' ');
    String locations = "Loading...";
    String initials = list.length == 1
        ? list[0][0].toUpperCase()
        : (list[0][0] + list[1][0]).toUpperCase();
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        if (state is ProfileEdit) {
          return ProfileEditPage(
            initial: initials,
          );
        }
        if (state is History) {
          return const HistoryPage();
        }
        if (state is Wishlist) {
          return const WishlistPage();
        }
        return Container(
            height: h,
            width: w,
            padding: const EdgeInsets.only(left: 30, right: 30),
            child: Column(
              children: [
                SizedBox(
                  height: h * 0.1,
                ),
                Container(
                  child: Row(
                    children: [
                      Container(
                        alignment: Alignment.center,
                        height: 70,
                        width: 70,
                        child: Text(
                          initials,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w600),
                        ),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 78, 202, 82),
                          borderRadius: BorderRadius.circular(35),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.only(left: 20),
                        alignment: Alignment.centerLeft,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              localStorage.username == ""
                                  ? "Name"
                                  : localStorage.username,
                              textAlign: TextAlign.left,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            FutureBuilder(
                                future: getLocation(),
                                builder:
                                    (context, AsyncSnapshot<String> snapshot) {
                                  return Text(
                                    snapshot.hasData &&
                                            snapshot.connectionState ==
                                                ConnectionState.done
                                        ? snapshot.data!
                                        : locations,
                                    textAlign: TextAlign.left,
                                    style: const TextStyle(
                                      overflow: TextOverflow.ellipsis,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  );
                                }),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  height: 2.3,
                  color: Colors.black,
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  height: h * 0.7 - 19,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        InkWell(
                          onTap: () => BlocProvider.of<ProfileBloc>(context)
                              .add(ProfileEditEvent()),
                          child: SizedBox(
                            height: 45,
                            child: Row(
                              children: [
                                Container(
                                  height: 40,
                                  width: 40,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Colors.black,
                                  ),
                                  child: const Icon(Icons.person,
                                      color: Colors.white, size: 30),
                                ),
                                Container(
                                  padding: const EdgeInsets.only(
                                      left: 15.0, top: 5.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "Profile",
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Text(
                                        "Help us know you better!",
                                        style: TextStyle(
                                          fontSize: 9,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black.withOpacity(0.65),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () => BlocProvider.of<ProfileBloc>(context)
                              .add(HistoryEvent()),
                          child: Padding(
                            padding: const EdgeInsets.only(top: 25),
                            child: SizedBox(
                              height: 45,
                              child: Row(
                                children: [
                                  Container(
                                    height: 40,
                                    width: 40,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: Colors.black,
                                    ),
                                    child: const Icon(Icons.note_alt,
                                        color: Colors.white, size: 25),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.only(
                                        left: 15.0, top: 5.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          "History",
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        Text(
                                          "Check out your previous routes",
                                          style: TextStyle(
                                            fontSize: 9,
                                            fontWeight: FontWeight.w500,
                                            color:
                                                Colors.black.withOpacity(0.65),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () => BlocProvider.of<ProfileBloc>(context)
                              .add(WishlistEvent()),
                          child: Padding(
                            padding: const EdgeInsets.only(top: 25),
                            child: SizedBox(
                              height: 45,
                              child: Row(
                                children: [
                                  Container(
                                    height: 40,
                                    width: 40,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: Colors.black,
                                    ),
                                    child: const Center(
                                        child: Icon(CupertinoIcons.heart_solid,
                                            color: Colors.white, size: 25)),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.only(
                                        left: 15.0, top: 5.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          "Wishlist",
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        Text(
                                          "Find your likes here.",
                                          style: TextStyle(
                                            fontSize: 9,
                                            fontWeight: FontWeight.w500,
                                            color:
                                                Colors.black.withOpacity(0.65),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: (() {}),
                          child: Padding(
                            padding: const EdgeInsets.only(top: 25),
                            child: SizedBox(
                              height: 45,
                              child: Row(
                                children: [
                                  Container(
                                    height: 40,
                                    width: 40,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: Colors.black,
                                    ),
                                    child: const Center(
                                        child: Icon(CupertinoIcons.question,
                                            color: Colors.white, size: 25)),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.only(
                                        left: 15.0, top: 5.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          "Help",
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        Text(
                                          "Solve your queries.",
                                          style: TextStyle(
                                            fontSize: 9,
                                            fontWeight: FontWeight.w500,
                                            color:
                                                Colors.black.withOpacity(0.65),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 25),
                            child: SizedBox(
                              height: 45,
                              child: Row(
                                children: [
                                  Container(
                                    height: 40,
                                    width: 40,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: Colors.black,
                                    ),
                                    child: const Center(
                                        child: Icon(CupertinoIcons.star_fill,
                                            color: Colors.white, size: 22)),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.only(
                                        left: 15.0, top: 5.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          "Rate our app",
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        Text(
                                          "Share your experience with others!",
                                          style: TextStyle(
                                            fontSize: 9,
                                            fontWeight: FontWeight.w500,
                                            color:
                                                Colors.black.withOpacity(0.65),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            BlocProvider.of<AuthBloc>(context)
                                .add(SignOutRequested());
                            BlocProvider.of<LoginBloc>(context).add(
                                const LoginTextChangedEvent(
                                    "abd@gmail.com", "abcd1234@"));
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(top: 25),
                            child: SizedBox(
                              height: 45,
                              child: Row(
                                children: [
                                  Container(
                                    height: 40,
                                    width: 40,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: Colors.black,
                                    ),
                                    child: const Center(
                                        child: Icon(Icons.exit_to_app_rounded,
                                            color: Colors.white, size: 22)),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.only(
                                        left: 15.0, top: 0.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: const [
                                        Text(
                                          "Sign out",
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ));
      },
    );
  }
}
