import 'package:flutter/cupertino.dart';

class ConfirmPage extends StatelessWidget {
  const ConfirmPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return SizedBox(
      height: h,
      width: w,
      child: Center(
        child: Column(
          children: [
            Container(
              height: w*0.5,
              width: w*0.5,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(w*0.25),
              ),
              child: Image.asset('assets/images/tick.png',fit: BoxFit.fill),
            ),
            const SizedBox(
              height: 50,
              child: Text("Confirm Message"),
            ),
          ],
        ),
      ),
    );
  }
}
