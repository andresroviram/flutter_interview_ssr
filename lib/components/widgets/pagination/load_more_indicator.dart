import 'package:flutter/material.dart';

class LoadMoreIndicator extends StatelessWidget {
  final bool isLoadingMore;
  final bool hasMoreItems;
  final VoidCallback? onLoadMore;

  const LoadMoreIndicator({
    super.key,
    required this.isLoadingMore,
    required this.hasMoreItems,
    this.onLoadMore,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoadingMore) {
      return const Padding(
        padding: EdgeInsets.all(16.0),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (!hasMoreItems) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Text(
            'No hay más elementos',
            style: TextStyle(color: Colors.grey[600], fontSize: 14),
          ),
        ),
      );
    }

    if (onLoadMore != null) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: OutlinedButton(
            onPressed: onLoadMore,
            child: const Text('Cargar más'),
          ),
        ),
      );
    }

    return const SizedBox.shrink();
  }
}
