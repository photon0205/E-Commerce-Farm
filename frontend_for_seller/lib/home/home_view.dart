import 'package:flutter/material.dart';
import 'package:frontend_for_seller/components/product/productTile.dart';
import 'package:frontend_for_seller/repositories/database_impl.dart';
import 'package:frontend_for_seller/repositories/local_storage.dart';

import '../models/product.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    return Column(
      children: [
        SizedBox(
          height: h * 0.07,
        ),
        Row(children: [
          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(left: 25),
            height: h * 0.1,
            child: Image.asset('assets/images/logo.png'),
          ),
          SizedBox(
            height: h * 0.02,
          ),
          Column(children: [
            Container(
              padding: const EdgeInsets.only(left: 25),
              height: 0.03 * h,
              child: Row(children: [
                const Text(
                  'Hello ',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.w500),
                ),
                Text(
                  '${localStorage.username.toUpperCase()} JI!',
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ]),
            ),
            Container(
              padding: const EdgeInsets.only(left: 25),
              alignment: Alignment.centerLeft,
              height: 0.03 * h,
              child: Text(
                'SEE YOUR PRODUCTS HERE',
                style: TextStyle(
                  color: Colors.black.withOpacity(0.51),
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            )
          ])
        ]),
        Container(
          height: h * 0.82 - 56,
          color: Colors.white,
          child: FutureBuilder(
            future: DatabaseRepositoryImpl().getMyProdList(),
            builder: (context, AsyncSnapshot<List<Product>> snapshot) {
              if (!snapshot.hasData &&
                  snapshot.connectionState == ConnectionState.none) {
                return const Center(
                  child: Text(
                    'You Don\'t have any Product\n Add some',
                    style: TextStyle(color: Colors.white),
                  ),
                );
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (snapshot.data!.isEmpty) {
                return const Center(
                  child: Text(
                    'You Don\'t have  Product\n Add some',
                    style: TextStyle(color: Colors.white),
                  ),
                );
              }
              return Padding(
                padding: const EdgeInsets.only(left: 18.0, right: 18.0),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    childAspectRatio: 140 / 200,
                    crossAxisCount: 2,
                  ),
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(1.0),
                      child: ProductTile(product: snapshot.data![index]),
                    );
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
