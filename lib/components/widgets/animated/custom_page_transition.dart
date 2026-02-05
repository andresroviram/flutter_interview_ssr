import 'package:flutter/material.dart';

class CustomPageTransition extends Page {
  final Widget child;
  final Duration duration;
  final Duration reverseDuration;

  const CustomPageTransition({
    required this.child,
    this.duration = const Duration(milliseconds: 300),
    this.reverseDuration = const Duration(milliseconds: 200),
    super.key,
  });

  @override
  Route createRoute(BuildContext context) {
    return PageRouteBuilder(
      settings: this,
      pageBuilder: (context, animation, secondaryAnimation) => child,
      transitionDuration: duration,
      reverseTransitionDuration: reverseDuration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.02, 0);
        const end = Offset.zero;
        const curve = Curves.easeInOutCubic;

        final slideTween = Tween(begin: begin, end: end);
        final curveTween = CurveTween(curve: curve);
        final slideAnimation = animation.drive(curveTween).drive(slideTween);

        final fadeTween = Tween(begin: 0.0, end: 1.0);
        final fadeAnimation = animation.drive(curveTween).drive(fadeTween);

        return SlideTransition(
          position: slideAnimation,
          child: FadeTransition(opacity: fadeAnimation, child: child),
        );
      },
    );
  }
}
