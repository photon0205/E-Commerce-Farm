import 'package:flutter/material.dart';
import 'package:frontend/services/database_services.dart';
import 'package:frontend/services/local_storage.dart';
import '../models/seller.dart';

class SellerTile extends StatefulWidget {
  const SellerTile({Key? key, required this.seller}) : super(key: key);
  final Seller seller;

  @override
  State<SellerTile> createState() => _SellerTileState();
}

class _SellerTileState extends State<SellerTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 350,
      height: 250,
      decoration: const BoxDecoration(
        image: DecorationImage(image: AssetImage('assets/images/sellerBg.png')),
      ),
      child: Container(
        width: 350,
        height: 250,
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.7),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircleAvatar(
                backgroundImage: NetworkImage(
                  'https://image.shutterstock.com/image-photo/head-shot-portrait-close-smiling-260nw-1714666150.jpg',
                ),
                radius: 30),
            const SizedBox(
              height: 10,
            ),
            Text(
              widget.seller.shopName,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 70,
              width: 350 * 0.7,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ...List.generate(
                    widget.seller.productImg.length > 3
                        ? 3
                        : widget.seller.productImg.length,
                    (index) {
                      return Container(
                        height: 70,
                        width: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(
                                  widget.seller.productImg[index])),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: localStorage.following.contains(widget.seller.sellerId)
                  ? InkWell(
                      onTap: () async {
                        await DatabaseService()
                            .removeFollowing(widget.seller.sellerId!);
                        setState(() {});
                      },
                      child: Container(
                        alignment: Alignment.center,
                        height: 30,
                        width: 125,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              Color.fromARGB(255, 65, 176, 28),
                              Color.fromARGB(255, 55, 132, 40),
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: const Text(
                          "Unfollow",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: Colors.white),
                        ),
                      ),
                    )
                  : InkWell(
                      onTap: (() async {
                        await DatabaseService()
                            .addFollowing(widget.seller.sellerId ?? '');
                        setState(() {});
                      }),
                      child: Container(
                        alignment: Alignment.center,
                        height: 30,
                        width: 125,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xff5DF12B),
                              Color(0xff268B11),
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: const Text(
                          "Get Updates",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: Colors.white),
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
