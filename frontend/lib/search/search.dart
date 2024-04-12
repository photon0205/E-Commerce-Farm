import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:frontend/component/product.dart';
import 'package:frontend/component/sellerTile.dart';
import 'package:frontend/config/constants.dart';
import 'package:frontend/models/category.dart';
import 'package:frontend/models/product.dart';
import 'package:frontend/search/filters/bloc/filter_bloc.dart';
import 'package:frontend/search/sort/bloc/sort_by_bloc.dart';
import 'package:frontend/services/database_services.dart';

import '../models/seller.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key, required this.isSeller, required this.field})
      : super(key: key);
  final bool isSeller;
  final String field;
  @override
  State<SearchPage> createState() => _SearchPageState();
}

String ratingSort = "Sort by";
String priceSort = "Sort by";
List<String> selected = [];
List<String> filterCat = [];
String initialFrom = '0';
String initialTo = '0';
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

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    h = h * 0.738;
    return SizedBox(
      height: h,
      child: Column(
        children: [
          widget.isSeller
              ? const SizedBox()
              : SizedBox(
                  height: 50,
                  width: w,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (builder) {
                                return const SortingDialog();
                              });
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(right: 10.0),
                          child: Container(
                            child: Row(
                              children: const [
                                Padding(
                                  padding: EdgeInsets.only(right: 5.0),
                                  child: Icon(
                                    Icons.sort,
                                    color: Colors.black,
                                  ),
                                ),
                                Text(
                                  "SORT BY",
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          selected = [];
                          BlocProvider.of<FilterBloc>(context)
                              .add(FilterResetEvent());
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => FilterPage(
                              highest: initialFrom,
                              lowest: initialTo,
                              categories: filterCat,
                            ),
                          ));
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(right: 20.0),
                          child: Row(
                            children: const [
                              Padding(
                                padding: EdgeInsets.only(right: 5.0),
                                child: Icon(
                                  Icons.tune,
                                  color: Colors.black,
                                ),
                              ),
                              Text(
                                "FILTERS",
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
          SizedBox(
            height: h,
            width: w,
            child: widget.isSeller
                ? FutureBuilder(
                    future: DatabaseService().searchResultSellers(widget.field),
                    builder: (context, AsyncSnapshot<List<Seller>> snapshot) {
                      if (widget.field == "") {
                        return Container();
                      } else if (!snapshot.hasData &&
                          snapshot.connectionState == ConnectionState.none) {
                        return Container();
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      List<Seller?> sellers = snapshot.data!;
                      if (sellers.isEmpty) {
                        return Container(
                          child: const Center(
                              child: Text(
                            "Sorry we don't have this seller",
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          )),
                        );
                      }
                      return ListView.builder(
                        itemCount: sellers.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(
                                left: 20, right: 20, bottom: 20),
                            child: SellerTile(seller: sellers[index]!),
                          );
                        },
                      );
                    },
                  )
                : BlocBuilder<SortByBloc, SortByState>(
                    builder: (context, state) {
                      return BlocBuilder<FilterBloc, FilterState>(
                        builder: (context, state1) {
                          return FutureBuilder(
                            future: DatabaseService().retrieveSearchProducts(
                              widget.field,
                              sortByPrice:
                                  state is SortedByPrice ? state.str : "none",
                              sortByRating:
                                  state is SortedByRating ? state.str : "none",
                              filterCat:
                                  state1 is FilterSet ? state1.filterCat : null,
                              priceFrom:
                                  state1 is FilterSet ? state1.from : null,
                              priceTo: state1 is FilterSet ? state1.to : null,
                            ),
                            builder: (context,
                                AsyncSnapshot<List<ProductModel?>> snapshot) {
                              if (widget.field == "") {
                                return Container();
                              } else if (!snapshot.hasData &&
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
                              if (snapshot.data!.isEmpty) {
                                return const Center(
                                    child: Text(
                                  "Sorry we are out of products",
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                ));
                              }
                              if (state1 is! FilterSet) {
                                filterCat = snapshot.data!
                                    .map((e) => e!.category)
                                    .toList();
                                for (var e in snapshot.data!) {
                                  int x = e!.price;
                                  initialFrom =
                                      min<int>(x, int.parse(initialFrom))
                                          .toString();
                                  initialTo = max<int>(x, int.parse(initialTo))
                                      .toString();
                                }
                              }

                              List<ProductModel?> products = snapshot.data!;
                              List<ProductModel?> prods = [];
                              products.map((e) {
                                if (e!.price >= int.parse(initialFrom) &&
                                    e.price <= int.parse(initialTo)) {
                                  prods.add(e);
                                }
                              }).toList();
                              if (prods.isEmpty) {
                                return const Center(
                                    child: Text(
                                  "Sorry we are out of products",
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                ));
                              }
                              return FutureBuilder<List<String>>(
                                  future: getLocation(),
                                  builder: (context, snapshot1) {
                                    if (!snapshot1.hasData &&
                                        snapshot.connectionState ==
                                            ConnectionState.none) {
                                      return Container();
                                    }
                                    if (snapshot1.connectionState ==
                                        ConnectionState.waiting) {
                                      return const Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    }
                                    List<String>? currentLocation =
                                        snapshot1.data;
                                    return ListView.builder(
                                      itemCount: prods.length,
                                      itemBuilder: (context, index) {
                                        return Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 20, left: 20, right: 20),
                                          child: Product(
                                              currentLocation: currentLocation!,
                                              productModel: prods[index]!),
                                        );
                                      },
                                    );
                                  });
                            },
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class SortingDialog extends StatefulWidget {
  const SortingDialog({Key? key}) : super(key: key);

  @override
  State<SortingDialog> createState() => _SortingDialogState();
}

class _SortingDialogState extends State<SortingDialog> {
  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Container(
        constraints: const BoxConstraints(minHeight: 240, maxHeight: 240),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 20,
              ),
              InkWell(
                onTap: () {
                  showModalBottomSheet(
                      context: context,
                      builder: (bu) {
                        return BottomSheet(
                          builder: (b) {
                            return Container(
                              width: w,
                              height: 100,
                              padding: const EdgeInsets.only(left: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      BlocProvider.of<SortByBloc>(context)
                                          .add(SortEnded());
                                      setState(() {
                                        ratingSort = "Sort by";
                                        priceSort = "Sort by";
                                      });
                                      BlocProvider.of<SortByBloc>(context).add(
                                          const SortByRating("High to Low"));
                                      setState(() {
                                        ratingSort = "High to Low";
                                      });
                                      Navigator.pop(context);
                                    },
                                    child: SizedBox(
                                      width: w,
                                      child: const Text(
                                        "High to Low",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      BlocProvider.of<SortByBloc>(context)
                                          .add(SortEnded());
                                      setState(() {
                                        ratingSort = "Sort by";
                                        priceSort = "Sort by";
                                      });
                                      BlocProvider.of<SortByBloc>(context).add(
                                          const SortByRating("Low to High"));
                                      setState(() {
                                        ratingSort = "Low to High";
                                      });
                                      Navigator.pop(context);
                                    },
                                    child: SizedBox(
                                      width: w,
                                      child: const Text(
                                        "Low to High",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                          onClosing: (() {}),
                        );
                      });
                },
                child: Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.only(left: 20),
                  height: 50,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Rating',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        ratingSort,
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                          color: Color(0xff2EA914),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  showModalBottomSheet(
                      context: context,
                      builder: (bu) {
                        return BottomSheet(
                          builder: (b) {
                            return Container(
                              width: w,
                              height: 100,
                              padding: const EdgeInsets.only(left: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      BlocProvider.of<SortByBloc>(context)
                                          .add(SortEnded());
                                      setState(() {
                                        ratingSort = "Sort by";
                                        priceSort = "Sort by";
                                      });
                                      BlocProvider.of<SortByBloc>(context).add(
                                          const SortByPrice("High to Low"));
                                      setState(() {
                                        priceSort = "High to Low";
                                      });
                                      Navigator.pop(context);
                                    },
                                    child: SizedBox(
                                      width: w,
                                      child: const Text(
                                        "High to Low",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      BlocProvider.of<SortByBloc>(context)
                                          .add(SortEnded());
                                      setState(() {
                                        ratingSort = "Sort by";
                                        priceSort = "Sort by";
                                      });
                                      BlocProvider.of<SortByBloc>(context).add(
                                          const SortByPrice("Low to High"));
                                      setState(() {
                                        priceSort = "Low to High";
                                      });
                                      Navigator.pop(context);
                                    },
                                    child: SizedBox(
                                      width: w,
                                      child: const Text(
                                        "Low to High",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                          onClosing: (() {}),
                        );
                      });
                },
                child: Container(
                  alignment: Alignment.centerLeft,
                  height: 50,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(left: 20),
                        child: Text(
                          'Price',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Text(
                          priceSort,
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                            color: Color(0xff2EA914),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  alignment: Alignment.center,
                  height: 45,
                  width: 400,
                  decoration: BoxDecoration(
                      gradient: AppColors.buttonGradient,
                      borderRadius: BorderRadius.circular(12.0)),
                  child: const Text(
                    "DONE",
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FilterPage extends StatefulWidget {
  const FilterPage(
      {Key? key,
      required this.categories,
      required this.highest,
      required this.lowest})
      : super(key: key);
  final List<String> categories;
  final String highest;
  final String lowest;

  @override
  State<FilterPage> createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  final TextEditingController from = TextEditingController(text: initialFrom);
  final TextEditingController to = TextEditingController(text: initialTo);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          IconButton(
              onPressed: () {
                BlocProvider.of<FilterBloc>(context).add(FilterResetEvent());
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.delete,
                color: Colors.black.withOpacity(0.8),
              ))
        ],
        title: Text(
          "Filters",
          style: TextStyle(
            color: Colors.black.withOpacity(0.7),
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 2,
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 50,
          ),
          Container(
              width: double.maxFinite,
              padding: const EdgeInsets.only(left: 25, right: 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    width: double.maxFinite,
                    child: const Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Text(
                        "Categories:",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: double.maxFinite,
                    child: Wrap(
                      children: [
                        ...List.generate(
                            widget.categories.length,
                            (index) => Padding(
                                  padding: const EdgeInsets.only(
                                    left: 10,
                                  ),
                                  child: FilterChipWidget(
                                    chipName: widget.categories[index],
                                  ),
                                )),
                      ],
                    ),
                  ),
                ],
              )),
          const SizedBox(
            height: 50,
          ),
          Container(
            padding: const EdgeInsets.only(left: 25, right: 25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 10, bottom: 20),
                  child: Text(
                    'Price Range:',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      height: 60,
                      width: 60,
                      child: TextField(
                        controller: from,
                        decoration: InputDecoration(
                          label: Text(
                            "From",
                            style: TextStyle(
                              color: Colors.black.withOpacity(0.5),
                              fontSize: 13,
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide:
                                BorderSide(color: Colors.grey.withOpacity(0.5)),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 60,
                      width: 60,
                      child: TextField(
                        controller: to,
                        decoration: InputDecoration(
                          label: Text(
                            "  To",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.black.withOpacity(0.5),
                              fontSize: 13,
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide:
                                BorderSide(color: Colors.grey.withOpacity(0.5)),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          InkWell(
            onTap: (() {
              initialFrom = from.text;
              initialTo = to.text;

              BlocProvider.of<FilterBloc>(context).add(FilterSetEvent(
                  selected.isEmpty ? filterCat : selected, from.text, to.text));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text(
                  "Filter Applied",
                )),
              );
              Navigator.pop(context);
            }),
            child: Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Container(
                height: 50,
                width: 150,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: const Color(0xff10d11e),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: const Text(
                  "Apply Filters",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class FilterChipWidget extends StatefulWidget {
  const FilterChipWidget({Key? key, required this.chipName}) : super(key: key);

  final String chipName;
  @override
  State<FilterChipWidget> createState() => _FilterChipWidgetState();
}

class _FilterChipWidgetState extends State<FilterChipWidget> {
  var isSelected = false;
  @override
  Widget build(BuildContext context) {
    return FilterChip(
      selectedColor: AppColors.primary,
      labelStyle: const TextStyle(
          color: Colors.black, fontSize: 16, fontWeight: FontWeight.w400),
      selected: isSelected,
      label: Text(widget.chipName),
      onSelected: (bool value) {
        if (value) {
          selected.add(widget.chipName);
        } else {
          selected.remove(widget.chipName);
        }
        setState(() {
          isSelected = !isSelected;
        });
      },
    );
  }
}
