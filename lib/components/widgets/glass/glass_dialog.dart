import 'package:flutter/material.dart';
import 'glass_container.dart';

class GlassDialog extends StatelessWidget {
  final String? title;
  final Widget content;
  final List<Widget>? actions;
  final double blur;
  final double opacity;

  const GlassDialog({
    super.key,
    this.title,
    required this.content,
    this.actions,
    this.blur = 20.0,
    this.opacity = 0.25,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: GlassContainer(
        blur: blur,
        opacity: opacity,
        borderRadius: BorderRadius.circular(28),
        padding: const EdgeInsets.all(24),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [
                  Colors.grey[850]!.withValues(alpha: 0.95),
                  Colors.grey[900]!.withValues(alpha: 0.95),
                ]
              : [
                  Colors.white.withValues(alpha: 0.95),
                  Colors.grey[50]!.withValues(alpha: 0.95),
                ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (title != null) ...[
              Text(
                title!,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
            ],
            content,
            if (actions != null && actions!.isNotEmpty) ...[
              const SizedBox(height: 24),
              Row(mainAxisAlignment: MainAxisAlignment.end, children: actions!),
            ],
          ],
        ),
      ),
    );
  }

  static Future<T?> show<T>({
    required BuildContext context,
    String? title,
    required Widget content,
    List<Widget>? actions,
    double blur = 20.0,
    double opacity = 0.25,
    bool barrierDismissible = true,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return showDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      barrierColor: isDark
          ? Colors.black.withValues(alpha: 0.6)
          : Colors.black.withValues(alpha: 0.4),
      builder: (context) => GlassDialog(
        title: title,
        content: content,
        actions: actions,
        blur: blur,
        opacity: opacity,
      ),
    );
  }
}
