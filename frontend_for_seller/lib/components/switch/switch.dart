import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend_for_seller/constants/appColor.dart';

class Switch extends StatefulWidget {
  const Switch(
      {Key? key,
      required this.switchController,
      required this.choice1,
      required this.choice2,
      required this.selected})
      : super(key: key);
  final SwitchController switchController;
  final String choice1;
  final String choice2;
  final int selected;

  @override
  State<Switch> createState() => _SwitchState();
}

class _SwitchState extends State<Switch> {
  int selectedIndex = 0;
  @override
  void initState() {
    selectedIndex = widget.selected;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: selectedIndex == 0
              ? CupertinoColors.activeBlue.withOpacity(0.7)
              : Colors.grey,
          borderRadius: BorderRadius.circular(50.0)),
      height: 20,
      width: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onHorizontalDragUpdate: (details) {
              int sensitivity = 2;
              if (details.delta.dx > sensitivity) {
                widget.switchController.selectedIndex = 1;
                setState(() {
                  selectedIndex = 1;
                });
              }
            },
            child: Container(
              alignment: Alignment.center,
              height: 20,
              width: selectedIndex == 1 ? 30 : 20,
              decoration: BoxDecoration(
                color:
                    selectedIndex == 1 ? Colors.transparent : AppColors.primary,
                borderRadius: BorderRadius.circular(20),
              ),
              child: selectedIndex == 1
                  ? Text(
                      widget.choice2,
                      style: const TextStyle(color: Colors.white, fontSize: 7),
                    )
                  : const Text(''),
            ),
          ),
          GestureDetector(
            onHorizontalDragUpdate: (details) {
              int sensitivity = 2;
              if (details.delta.dx < -sensitivity) {
                widget.switchController.selectedIndex = 0;
                setState(() {
                  selectedIndex = 0;
                });
              }
            },
            child: Container(
              alignment: Alignment.center,
              height: 20,
              width: selectedIndex == 0 ? 30 : 20,
              decoration: BoxDecoration(
                color:
                    selectedIndex == 0 ? Colors.transparent : AppColors.primary,
                borderRadius: BorderRadius.circular(20),
              ),
              child: selectedIndex == 0
                  ? Text(
                      widget.choice1,
                      style: const TextStyle(color: Colors.white, fontSize: 8),
                    )
                  : const Text(''),
            ),
          ),
        ],
      ),
    );
  }
}

class SwitchController extends ChangeNotifier {
  int selectedIndex = 0;

  void setIndex(int index) {
    selectedIndex = index;
    notifyListeners();
  }
}
