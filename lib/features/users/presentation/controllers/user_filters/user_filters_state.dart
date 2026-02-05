import 'package:equatable/equatable.dart';

class UserFiltersState extends Equatable {
  final int? minAge;
  final int? maxAge;
  final String? searchQuery;
  final UserSortBy sortBy;
  final bool sortAscending;

  const UserFiltersState({
    this.minAge,
    this.maxAge,
    this.searchQuery,
    this.sortBy = UserSortBy.name,
    this.sortAscending = true,
  });

  UserFiltersState copyWith({
    int? minAge,
    int? maxAge,
    String? searchQuery,
    UserSortBy? sortBy,
    bool? sortAscending,
  }) {
    return UserFiltersState(
      minAge: minAge ?? this.minAge,
      maxAge: maxAge ?? this.maxAge,
      searchQuery: searchQuery ?? this.searchQuery,
      sortBy: sortBy ?? this.sortBy,
      sortAscending: sortAscending ?? this.sortAscending,
    );
  }

  UserFiltersState clearAgeFilter() {
    return copyWith(minAge: null, maxAge: null);
  }

  UserFiltersState clearSearch() {
    return copyWith(searchQuery: null);
  }

  UserFiltersState clearAll() {
    return const UserFiltersState();
  }

  bool get hasActiveFilters {
    return minAge != null ||
        maxAge != null ||
        (searchQuery?.isNotEmpty ?? false);
  }

  int get activeFiltersCount {
    int count = 0;
    if (minAge != null || maxAge != null) count++;
    if (searchQuery != null && searchQuery!.isNotEmpty) count++;
    return count;
  }

  @override
  List<Object?> get props => [
        minAge,
        maxAge,
        searchQuery,
        sortBy,
        sortAscending,
      ];
}

enum UserSortBy { name, age, email, createdDate }

extension UserSortByExtension on UserSortBy {
  String get displayName {
    switch (this) {
      case UserSortBy.name:
        return 'Nombre';
      case UserSortBy.age:
        return 'Edad';
      case UserSortBy.email:
        return 'Email';
      case UserSortBy.createdDate:
        return 'Fecha de creación';
    }
  }
}
