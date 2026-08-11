import 'package:flutter/material.dart';

class ZenAnimations {
  // Durations
  static const Duration tapFeedback = Duration(milliseconds: 150);
  static const Duration popoverEnter = Duration(milliseconds: 250);
  static const Duration popoverExit = Duration(milliseconds: 175);
  static const Duration sheetEnter = Duration(milliseconds: 300);
  static const Duration sheetExit = Duration(milliseconds: 200);
  static const Duration pageTransition = Duration(milliseconds: 250);
  static const Duration staggerDelay = Duration(milliseconds: 40);

  // Curves (Brutal / Clean spec)
  static const Curve easeOutUI = Cubic(0.1, 1.0, 0.0, 1.0); // Sharp, fast ease-out
  static const Curve easeInOutUI = Cubic(0.8, 0.0, 0.2, 1.0); // Sharp ease-in-out
  
  // Custom Page Transitions
  static Route<T> slideUpRoute<T>(Widget page) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final tween = Tween(begin: const Offset(0.0, 1.0), end: Offset.zero)
            .chain(CurveTween(curve: easeOutUI));
        
        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
      transitionDuration: pageTransition,
      reverseTransitionDuration: sheetExit,
    );
  }

  static Route<T> fadeRoute<T>(Widget page) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation.drive(CurveTween(curve: Curves.easeOut)),
          child: child,
        );
      },
      transitionDuration: popoverEnter,
    );
  }
}
