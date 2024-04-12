import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/config/constants.dart';
import 'package:frontend/filteredProduct/filteredProduct.dart';
import 'package:frontend/home/view/bloc/home_view_bloc.dart';
import 'package:frontend/search/bloc/search_bloc.dart';
import 'package:frontend/search/search.dart';
import 'package:frontend/search/sort/bloc/sort_by_bloc.dart';

import '../../models/category.dart';
import '../../search/filters/bloc/filter_bloc.dart';
import '../../services/database_services.dart';
import '../../services/local_storage.dart';
import 'category_card.dart';

class HomeView extends StatefulWidget {
  const HomeView({
    Key? key,
  }) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
//
  final TextEditingController searchField = TextEditingController();
  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    FocusNode f = FocusNode();
    return SizedBox(
      height: h,
      width: w,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          const SizedBox(
            height: 60,
          ),
          SizedBox(
            height: h * 0.05,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                BlocBuilder<HomeViewBloc, HomeViewState>(
                  builder: (context, state) {
                    return GestureDetector(
                        onTap: () {
                          BlocProvider.of<HomeViewBloc>(context)
                              .add(HomePageEvent());
                          BlocProvider.of<SortByBloc>(context).add(SortEnded());
                          BlocProvider.of<FilterBloc>(context)
                              .add(FilterResetEvent());
                        },
                        child: state is CategoryPageState
                            ? const Padding(
                                padding: EdgeInsets.only(left: 20),
                                child: Icon(
                                  CupertinoIcons.back,
                                ),
                              )
                            : const SizedBox());
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 33.0),
                  child: Stack(
                    children: [
                      BlocBuilder<HomeViewBloc, HomeViewState>(
                        builder: (context, state) {
                          return GestureDetector(
                              onTap: () {
                                f.unfocus();
                                BlocProvider.of<FilterBloc>(context)
                                    .add(FilterResetEvent());
                                BlocProvider.of<SortByBloc>(context)
                                    .add(SortEnded());
                                BlocProvider.of<SearchBloc>(context)
                                    .add(SearchEnd());
                                BlocProvider.of<HomeViewBloc>(context)
                                    .add(HomePageEvent());
                              },
                              child: AnimatedContainer(
                                height: state is SearchBarState ? h * 0.05 : 0,
                                duration: const Duration(seconds: 3),
                                curve: Curves.fastOutSlowIn,
                                child: state is SearchBarState
                                    ? const Icon(
                                        CupertinoIcons.back,
                                      )
                                    : const SizedBox(),
                              ));
                        },
                      ),
                      BlocBuilder<HomeViewBloc, HomeViewState>(
                        builder: (context, state) {
                          return AnimatedContainer(
                              alignment: Alignment.center,
                              height: state is HomeViewInitial ||
                                      state is CategoryPageState
                                  ? 30
                                  : 0,
                              duration: const Duration(seconds: 1),
                              curve: Curves.easeInOut,
                              child: Image.asset("assets/images/logo.png",
                                  fit: BoxFit.contain));
                        },
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                const SizedBox(
                  width: 20,
                ),
                BlocBuilder<HomeViewBloc, HomeViewState>(
                  builder: (context, state) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 25.0),
                      child: AnimatedContainer(
                        alignment: Alignment.centerRight,
                        curve: Curves.easeInOut,
                        height: 48,
                        width: state is SearchBarState ? w - 110 : 48,
                        decoration: BoxDecoration(
                          color: state is SearchBarState
                              ? Colors.black
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        duration: const Duration(seconds: 1),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            AnimatedContainer(
                              curve: Curves.easeInOut,
                              duration: const Duration(seconds: 1),
                              width: state is SearchBarState ? w - 158 : 0,
                              child: TextField(
                                focusNode: f,
                                controller: searchField,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                                decoration: const InputDecoration(
                                  contentPadding:
                                      EdgeInsets.only(left: 13, bottom: 5),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                state is SearchBarState
                                    ? BlocProvider.of<SearchBloc>(context)
                                        .add(SearchStart())
                                    : BlocProvider.of<HomeViewBloc>(context)
                                        .add(SearchBarEvent());
                                f.requestFocus();
                              },
                              child: AnimatedContainer(
                                curve: Curves.easeInOut,
                                duration: const Duration(seconds: 1),
                                constraints:
                                    BoxConstraints.tight(const Size(48, 48)),
                                alignment: Alignment.center,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                ),
                                child: AnimatedContainer(
                                  curve: Curves.easeInOut,
                                  duration: const Duration(seconds: 1),
                                  constraints: const BoxConstraints.expand(),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: state is SearchBarState
                                        ? Colors.transparent
                                        : AppColors.primary,
                                    shape: BoxShape.circle,
                                  ),
                                  child: AnimatedContainer(
                                    curve: Curves.easeInOut,
                                    duration: const Duration(seconds: 1),
                                    constraints: BoxConstraints.tight(
                                        const Size(35, 35)),
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: state is SearchBarState
                                          ? Colors.transparent
                                          : Colors.white,
                                      shape: BoxShape.circle,
                                    ),
                                    height: 35,
                                    child: AnimatedContainer(
                                      curve: Curves.easeInOut,
                                      duration: const Duration(seconds: 1),
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: state is SearchBarState
                                            ? Colors.transparent
                                            : AppColors.primary,
                                        shape: BoxShape.circle,
                                      ),
                                      height: 30,
                                      child: AnimatedContainer(
                                        curve: Curves.easeInOut,
                                        duration: const Duration(seconds: 1),
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          color: state is SearchBarState
                                              ? Colors.transparent
                                              : Colors.white,
                                          shape: BoxShape.circle,
                                        ),
                                        height: 23,
                                        child: Icon(
                                          Icons.search,
                                          color: state is SearchBarState
                                              ? Colors.white
                                              : Colors.black,
                                          size: 18,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          SizedBox(
            height: h * 0.95 - 120,
            child: BlocBuilder<SearchBloc, SearchState>(
              builder: (context, state) {
                if (state is Searched) {
                  return SearchPage(
                    isSeller: false,
                    field: searchField.text,
                  );
                }
                return SizedBox(
                  height: h * 0.95 - 120,
                  child: BlocBuilder<HomeViewBloc, HomeViewState>(
                    builder: (context, state) {
                      if (state is CategoryPageState) {
                        return FilteredProductPage(subCategory: state.category);
                      }
                      return SizedBox(
                        height: h * 0.95 - 120,
                        child: Column(
                          children: [
                            const SizedBox(height: 22),
                            Container(
                              height: 28,
                              padding: const EdgeInsets.fromLTRB(33, 0, 0, 0),
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Hey ${localStorage.username}!",
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w800),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Container(
                              height: 20,
                              alignment: Alignment.centerLeft,
                              padding: const EdgeInsets.fromLTRB(33, 0, 0, 0),
                              child: Text(
                                'Scroll to know what\'s near your',
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black.withOpacity(0.37)),
                              ),
                            ),
                            SizedBox(
                              height: h * 0.95 - 200,
                              width: double.maxFinite,
                              child: FutureBuilder(
                                future: DatabaseService().retrieveCategories(),
                                builder: (context,
                                    AsyncSnapshot<List<dynamic>> snapshot) {
                                  if (!snapshot.hasData &&
                                      snapshot.connectionState ==
                                          ConnectionState.none) {
                                    return Container();
                                  }
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const Center(
                                        child: CircularProgressIndicator());
                                  } else if (snapshot.connectionState ==
                                      ConnectionState.done) {
                                    return ListView.builder(
                                      padding: const EdgeInsets.only(
                                        top: 7,
                                      ),
                                      itemCount: snapshot.data!.length,
                                      itemBuilder: (context, index) {
                                        Category category =
                                            snapshot.data![index];
                                        return CategoryCard(
                                          category: category,
                                        );
                                      },
                                    );
                                  } else {
                                    return const Text("error");
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
