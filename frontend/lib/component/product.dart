import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:frontend/component/rating.dart';
import 'package:frontend/config/constants.dart';
import 'package:frontend/services/database_impl.dart';
import 'package:frontend/services/database_services.dart';
import '../models/product.dart';
import '../services/local_storage.dart';

class Product extends StatefulWidget {
  final ProductModel productModel;
  final List<String> currentLocation;

  const Product({
    super.key,
    required this.productModel,
    required this.currentLocation,
  });

  @override
  State<Product> createState() => _ProductState();
}

class _ProductState extends State<Product> {
  @override
  Widget build(BuildContext context) {
    List<String> wishlist = localStorage.wishList;
    bool fav = wishlist.contains(widget.productModel.docId);
    double w = MediaQuery.of(context).size.width;
    List<String> sellerLocation = widget.productModel.location.split(",");
    int distance = Geolocator.distanceBetween(
      double.parse(widget.currentLocation[0]),
      double.parse(widget.currentLocation[1]),
      double.parse(sellerLocation[0]),
      double.parse(sellerLocation[1]),
    ).toInt();
    bool km = distance > 1000;
    distance = km ? distance ~/ 1000 : distance;
    return InkWell(
      onTap: (() {
        showDialog(
            context: context,
            builder: (builder1) {
              return Dialog(
                child: Container(
                  padding: const EdgeInsets.only(left: 15, right: 15, top: 16),
                  height: 510,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 350,
                        color: Colors.black45,
                        child: PageView.builder(
                          itemCount: widget.productModel.urls.length,
                          itemBuilder: (builder1, index) {
                            return Container(
                              width: double.maxFinite,
                              height: double.maxFinite,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: NetworkImage(
                                        widget.productModel.urls[index]),
                                    fit: BoxFit.cover),
                              ),
                            );
                          },
                        ),
                      ),
                      StreamBuilder<QuerySnapshot>(
                          stream: DatabaseService().orderStatus(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData &&
                                snapshot.connectionState ==
                                    ConnectionState.none) {
                              return Container();
                            }
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            String status = "none";
                            String orderId = "none";
                            if (snapshot.data != null) {
                              snapshot.data!.docs.forEach((document) {
                                if (document.get('productId') ==
                                    widget.productModel.docId) {
                                  if (document.get('status') != 'completed') {
                                    status = document.get('status');
                                    orderId = document.id;
                                  }
                                }
                              });
                            }
                            return status=="requested"?
                            Container(
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        color: AppColors.primary.withAlpha(2),
                                      ),
                                      child: const Text(
                                        "Wait For Confirmation...",
                                        style: TextStyle(
                                          color: Color.fromARGB(246, 51, 51, 51),
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    )
                            : InkWell(
                              onTap: () {
                                  DatabaseService().requestOrder(
                                                widget.productModel);
                              },
                              child: Container(
                                alignment: Alignment.center,
                                height: 50,
                                width: double.maxFinite,
                                decoration: const BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(8),
                                        bottomRight: Radius.circular(8))),
                                child: const Text(
                                  "GOOD TO GO >>",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                            );
                          }),
                      Text(
                        widget.productModel.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 17,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        widget.productModel.description,
                        style: const TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 13,
                          color: Colors.black,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        "₹ ${widget.productModel.price}",
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 17,
                          color: Color(0xff2EA914),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            });
      }),
      child: Container(
        padding: const EdgeInsets.all(12),
        height: 180,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          children: [
            Container(
              height: 160,
              width: w * 0.25,
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.4),
                image: DecorationImage(
                    image: NetworkImage(widget.productModel.urls[0]),
                    fit: BoxFit.cover),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () async {
                      if (fav) {
                        await DatabaseRepositoryImpl()
                            .removeFromWishlist(widget.productModel.docId);
                      } else {
                        await DatabaseRepositoryImpl().addToWishlist(
                            widget.productModel.docId,
                            widget.productModel.category);
                      }
                    },
                    child: SizedBox(
                      height: 30,
                      width: 30,
                      child: Icon(
                        CupertinoIcons.heart_solid,
                        size: 20,
                        color: fav
                            ? AppColors.primary
                            : CupertinoColors.white.withOpacity(0.5),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 150,
              width: w * 0.78 - 78,
              padding: const EdgeInsets.only(left: 10),
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    height: 42,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            color: Colors.transparent,
                            width: (w * 0.78 - 78) * 0.70,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  height: 3,
                                ),
                                Text(
                                  overflow: TextOverflow.ellipsis,
                                  widget.productModel.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(
                                  height: 3,
                                ),
                                Text(
                                  overflow: TextOverflow.ellipsis,
                                  widget.productModel.description,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 10,
                                    color: Colors.white.withOpacity(0.6),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: (w * 0.78 - 78) * 0.25,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  "₹ ${widget.productModel.price}",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13,
                                    color: Color(0xff39C61C),
                                  ),
                                ),
                                const SizedBox(
                                  height: 3,
                                ),
                                Text(
                                  widget.productModel.type,
                                  overflow: TextOverflow.clip,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 8,
                                    color: Colors.white.withOpacity(0.5),
                                  ),
                                  textAlign: TextAlign.right,
                                ),
                              ],
                            ),
                          )
                        ]),
                  ),
                  Container(
                    alignment: Alignment.center,
                    height: 5,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: (w / 15).round(),
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Container(
                            width: 5,
                            height: 0.05,
                            color: AppColors.primary.withOpacity(0.63),
                          ),
                        );
                      },
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(top: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.productModel.seller,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                            color: Colors.white.withOpacity(0.6),
                          ),
                        ),
                        Rating(
                            rating: widget.productModel.rating.toInt(),
                            order: false),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        widget.productModel.address,
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 11,
                          color: Colors.white.withOpacity(0.6),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        km
                            ? "$distance Km away from you"
                            : "$distance m away from you",
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 8,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        widget.productModel.open ? 'Open ⬤' : 'Closed ⬤',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: widget.productModel.open
                              ? AppColors.primary
                              : Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  StreamBuilder<QuerySnapshot>(
                      stream: DatabaseService().orderStatus(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData &&
                            snapshot.connectionState == ConnectionState.none) {
                          return Container();
                        }
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        String status = "none";
                        String orderId = "none";
                        if (snapshot.data != null) {
                          snapshot.data!.docs.forEach((document) {
                            if (document.get('productId') ==
                                widget.productModel.docId) {
                              if (document.get('status') != 'completed') {
                                status = document.get('status');
                                orderId = document.id;
                              }
                            }
                          });
                        }

                        return Container(
                          padding: const EdgeInsets.only(top: 5),
                          child: status == "confirmed"
                              ? Row(
                                  children: [
                                    InkWell(
                                      onTap: () async {
                                        bool launched = await MapsLauncher
                                            .launchCoordinates(
                                                double.parse(sellerLocation[0]),
                                                double.parse(
                                                    sellerLocation[1]));

                                        if (launched == false) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(const SnackBar(
                                                  content: Text(
                                                      'something went wrong')));
                                        } else {
                                          DatabaseService()
                                              .orderComplete(orderId);
                                        }
                                      },
                                      child: Container(
                                        alignment: Alignment.center,
                                        height: 30,
                                        width: 55,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          color: Colors.green,
                                        ),
                                        child: const Text(
                                          "Go",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              : status == "requested"
                                  ? Container(
                                      alignment: Alignment.center,
                                      height: 30,
                                      width: 190,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        color: AppColors.primary.withAlpha(2),
                                      ),
                                      child: const Text(
                                        "Wait For Confirmation...",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    )
                                  : Row(
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            DatabaseService().requestOrder(
                                                widget.productModel);
                                            setState(() {});
                                          },
                                          child: Container(
                                            alignment: Alignment.center,
                                            height: 30,
                                            width: 110,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              gradient:
                                                  AppColors.buttonGradient,
                                            ),
                                            child: const Text(
                                              "Good to Go >>",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 13,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                        );
                      }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
