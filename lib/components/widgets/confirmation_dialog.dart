import 'package:flutter/material.dart';
import 'glass/glass.dart';

Future<bool?> showConfirmationDialog({
  required BuildContext context,
  required String title,
  required String message,
  String confirmText = 'Confirmar',
  String cancelText = 'Cancelar',
  Color? confirmColor,
  bool isDangerous = false,
  bool useGlassEffect = true,
}) {
  if (useGlassEffect) {
    final theme = Theme.of(context);
    return GlassDialog.show<bool>(
      context: context,
      title: title,
      content: Text(
        message,
        style: theme.textTheme.bodyLarge?.copyWith(
          color: theme.colorScheme.onSurface,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text(cancelText),
        ),
        const SizedBox(width: 8),
        FilledButton(
          onPressed: () => Navigator.pop(context, true),
          style: FilledButton.styleFrom(
            backgroundColor: confirmColor ?? (isDangerous ? Colors.red : null),
          ),
          child: Text(confirmText),
        ),
      ],
    );
  }

  return showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text(cancelText),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, true),
          style: TextButton.styleFrom(
            foregroundColor: confirmColor ?? (isDangerous ? Colors.red : null),
          ),
          child: Text(confirmText),
        ),
      ],
    ),
  );
}

Future<bool?> showDeleteConfirmationDialog({
  required BuildContext context,
  required String itemName,
  String title = 'Eliminar',
  bool useGlassEffect = true,
}) {
  return showConfirmationDialog(
    context: context,
    title: title,
    message: '¿Estás seguro de eliminar?\n\n$itemName',
    confirmText: 'Eliminar',
    cancelText: 'Cancelar',
    isDangerous: true,
    useGlassEffect: useGlassEffect,
  );
}
