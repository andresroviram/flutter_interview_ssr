import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/result.dart';
import '../../../../core/database/database_provider.dart';
import '../../data/datasources/user_datasource.dart';
import '../../data/datasources/user_datasource_impl.dart';
import '../../data/repositories/user_repository_impl.dart';
import '../../domain/repositories/user_repository.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/usecases/user_usecases.dart';
import '../controllers/search_query_notifier.dart';
import '../controllers/user_filters/user_filters_notifier.dart';
import '../controllers/user_filters/user_filters_state.dart';

final userDataSourceProvider = Provider<IUserDataSource>((ref) {
  final database = ref.watch(databaseProvider);
  return UserDataSourceImpl(database: database);
});

final userRepositoryProvider = Provider<IUserRepository>((ref) {
  final dataSource = ref.watch(userDataSourceProvider);
  return UserRepositoryImpl(dataSource);
});

final userUseCasesProvider = Provider<UserUseCases>((ref) {
  final repository = ref.watch(userRepositoryProvider);
  return UserUseCases(repository);
});

final usersProvider = FutureProvider.autoDispose((ref) async {
  final useCases = ref.watch(userUseCasesProvider);
  final result = await useCases.getAllUsers();

  if (result.isSuccess) {
    return result.valueOrNull!;
  } else {
    throw Exception(result.errorOrNull?.message ?? 'Error desconocido');
  }
});

final userByIdProvider = FutureProvider.autoDispose.family((ref, int id) async {
  final useCases = ref.watch(userUseCasesProvider);
  final result = await useCases.getUserById(id);

  if (result.isSuccess) {
    return result.valueOrNull!;
  } else {
    throw Exception(result.errorOrNull?.message ?? 'Error desconocido');
  }
});

final searchUsersProvider = FutureProvider.autoDispose((ref) async {
  final query = ref.watch(searchQueryProvider);
  final useCases = ref.watch(userUseCasesProvider);
  final result = await useCases.searchUsers(query);

  if (result.isSuccess) {
    return result.valueOrNull!;
  } else {
    throw Exception(result.errorOrNull?.message ?? 'Error desconocido');
  }
});

final filteredAndSortedUsersProvider =
    Provider.autoDispose<AsyncValue<List<UserEntity>>>((ref) {
      final usersAsync = ref.watch(searchUsersProvider);
      final filters = ref.watch(currentFiltersProvider);

      return usersAsync.when(
        data: (users) => AsyncValue.data(_applyFiltersLogic(users, filters)),
        loading: () => const AsyncValue.loading(),
        error: (error, stack) => AsyncValue.error(error, stack),
      );
    });

List<UserEntity> _applyFiltersLogic(
  List<UserEntity> users,
  UserFiltersState filters,
) {
  var filtered = users;

  if (filters.minAge != null || filters.maxAge != null) {
    filtered = filtered.where((user) {
      final age = user.age;
      final minAge = filters.minAge ?? 18;
      final maxAge = filters.maxAge ?? 100;
      return age >= minAge && age <= maxAge;
    }).toList();
  }

  filtered = List.from(filtered);
  filtered.sort((a, b) {
    int comparison = 0;
    switch (filters.sortBy) {
      case UserSortBy.name:
        comparison = a.fullName.compareTo(b.fullName);
      case UserSortBy.age:
        comparison = a.age.compareTo(b.age);
      case UserSortBy.email:
        comparison = a.email.compareTo(b.email);
      case UserSortBy.createdDate:
        comparison = a.birthDate.compareTo(b.birthDate);
    }
    return filters.sortAscending ? comparison : -comparison;
  });

  return filtered;
}
