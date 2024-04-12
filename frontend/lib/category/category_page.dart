import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/config/constants.dart';
import 'package:frontend/home/view/bloc/home_view_bloc.dart';
import 'package:frontend/models/category.dart';

class CategoryPage extends StatelessWidget {
  final Category category;

  const CategoryPage({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        height: h,
        width: w,
        color: Colors.white,
        child: Column(
          children: [
            Container(
              height: h * 0.25,
              width: w,
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: NetworkImage(category.url), fit: BoxFit.cover),
              ),
              child: Stack(
                children: [
                  Container(
                    padding: const EdgeInsets.fromLTRB(0, 40, 20, 0),
                    height: h * 0.25,
                    width: w,
                    decoration: BoxDecoration(
                      gradient: AppColors.headerGradient,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Image.asset("assets/images/logo.png", height: 30),
                        GestureDetector(
                          onTap: () {
                            BlocProvider.of<HomeViewBloc>(context)
                                .add(HomePageEvent());
                            Navigator.pop(context);
                          },
                          child: const Icon(
                            CupertinoIcons.arrow_left,
                            size: 30,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    left: 20,
                    bottom: 0,
                    child: Container(
                      alignment: Alignment.centerLeft,
                      height: h * 0.125,
                      width: w,
                      child: Column(
                        children: [
                          Text(
                            category.title.split(" ")[0],
                            style: const TextStyle(
                              color: Colors.white38,
                              fontWeight: FontWeight.w800,
                              fontSize: 35,
                            ),
                            textAlign: TextAlign.left,
                          ),
                          Text(
                            category.title.replaceFirst(
                                RegExp(category.title.split(" ")[0]), ''),
                            style: TextStyle(
                              color: AppColors.primary.withOpacity(0.38),
                              fontWeight: FontWeight.w800,
                              fontSize: 25,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: h * 0.75,
              child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                  ),
                  scrollDirection: Axis.vertical,
                  itemCount: category.subCategories.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () {
                          BlocProvider.of<HomeViewBloc>(context).add(
                              CategoryEvent(category.subCategories[index]!));
                          Navigator.pop(context);
                        },
                        child: Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Container(
                            padding: const EdgeInsets.only(
                                bottom: 20, left: 10, right: 10),
                            alignment: Alignment.bottomCenter,
                            height: double.maxFinite,
                            width: double.maxFinite,
                            decoration: BoxDecoration(
                              gradient: AppColors.cardGradient,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              category.subCategories[index]!,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
