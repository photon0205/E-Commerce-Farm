import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend_for_seller/repositories/database_repository.dart';

import '../../../constants/appColor.dart';
import '../../bloc/profile_bloc.dart';

class OrdersPage extends StatelessWidget {
  const OrdersPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return SizedBox(
      height: h,
      width: w,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(35, 0, 0, 10),
            alignment: Alignment.bottomLeft,
            height: 110,
            color: const Color(0xff6FFF50),
            child: Row(
              children: [
                IconButton(
                    onPressed: () {
                      BlocProvider.of<ProfileBloc>(context)
                          .add(BackToProfilePage());
                    },
                    icon: const Icon(Icons.arrow_back_ios)),
                const Text(
                  'ORDERS',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: h - 166,
            child: Column(
              children: [
                StreamBuilder<QuerySnapshot>(
                    stream: DatabaseService().pendingOrders(),
                    builder: (context, snapshot) {
                      return Container(
                        constraints: BoxConstraints(
                            maxHeight: (h - 166) * 0.5, minHeight: 50),
                        height: 200,
                        padding: const EdgeInsets.only(left: 35, top: 30),
                        alignment: Alignment.centerLeft,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "PENDING",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            snapshot.data == null
                                ? const SizedBox()
                                : snapshot.connectionState ==
                                        ConnectionState.waiting
                                    ? const Center(
                                        child: CircularProgressIndicator(),
                                      )
                                    : snapshot.data!.size == 0
                                        ? const SizedBox(
                                            child: Text("No Pending Orders"),
                                          )
                                        : Flexible(
                                            child: ListView(
                                              padding: EdgeInsets.zero,
                                              children: snapshot.data!.docs.map(
                                                  (DocumentSnapshot document) {
                                                Map<String, dynamic> data =
                                                    document.data()!
                                                        as Map<String, dynamic>;
                                                return OrderTile(
                                                  productName:
                                                      data['productName'],
                                                  status: data['status'],
                                                  userContact:
                                                      data['userContact'],
                                                  userName: data['userName'],
                                                  orderId: data['orderId'],
                                                  imgUrl: data['imageUrl'],
                                                );
                                              }).toList(),
                                            ),
                                          ),
                          ],
                        ),
                      );
                    }),
                StreamBuilder<QuerySnapshot>(
                    stream: DatabaseService().confirmedOrders(),
                    builder: (context, snapshot) {
                      return Container(
                        constraints: BoxConstraints(
                            maxHeight: (h - 166) * 0.5, minHeight: 50),
                        padding: const EdgeInsets.only(left: 35, top: 30),
                        alignment: Alignment.centerLeft,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "HISTORY",
                              style: TextStyle(
                                color: Color(0XFF2EA914),
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            snapshot.data == null
                                ? const SizedBox()
                                : snapshot.connectionState ==
                                        ConnectionState.waiting
                                    ? const Center(
                                        child: CircularProgressIndicator(),
                                      )
                                    : snapshot.data!.size == 0
                                        ? const SizedBox(
                                            child:
                                                Text("No Confirmed Order Yet"),
                                          )
                                        : Flexible(
                                            child: ListView(
                                              padding: EdgeInsets.zero,
                                              children: snapshot.data!.docs.map(
                                                  (DocumentSnapshot document) {
                                                Map<String, dynamic> data =
                                                    document.data()!
                                                        as Map<String, dynamic>;
                                                return OrderTile(
                                                  productName:
                                                      data['productName'],
                                                  status: data['status'],
                                                  userContact:
                                                      data['userContact'],
                                                  userName: data['userName'],
                                                  orderId: data['orderId'],
                                                  imgUrl: data['imageUrl'],
                                                );
                                              }).toList(),
                                            ),
                                          ),
                          ],
                        ),
                      );
                    }),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class OrderTile extends StatelessWidget {
  const OrderTile(
      {Key? key,
      required this.productName,
      required this.userName,
      required this.userContact,
      required this.status,
      required this.orderId,
      required this.imgUrl})
      : super(key: key);
  final String productName;
  final String userName;
  final String userContact;
  final String status;
  final String orderId;
  final String imgUrl;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 15),
      height: 100,
      child: Row(
        children: [
          Container(
            height: 85,
            width: 65,
            decoration: BoxDecoration(
              image: DecorationImage(image: NetworkImage(imgUrl)),
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Text(
                    productName,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Container(
                  height: 1,
                  color: const Color(0xff39C61C),
                  width: 250,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 100,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: Text(
                              userName,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Text(
                            "+91 $userContact",
                            style: TextStyle(
                              color: AppColors.primary,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (status == "requested")
                      Row(
                        children: [
                          InkWell(
                            onTap: () {
                              DatabaseService().confirmOrder(orderId);
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(3.0),
                              child: Container(
                                height: 20,
                                width: 60,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    color: AppColors.primary.withOpacity(0.8),
                                    borderRadius: BorderRadius.circular(5)),
                                child: const Text(
                                  "Accept",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              DatabaseService().rejectOrder(orderId);
                            },
                            child: Container(
                              height: 20,
                              width: 60,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: Colors.red.withOpacity(0.8),
                                  borderRadius: BorderRadius.circular(5)),
                              child: const Text(
                                "Reject",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      )
                    else
                      const SizedBox(),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
