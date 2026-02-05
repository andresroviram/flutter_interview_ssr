import 'package:equatable/equatable.dart';

class AddressFilters extends Equatable {
  final String? label; // 'Casa', 'Trabajo', 'Otro'
  final bool? onlyPrimary;
  final String? searchQuery;

  const AddressFilters({this.label, this.onlyPrimary, this.searchQuery});

  AddressFilters copyWith({
    String? label,
    bool? onlyPrimary,
    String? searchQuery,
  }) {
    return AddressFilters(
      label: label ?? this.label,
      onlyPrimary: onlyPrimary ?? this.onlyPrimary,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  AddressFilters clearAll() {
    return const AddressFilters();
  }

  bool get hasActiveFilters {
    return label != null ||
        onlyPrimary != null ||
        (searchQuery?.isNotEmpty ?? false);
  }

  int get activeFiltersCount {
    int count = 0;
    if (label != null) count++;
    if (onlyPrimary == true) count++;
    if (searchQuery != null && searchQuery!.isNotEmpty) count++;
    return count;
  }

  @override
  List<Object?> get props => [label, onlyPrimary, searchQuery];
}
