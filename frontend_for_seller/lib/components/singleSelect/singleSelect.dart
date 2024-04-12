import 'package:flutter/material.dart';
import 'package:frontend_for_seller/constants/appColor.dart';

class SingleSelect extends StatefulWidget {
  SingleSelect({
    Key? key,
    required this.choices,
    required this.selected,
  }) : super(key: key);
  final List<String> choices;
  List<int> selected;
  @override
  State<SingleSelect> createState() => _SingleSelectState();
}

class _SingleSelectState extends State<SingleSelect> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      scrollDirection: Axis.horizontal,
      children: [
        ...List.generate(
          widget.choices.length,
          (index) => Padding(
            padding: const EdgeInsets.all(5),
            child: ChoiceChip(
              disabledColor: Colors.white,
              selectedColor: AppColors.primary.withOpacity(0.5),
              label: Text(
                widget.choices[index],
                style: const TextStyle(color: Colors.black87),
              ),
              selected: widget.selected.contains(index),
              onSelected: (s) {
                setState(() {
                  widget.selected.clear();
                  widget.selected.add(index);
                });
              },
            ),
          ),
        )
      ],
    );
  }
}
