import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';
import 'app_text_styles.dart';
import '../constants/app_spacing.dart';

/// Tổng hợp ThemeData cho light và dark mode từ AppColors, AppTextStyles.
class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme => ThemeData(
    brightness: Brightness.light,
    colorScheme: ColorScheme.light(
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      tertiary: AppColors.accent,
      surface: AppColors.surface,
      error: AppColors.error,
      onPrimary: AppColors.textPrimary,
      onSecondary: AppColors.textPrimary,
      onSurface: AppColors.textPrimary,
      onError: Colors.white,
    ),
    scaffoldBackgroundColor: AppColors.background,
    textTheme: AppTextStyles.textTheme.apply(
      bodyColor: AppColors.textPrimary,
      displayColor: AppColors.textPrimary,
    ),
    // Card theme
    cardTheme: CardThemeData(
      color: AppColors.surface,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusCard),
      ),
    ),
    // AppBar theme
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: GoogleFonts.nunito(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
      ),
      iconTheme: const IconThemeData(color: AppColors.textPrimary),
    ),
    // Button theme
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textPrimary,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.borderRadiusButton),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.paddingStandard,
          vertical: AppSpacing.gapItem,
        ),
      ),
    ),
    // Ripple/splash pastel
    splashColor: AppColors.primary.withValues(alpha: 0.2),
    highlightColor: AppColors.primary.withValues(alpha: 0.1),
    // Input decoration
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusInput),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusInput),
        borderSide: const BorderSide(color: AppColors.primary),
      ),
    ),
    // BottomNavigationBar
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.surface,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: AppColors.textSecondary,
      elevation: 0,
    ),
    // Dialog
    dialogTheme: DialogThemeData(
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusCard),
      ),
    ),
  );

  static ThemeData get darkTheme => ThemeData(
    brightness: Brightness.dark,
    colorScheme: ColorScheme.dark(
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      tertiary: AppColors.accent,
      surface: AppColors.darkSurface,
      error: AppColors.error,
      onPrimary: const Color(0xFF2D2D3F),
      onSecondary: const Color(0xFF2D2D3F),
      onSurface: AppColors.darkTextPrimary,
      onError: Colors.white,
    ),
    scaffoldBackgroundColor: AppColors.darkBackground,
    textTheme: AppTextStyles.textTheme.apply(
      bodyColor: AppColors.darkTextPrimary,
      displayColor: AppColors.darkTextPrimary,
    ),
    cardTheme: CardThemeData(
      color: AppColors.darkSurface,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusCard),
      ),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.darkSurface,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: GoogleFonts.nunito(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: AppColors.darkTextPrimary,
      ),
      iconTheme: const IconThemeData(color: AppColors.darkTextPrimary),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: const Color(0xFF2D2D3F),
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.borderRadiusButton),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.paddingStandard,
          vertical: AppSpacing.gapItem,
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.darkTextSecondary,
      ),
    ),
    splashColor: AppColors.primary.withValues(alpha: 0.3),
    highlightColor: AppColors.primary.withValues(alpha: 0.15),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusInput),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusInput),
        borderSide: const BorderSide(color: AppColors.primary),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusInput),
        borderSide: BorderSide(color: AppColors.darkTextSecondary.withValues(alpha: 0.5)),
      ),
      labelStyle: const TextStyle(color: AppColors.darkTextSecondary),
      hintStyle: TextStyle(color: AppColors.darkTextSecondary.withValues(alpha: 0.6)),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.darkSurface,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: AppColors.darkTextSecondary,
      elevation: 0,
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: AppColors.darkSurface,
      titleTextStyle: GoogleFonts.nunito(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: AppColors.darkTextPrimary,
      ),
      contentTextStyle: TextStyle(
        color: AppColors.darkTextPrimary,
        fontSize: 14,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusCard),
      ),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: AppColors.darkSurface,
      labelStyle: TextStyle(color: AppColors.darkTextPrimary),
      secondaryLabelStyle: TextStyle(color: AppColors.darkTextPrimary),
    ),
    listTileTheme: ListTileThemeData(
      textColor: AppColors.darkTextPrimary,
      iconColor: AppColors.darkTextSecondary,
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return AppColors.primary;
        return AppColors.darkTextSecondary;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.primary.withValues(alpha: 0.4);
        }
        return AppColors.darkSurface;
      }),
    ),
    popupMenuTheme: PopupMenuThemeData(
      color: AppColors.darkSurface,
      textStyle: TextStyle(color: AppColors.darkTextPrimary),
    ),
    dropdownMenuTheme: DropdownMenuThemeData(
      textStyle: TextStyle(color: AppColors.darkTextPrimary),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: AppColors.darkSurface,
      contentTextStyle: TextStyle(color: AppColors.darkTextPrimary),
    ),
  );
}
