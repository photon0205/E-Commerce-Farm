import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:frontend/component/rating.dart';
import 'package:frontend/component/ratingInput.dart';
import 'package:frontend/config/constants.dart';
import 'package:frontend/services/database_services.dart';

import '../../bloc/profile_bloc.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    TabController _tabController = TabController(length: 1, vsync: this);
    return SizedBox(
      height: h,
      width: w,
      child: Column(
        children: [
          Container(
            color: Colors.black,
            alignment: Alignment.bottomLeft,
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
                    "History",
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
            height: h * 0.045,
            child: TabBar(
              indicatorColor: Colors.transparent,
              labelColor: Colors.black,
              labelStyle: const TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w700),
              unselectedLabelStyle: const TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w400),
              controller: _tabController,
              tabs: const [
                Tab(
                  child: Text("Orders"),
                ),
                // Tab(
                //   child: Text("Bookings"),
                // ),
              ],
            ),
          ),
          SizedBox(
            height: h * 0.80 - 56,
            child: TabBarView(controller: _tabController, children: [
              Expanded(
                  child: StreamBuilder(
                stream: DatabaseService().retrieveOrders(),
                builder: (context,
                    AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                        snapshot) {
                  if (!snapshot.hasData &&
                      snapshot.connectionState == ConnectionState.none) {
                    return Container();
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  QuerySnapshot<Map<String, dynamic>>? orderSnap =
                      snapshot.data;
                  return ListView.builder(
                    itemCount: orderSnap!.docs.length,
                    itemBuilder: (context, index) {
                      Map<String, dynamic> data = orderSnap.docs[index].data();
                      return Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 50, left: 20),
                            child: OrderTile(
                              productName: data['productName'],
                              prodCat: data['prodCat'],
                              status: data['status'],
                              orderId: data['orderId'],
                              prodImg: data['imageUrl'],
                              prodPrice: data['prodPrice'],
                              sellerLocation: data['sellerLocation'].split(','),
                              prodId: data['productId'],
                              rating: data['rating'],
                            ),
                          ),
                          Container(
                            height: 1,
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                    colors: [
                                  const Color(0xff39C61C).withOpacity(0),
                                  const Color(0xff39C61C),
                                  const Color(0xff39C61C).withOpacity(0),
                                ])),
                          )
                        ],
                      );
                    },
                  );
                },
              )),
            ]),
          ),
        ],
      ),
    );
  }
}

class OrderTile extends StatefulWidget {
  const OrderTile(
      {Key? key,
      required this.productName,
      required this.prodCat,
      required this.prodPrice,
      required this.status,
      required this.orderId,
      required this.prodImg,
      required this.sellerLocation,
      required this.prodId,
      required this.rating})
      : super(key: key);
  final String productName;
  final String prodCat;
  final String prodId;
  final String prodPrice;
  final String status;
  final String orderId;
  final String prodImg;
  final int rating;
  final List<String> sellerLocation;

  @override
  State<OrderTile> createState() => _OrderTileState();
}

class _OrderTileState extends State<OrderTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 15),
      height: 120,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 73,
            width: 73,
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: NetworkImage(widget.prodImg), fit: BoxFit.cover),
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.only(left: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.productName,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(
                    height: 3,
                  ),
                  Text(
                    widget.prodCat,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.black.withOpacity(0.5),
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: 25,
                        padding: const EdgeInsets.only(
                          left: 8,
                          right: 8,
                        ),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: const Color(0xff5DF12B).withOpacity(0.2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          "₹ ${widget.prodPrice}",
                          style: const TextStyle(
                            color: Color(0xff2EA914),
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      widget.status == "requested"
                          ? Container(
                              alignment: Alignment.center,
                              height: 30,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: AppColors.primary.withAlpha(2),
                              ),
                              child: const Text(
                                "Wait For Confirmation...",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            )
                          : widget.status == "confirmed"
                              ? InkWell(
                                  onTap: () async {
                                    bool launched =
                                        await MapsLauncher.launchCoordinates(
                                            double.parse(
                                                widget.sellerLocation[0]),
                                            double.parse(
                                                widget.sellerLocation[1]));

                                    if (launched == false) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                              content: Text(
                                                  'something went wrong')));
                                    } else {
                                      DatabaseService()
                                          .orderComplete(widget.orderId);
                                    }
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    height: 30,
                                    width: 55,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
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
                                )
                              : widget.status == "complete"
                                  ? InkWell(
                                      onTap: () {
                                        showDialog(
                                          context: context,
                                          builder: (context1) {
                                            int rating = 0;
                                            return Dialog(
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 10,
                                                        vertical: 20),
                                                height: 250,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                child: Column(
                                                  children: [
                                                    Text(
                                                      "How was your ${widget.productName}",
                                                      style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.w800,
                                                        fontSize: 15,
                                                      ),
                                                    ),
                                                    const Text(
                                                      "Tell us about your product experience",
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontSize: 11,
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Container(
                                                        height: 85,
                                                        width: 85,
                                                        decoration:
                                                            BoxDecoration(
                                                          image: DecorationImage(
                                                              image: NetworkImage(
                                                                  widget
                                                                      .prodImg),
                                                              fit:
                                                                  BoxFit.cover),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(8),
                                                        ),
                                                      ),
                                                    ),
                                                    RateInput(
                                                      onTap: (v) {
                                                        setState(() {
                                                          rating = v;
                                                        });
                                                      },
                                                    ),
                                                    const Spacer(),
                                                    InkWell(
                                                      onTap: () async {
                                                        if (rating == 0) {
                                                          ScaffoldMessenger.of(
                                                                  context)
                                                              .showSnackBar(
                                                                  const SnackBar(
                                                                      content: Text(
                                                                          "Please select a rating")));
                                                        } else {
                                                          await DatabaseService()
                                                              .rateProduct(
                                                                  widget
                                                                      .orderId,
                                                                  rating,
                                                                  widget
                                                                      .prodId);
                                                          Navigator.pop(
                                                              context);
                                                        }
                                                      },
                                                      child: Container(
                                                        width: 85,
                                                        height: 35,
                                                        alignment:
                                                            Alignment.center,
                                                        decoration:
                                                            BoxDecoration(
                                                          color:
                                                              AppColors.primary,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5),
                                                        ),
                                                        child: const Text(
                                                          "Submit",
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                      },
                                      child: Container(
                                        alignment: Alignment.center,
                                        height: 30,
                                        width: 50,
                                        decoration: BoxDecoration(
                                          color: AppColors.primary
                                              .withOpacity(0.8),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: const Text(
                                          'Rate',
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    )
                                  : Rating(
                                      rating: widget.rating,
                                      order: true,
                                    ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
