import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Rating extends StatelessWidget {
  const Rating({Key? key, required this.rating, required this.order}) : super(key: key);
  final int rating;
  final bool order;

  @override
  Widget build(BuildContext context) {
    List<String> listRate = order?[
      "assets/rating/rateInput1.svg",
      "assets/rating/rateInput2.svg",
      "assets/rating/rateInput3.svg",
      "assets/rating/rateInput4.svg",
      "assets/rating/rateInput5.svg"
    ]: [
      "assets/rating/Rate1.svg",
      "assets/rating/Rate2.svg",
      "assets/rating/Rate3.svg",
      "assets/rating/Rate4.svg",
      "assets/rating/Rate5.svg"
    ];
    return SizedBox(
      height: 15,
      child: Row(
        children: [
          ...List.generate(
              rating,
              (index) => Container(
                padding: const EdgeInsets.only(left: 2),
                child: SvgPicture.asset(listRate[index]))),
        ],
      ),
    );
  }
}
