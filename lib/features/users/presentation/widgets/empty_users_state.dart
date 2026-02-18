import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controllers/search_query_notifier.dart';
import '../controllers/user_filters/user_filters_notifier.dart';
import '../controllers/user_filters/user_filters_state.dart';

class EmptyUsersState extends ConsumerWidget {
  final UserFiltersState currentFilters;

  const EmptyUsersState({
    super.key,
    required this.currentFilters,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            currentFilters.hasActiveFilters
                ? Icons.search_off
                : Icons.person_outline,
            size: 64,
            color: Colors.grey,
          ),
          const SizedBox(height: 16),
          Text(
            currentFilters.hasActiveFilters
                ? 'No se encontraron usuarios'
                : 'No hay usuarios',
            style: const TextStyle(
              fontSize: 18,
              color: Colors.grey,
            ),
          ),
          if (currentFilters.hasActiveFilters) ...[
            const SizedBox(height: 8),
            TextButton(
              onPressed: () {
                ref.read(currentFiltersProvider.notifier).resetFilters();
                ref.read(searchQueryProvider.notifier).updateQuery('');
              },
              child: const Text('Limpiar filtros'),
            ),
          ],
        ],
      ),
    );
  }
}
