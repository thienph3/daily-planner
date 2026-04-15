import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Helper tạo CustomTransitionPage cho GoRouter routes.
class PageTransitionHelper {
  PageTransitionHelper._();

  static const Duration defaultDuration = Duration(milliseconds: 300);

  /// Fade transition cho tab navigation.
  static CustomTransitionPage fadeTransition({
    required LocalKey key,
    required Widget child,
    Duration duration = defaultDuration,
  }) {
    return CustomTransitionPage(
      key: key,
      child: child,
      transitionDuration: duration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(opacity: animation, child: child);
      },
    );
  }

  /// Slide up + fade transition cho sub-routes (settings, detail pages).
  static CustomTransitionPage slideUpTransition({
    required LocalKey key,
    required Widget child,
    Duration duration = defaultDuration,
  }) {
    return CustomTransitionPage(
      key: key,
      child: child,
      transitionDuration: duration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final offsetAnimation = Tween<Offset>(
          begin: const Offset(0, 0.3),
          end: Offset.zero,
        ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOut));
        return SlideTransition(
          position: offsetAnimation,
          child: FadeTransition(opacity: animation, child: child),
        );
      },
    );
  }
}
