import 'package:flutter/material.dart';
import 'package:frontend_for_seller/constants/appColor.dart';

// ignore: must_be_immutable
class MultiSelect extends StatefulWidget {
  MultiSelect({Key? key, required this.choices, required this.selected})
      : super(key: key);
  final List<String> choices;
  List<String> selected;
  @override
  State<MultiSelect> createState() => _MultiSelectState();
}

class _MultiSelectState extends State<MultiSelect> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Wrap(
        children: [
          ...List.generate(widget.choices.length, (index) {
            return MultiSelectChip(
                selected: widget.selected, label: widget.choices[index]);
          }),
        ],
      ),
    );
  }
}

class MultiSelectChip extends StatefulWidget {
  MultiSelectChip({Key? key, required this.selected, required this.label})
      : super(key: key);
  List<String> selected;
  final String label;
  @override
  State<MultiSelectChip> createState() => _MultiSelectChipState();
}

class _MultiSelectChipState extends State<MultiSelectChip> {
  @override
  Widget build(BuildContext context) {
    bool isSelected = widget.selected.contains(widget.label);
    return Padding(
      padding: const EdgeInsets.only(left: 5),
      child: ChoiceChip(
        selectedColor: AppColors.primary.withOpacity(0.5),
        label: Text(widget.label),
        selected: isSelected,
        onSelected: (s) {
          setState(() {
            if (isSelected) {
              widget.selected.remove(widget.label);
            } else {
              widget.selected.add(widget.label);
            }
          });
        },
      ),
    );
  }
}
