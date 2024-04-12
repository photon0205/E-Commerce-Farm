import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class RateInput extends StatefulWidget {
  const RateInput({
    super.key,
    required this.onTap,
  });
  final Function onTap;
  @override
  State<RateInput> createState() => _RateInputState();
}

class _RateInputState extends State<RateInput> {
  int rating = 0;
  @override
  Widget build(BuildContext context) {
    List<String> listRate = [
      "assets/rating/rateInput1.svg",
      "assets/rating/rateInput2.svg",
      "assets/rating/rateInput3.svg",
      "assets/rating/rateInput4.svg",
      "assets/rating/rateInput5.svg"
    ];
    return SizedBox(
      height: 25,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ...List.generate(
              listRate.length,
              (index) => Padding(
                    padding: const EdgeInsets.only(left: 2),
                    child: InkWell(
                      onTap: () {
                        widget.onTap(index + 1);
                        setState(() {
                          rating = index + 1;
                        });
                      },
                      child: Opacity(
                          opacity: rating > index ? 1 : 0.5,
                          child: SvgPicture.asset(
                            listRate[index],
                          )),
                    ),
                  )),
        ],
      ),
    );
  }
}
