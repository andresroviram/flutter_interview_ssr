import 'package:flutter/material.dart';
import 'glass_container.dart';

class GlassCard extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final double blur;
  final double opacity;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;

  const GlassCard({
    super.key,
    required this.child,
    this.onTap,
    this.blur = 10.0,
    this.opacity = 0.1,
    this.padding,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    final glassContainer = GlassContainer(
      blur: blur,
      opacity: opacity,
      padding: padding ?? const EdgeInsets.all(16),
      margin: margin,
      borderRadius: BorderRadius.circular(16),
      child: child,
    );

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: glassContainer,
      );
    }

    return glassContainer;
  }
}
