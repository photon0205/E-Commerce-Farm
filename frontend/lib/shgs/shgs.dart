import 'package:flutter/material.dart';
import 'package:frontend/config/constants.dart';

class SHGs extends StatelessWidget {
  const SHGs({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return SizedBox(
      height: h,
      width: w,
      child: Column(
        children: [
          SizedBox(height: h * 0.05),
          Container(
            padding: const EdgeInsets.only(left: 30),
            alignment: Alignment.centerLeft,
            child: const Text(
              "JOIN",
              style: TextStyle(
                color: Colors.black,
                fontSize: 45,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          SizedBox(
            height: 0.05 * h,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(
                  width: 30,
                ),
                Text(
                  'To Support',
                  style: TextStyle(
                      color: AppColors.primary.withOpacity(0.7),
                      fontSize: 25,
                      fontWeight: FontWeight.w800),
                ),
                Container(
                  padding: const EdgeInsets.only(bottom: 7),
                  width: w * 0.5,
                  height: 0.05 * h,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SizedBox(
                          height: 15,
                          child: Image.asset(
                            "assets/images/logo.png",
                          )),
                      Container(
                        height: 2.2,
                        color: AppColors.primary,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 0.8 * h - 56,
            child: ListView.builder(
              itemCount: 5,
              itemBuilder: (context, index) {
                return Padding(
                  padding:
                      const EdgeInsets.only(left: 20, bottom: 20, right: 20),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    height: 220,
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
