import 'package:flutter/material.dart';
import '../../../features/users/presentation/controllers/user_filters/user_filters_state.dart';
import 'active_filter_chip.dart';

class ActiveFiltersBar extends StatelessWidget {
  final UserFiltersState filters;
  final Function(UserFiltersState) onUpdateFilters;

  const ActiveFiltersBar({
    super.key,
    required this.filters,
    required this.onUpdateFilters,
  });

  @override
  Widget build(BuildContext context) {
    if (!filters.hasActiveFilters) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            if (filters.minAge != null || filters.maxAge != null)
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ActiveFilterChip(
                  label:
                      'Edad: ${filters.minAge ?? 18}-${filters.maxAge ?? 100}',
                  onDeleted: () {
                    onUpdateFilters(filters.clearAgeFilter());
                  },
                ),
              ),
            if (filters.hasActiveFilters)
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: TextButton.icon(
                  onPressed: () {
                    onUpdateFilters(filters.clearAll());
                  },
                  icon: const Icon(Icons.clear_all, size: 16),
                  label: const Text('Limpiar todo'),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
