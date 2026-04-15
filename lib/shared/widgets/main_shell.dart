import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/theme/app_colors.dart';

/// Layout shell chung chứa BottomNavigationBar kawaii cho 5 tab chính.
class MainShell extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const MainShell({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: navigationShell.currentIndex,
        onTap: (index) => navigationShell.goBranch(index),
        type: BottomNavigationBarType.fixed,
        backgroundColor: Theme.of(context).colorScheme.surface,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textSecondary,
        selectedLabelStyle: GoogleFonts.nunito(
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: GoogleFonts.nunito(fontSize: 12),
        elevation: 0,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.check_circle_outline),
            label: 'To-Do',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.schedule),
            label: 'Lịch trình',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.restaurant_outlined),
            label: 'Bữa ăn',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book_outlined),
            label: 'Nhật ký',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.emoji_emotions_outlined),
            label: 'Mood',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart_rounded),
            label: 'Tiến độ',
          ),
        ],
      ),
    );
  }
}
