import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Typography sử dụng Google Fonts (Nunito) cho phong cách kawaii.
class AppTextStyles {
  static TextTheme get textTheme => TextTheme(
    headlineLarge: GoogleFonts.nunito(
      fontSize: 24,
      fontWeight: FontWeight.bold,
    ),
    headlineMedium: GoogleFonts.nunito(
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
    bodyLarge: GoogleFonts.nunito(
      fontSize: 16,
      fontWeight: FontWeight.normal,
    ),
    bodyMedium: GoogleFonts.nunito(
      fontSize: 14,
      fontWeight: FontWeight.normal,
    ),
    bodySmall: GoogleFonts.nunito(
      fontSize: 12,
      fontWeight: FontWeight.w300,
    ),
  );
}
