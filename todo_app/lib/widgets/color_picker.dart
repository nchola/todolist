import 'package:flutter/material.dart';

class ColorPicker extends StatefulWidget {
  final String selectedColor;
  final ValueChanged<String> onColorSelected;

  ColorPicker({required this.selectedColor, required this.onColorSelected});

  @override
  _ColorPickerState createState() => _ColorPickerState();
}

class _ColorPickerState extends State<ColorPicker> {
  final List<Map<String, String>> colors = [
    {'name': 'Red', 'value': 'red'},
    {'name': 'Orange', 'value': 'orange'},
    {'name': 'Green', 'value': 'green'},
    {'name': 'Black', 'value': 'black'},
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: colors.map((color) {
        return GestureDetector(
          onTap: () {
            widget.onColorSelected(color['value']!);
          },
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: _getColorFromName(color['value']!),
              shape: BoxShape.circle,
              border: Border.all(
                color: widget.selectedColor == color['value']!
                    ? Colors.blue
                    : Colors.transparent,
                width: 2,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Color _getColorFromName(String colorName) {
    switch (colorName) {
      case 'red':
        return Colors.red;
      case 'orange':
        return Colors.orange;
      case 'green':
        return Colors.green;
      case 'black':
        return Colors.black;
      default:
        return Colors.grey;
    }
  }
}
