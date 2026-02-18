import 'package:flutter/material.dart';
import 'package:flutter_interview_ssr/components/widgets/glass/glass.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../features/users/presentation/controllers/user_filters/user_filters_state.dart';

class UserFiltersPanel extends ConsumerStatefulWidget {
  final UserFiltersState initialFilters;
  final Function(UserFiltersState) onApplyFilters;

  const UserFiltersPanel({
    super.key,
    required this.initialFilters,
    required this.onApplyFilters,
  });

  @override
  ConsumerState<UserFiltersPanel> createState() => _UserFiltersPanelState();
}

class _UserFiltersPanelState extends ConsumerState<UserFiltersPanel> {
  late UserFiltersState _filters;
  RangeValues _ageRange = const RangeValues(18, 100);

  @override
  void initState() {
    super.initState();
    _filters = widget.initialFilters;
    if (_filters.minAge != null || _filters.maxAge != null) {
      _ageRange = RangeValues(
        (_filters.minAge ?? 18).toDouble(),
        (_filters.maxAge ?? 100).toDouble(),
      );
    }
  }

  void _applyFilters() {
    widget.onApplyFilters(_filters);
    Navigator.pop(context);
  }

  void _clearFilters() {
    setState(() {
      _filters = const UserFiltersState();
      _ageRange = const RangeValues(18, 100);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return GlassBottomSheet(
      blur: 25.0,
      opacity: 0.2,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Filtros',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Text(
                'Rango de Edad',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              RangeSlider(
                values: _ageRange,
                min: 18,
                max: 100,
                divisions: 82,
                labels: RangeLabels(
                  '${_ageRange.start.round()} años',
                  '${_ageRange.end.round()} años',
                ),
                onChanged: (values) {
                  setState(() {
                    _ageRange = values;
                    _filters = _filters.copyWith(
                      minAge: values.start.round(),
                      maxAge: values.end.round(),
                    );
                  });
                },
              ),
              Text(
                '${_ageRange.start.round()} - ${_ageRange.end.round()} años',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Text(
                'Ordenar por',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: UserSortBy.values.map((sortBy) {
                  final isSelected = _filters.sortBy == sortBy;
                  return FilterChip(
                    label: Text(sortBy.displayName),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        _filters = _filters.copyWith(sortBy: sortBy);
                      });
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              SwitchListTile(
                title: const Text('Orden ascendente'),
                subtitle: Text(
                  _filters.sortAscending ? 'A → Z' : 'Z → A',
                  style: theme.textTheme.bodySmall,
                ),
                value: _filters.sortAscending,
                onChanged: (value) {
                  setState(() {
                    _filters = _filters.copyWith(sortAscending: value);
                  });
                },
                contentPadding: EdgeInsets.zero,
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _clearFilters,
                      child: const Text('Limpiar'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: FilledButton(
                      onPressed: _applyFilters,
                      child: const Text('Aplicar Filtros'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
