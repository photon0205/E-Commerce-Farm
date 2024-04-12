import 'package:flutter/material.dart';
import 'package:frontend/category/category_page.dart';
import 'package:frontend/config/constants.dart';

import '../../models/category.dart';

class CategoryCard extends StatelessWidget {
  const CategoryCard({
    Key? key,
    required this.category,
  }) : super(key: key);

  final Category category;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(9.0),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => CategoryPage(
                        category: category,
                      )));
        },
        child: Container(
          height: 150,
          width: 350,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: NetworkImage(category.url), fit: BoxFit.cover),
              borderRadius: BorderRadius.circular(15),
              color: Colors.grey),
          child: Container(
            height: double.maxFinite,
            width: double.maxFinite,
            decoration: BoxDecoration(
              gradient: AppColors.cardGradient,
              borderRadius: BorderRadius.circular(15),
            ),
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  category.headline,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
                Text(
                  category.description_,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(
                  height: 30,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
