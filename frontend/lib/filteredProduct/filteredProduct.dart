import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:frontend/component/product.dart';
import 'package:frontend/services/database_impl.dart';
import 'package:frontend/services/local_storage.dart';

import '../models/product.dart';

class FilteredProductPage extends StatelessWidget {
  const FilteredProductPage(
      {Key? key, required this.subCategory, this.wishlist = false})
      : super(key: key);
  final String subCategory;
  final bool wishlist;
  Future<List<String>> getLocation() async {
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
    Position position = await Geolocator.getCurrentPosition();
    return [position.latitude.toString(), position.longitude.toString()];
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        height: h,
        width: w,
        child: Column(
          children: [
            Expanded(
              child: SizedBox(),
            ),
            Container(
              height: h * 0.8,
              child: FutureBuilder(
                  future: DatabaseRepositoryImpl()
                      .retreiveFilteredProducts(subCategory),
                  builder:
                      (context, AsyncSnapshot<List<ProductModel?>> snapshot) {
                    if (!snapshot.hasData &&
                        snapshot.connectionState == ConnectionState.none) {
                      return Container();
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return FutureBuilder(
                        future: getLocation(),
                        builder:
                            (context, AsyncSnapshot<List<String>> snapshot1) {
                          if (!snapshot.hasData &&
                              snapshot1.connectionState ==
                                  ConnectionState.none) {
                            return Container();
                          }
                          if (snapshot1.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          List<String>? currentLocation = snapshot1.data;
                          return ListView.builder(
                              padding: EdgeInsets.zero,
                              itemCount: snapshot.data!.length,
                              itemBuilder: (context, index) {
                                bool check = true;
                                if (wishlist) {
                                  List<String> wishyList =
                                      localStorage.wishList;
                                  check = wishyList
                                      .contains(snapshot.data![index]!.docId);
                                }
                                if (check) {
                                  return Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: Product(
                                      currentLocation: currentLocation!,
                                      productModel: snapshot.data![index]!,
                                    ),
                                  );
                                }
                                return Container();
                              });
                        });
                  }),
            )
          ],
        ),
      ),
    );
  }
}
