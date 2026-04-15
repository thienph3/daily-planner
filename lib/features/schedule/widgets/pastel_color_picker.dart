import 'package:flutter/material.dart';

/// Widget cho phép chọn màu pastel từ danh sách định sẵn
class PastelColorPicker extends StatelessWidget {
  final int selectedColor;
  final ValueChanged<int> onColorSelected;

  const PastelColorPicker({
    super.key,
    required this.selectedColor,
    required this.onColorSelected,
  });

  /// Danh sách 8 màu pastel
  static const List<int> pastelColors = [
    0xFFFFB6C1, // Light Pink
    0xFFFFDAB9, // Peach Puff
    0xFFB5EAD7, // Mint Green
    0xFFE2B6FF, // Lavender
    0xFFFFE4B5, // Moccasin
    0xFFADD8E6, // Light Blue
    0xFFFFB347, // Pastel Orange
    0xFF77DD77, // Pastel Green
  ];

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: pastelColors.map((color) {
        final isSelected = color == selectedColor;
        return GestureDetector(
          onTap: () => onColorSelected(color),
          child: Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: Color(color),
              shape: BoxShape.circle,
              border: isSelected
                  ? Border.all(color: const Color(0xFF5C4033), width: 2)
                  : null,
            ),
            child: isSelected
                ? const Icon(Icons.check, size: 16, color: Color(0xFF5C4033))
                : null,
          ),
        );
      }).toList(),
    );
  }
}
