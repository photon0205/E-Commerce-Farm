import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/component/sellerTile.dart';
import 'package:frontend/search/search.dart';
import 'package:frontend/services/database_services.dart';

import '../models/seller.dart';
import '../search/bloc/search_bloc.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({Key? key}) : super(key: key);

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage>
    with TickerProviderStateMixin {
  final TextEditingController searchField = TextEditingController();
  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    TabController tabController = TabController(length: 2, vsync: this);
    return SizedBox(
      height: h,
      width: w,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          BlocBuilder<SearchBloc, SearchState>(
            builder: (context, state) {
              return Container(
                height: state is Searched ? 130 : 187,
                decoration: const BoxDecoration(
                  color: Colors.black,
                ),
                child: Container(
                  height: 190,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/images/exploreHead.png')),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const SizedBox(
                        height: 50,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          state is Searched
                              ? GestureDetector(
                                  onTap: () {
                                    BlocProvider.of<SearchBloc>(context)
                                        .add(SearchEnd());
                                  },
                                  child: const Padding(
                                    padding:
                                        EdgeInsets.only(left: 15, right: 15),
                                    child: Icon(
                                      CupertinoIcons.back,
                                      color: Colors.white,
                                    ),
                                  ),
                                )
                              : const SizedBox(
                                  width: 37,
                                ),
                          Container(
                            alignment: Alignment.center,
                            height: 35,
                            width: w * 0.8,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.0),
                              color: Colors.white.withOpacity(0.3),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  alignment: Alignment.center,
                                  width: w * 0.7,
                                  child: TextField(
                                    onSubmitted: ((value) => {
                                          BlocProvider.of<SearchBloc>(context)
                                              .add(SearchStart())
                                        }),
                                    controller: searchField,
                                    decoration: InputDecoration(
                                        border: InputBorder.none,
                                        contentPadding: const EdgeInsets.only(
                                            left: 20, bottom: 12),
                                        hintText: 'Explore By Name of Store',
                                        hintStyle: TextStyle(
                                            color:
                                                Colors.white.withOpacity(0.8))),
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                                InkWell(
                                  onTap: (() =>
                                      BlocProvider.of<SearchBloc>(context)
                                          .add(SearchStart())),
                                  child: const Icon(
                                    Icons.search,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: state is Searched ? 25 : 45,
                      ),
                      state is Searched
                          ? const SizedBox(
                              height: 0,
                              width: 0,
                            )
                          : TabBar(
                              labelStyle: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                              labelColor: Colors.amber,
                              unselectedLabelColor: Colors.white,
                              indicatorColor: Colors.transparent,
                              controller: tabController,
                              tabs: const [
                                  Tab(text: 'All'),
                                  Tab(text: 'You Follow'),
                                ])
                    ],
                  ),
                ),
              );
            },
          ),
          BlocBuilder<SearchBloc, SearchState>(
            builder: (context, state) {
              return Expanded(
                child: Container(
                  child: state is Searched
                      ? SearchPage(isSeller: true, field: searchField.text)
                      : TabBarView(controller: tabController, children: [
                          FutureBuilder<List<Seller>>(
                            future: DatabaseService().retrieveAllSellers(),
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
                              List<Seller>? sellerList = snapshot.data;
                              return ListView.builder(
                                padding: const EdgeInsets.only(
                                    top: 10, left: 20, right: 20),
                                itemCount: sellerList!.length,
                                itemBuilder: (context, i) {
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: SellerTile(seller: sellerList[i]),
                                  );
                                },
                              );
                            },
                          ),
                          FutureBuilder<List<Seller>>(
                            future: DatabaseService().retrieveFollowedSellers(),
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
                              List<Seller>? sellerList = snapshot.data;
                              return ListView.builder(
                                padding: const EdgeInsets.only(
                                    top: 10, left: 20, right: 20),
                                itemCount: sellerList!.length,
                                itemBuilder: (context, i) {
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: SellerTile(seller: sellerList[i]),
                                  );
                                },
                              );
                            },
                          ),
                        ]),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
