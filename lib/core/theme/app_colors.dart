import 'package:flutter/material.dart';

/// Bảng màu pastel kawaii cho light theme và dark theme.
class AppColors {
  // Light theme colors
  static const Color primary = Color(0xFFFFB6C1); // Light Pink
  static const Color secondary = Color(0xFFFFDAB9); // Peach Puff
  static const Color accent = Color(0xFFB5EAD7); // Mint Green
  static const Color background = Color(0xFFFFF5F5); // Snow Pink
  static const Color surface = Color(0xFFFFFFFF); // White
  static const Color textPrimary = Color(0xFF5C4033); // Warm Brown
  static const Color textSecondary = Color(0xFF8B7D6B); // Light Brown
  static const Color error = Color(0xFFFF6B6B); // Soft Red
  static const Color success = Color(0xFF77DD77); // Pastel Green

  // Dark theme colors
  static const Color darkBackground = Color(0xFF1E1E2E);
  static const Color darkSurface = Color(0xFF2D2D3F);
  static const Color darkTextPrimary = Color(0xFFF0E6D6);
  static const Color darkTextSecondary = Color(0xFFBDB0A0);

  /// Lấy màu text chính theo brightness hiện tại
  static Color textPrimaryFor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? darkTextPrimary
        : textPrimary;
  }

  /// Lấy màu text phụ theo brightness hiện tại
  static Color textSecondaryFor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? darkTextSecondary
        : textSecondary;
  }

  /// Lấy màu surface theo brightness hiện tại
  static Color surfaceFor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? darkSurface
        : surface;
  }

  /// Lấy màu background theo brightness hiện tại
  static Color backgroundFor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? darkBackground
        : background;
  }
}
