import 'dart:ui';
import 'package:flutter/material.dart';

class GlassBottomSheet extends StatelessWidget {
  final Widget child;
  final double blur;
  final double opacity;

  const GlassBottomSheet({
    super.key,
    required this.child,
    this.blur = 20.0,
    this.opacity = 0.2,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                isDark
                    ? Colors.grey[900]!.withValues(alpha: opacity + 0.6)
                    : Colors.white.withValues(alpha: opacity + 0.7),
                isDark
                    ? Colors.grey[800]!.withValues(alpha: opacity + 0.7)
                    : Colors.white.withValues(alpha: opacity + 0.8),
              ],
            ),
            border: Border(
              top: BorderSide(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.1)
                    : Colors.white.withValues(alpha: 0.5),
                width: 1,
              ),
            ),
          ),
          child: child,
        ),
      ),
    );
  }

  static Future<T?> show<T>({
    required BuildContext context,
    required Widget child,
    double blur = 20.0,
    double opacity = 0.2,
    bool isDismissible = true,
    bool enableDrag = true,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      backgroundColor: Colors.transparent,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      builder: (context) =>
          GlassBottomSheet(blur: blur, opacity: opacity, child: child),
    );
  }
}
