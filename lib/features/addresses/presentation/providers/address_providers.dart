import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/result.dart';
import '../../../../core/database/database_provider.dart';
import '../../data/datasources/address_datasource.dart';
import '../../data/datasources/address_datasource_impl.dart';
import '../../data/repositories/address_repository_impl.dart';
import '../../domain/repositories/address_repository.dart';
import '../../domain/usecases/address_usecases.dart';

final addressDataSourceProvider = Provider<IAddressDataSource>((ref) {
  final database = ref.watch(databaseProvider);
  return AddressDataSourceImpl(database: database);
});

final addressRepositoryProvider = Provider<IAddressRepository>((ref) {
  final dataSource = ref.watch(addressDataSourceProvider);
  return AddressRepositoryImpl(dataSource);
});

final addressUseCasesProvider = Provider<AddressUseCases>((ref) {
  final repository = ref.watch(addressRepositoryProvider);
  return AddressUseCases(repository);
});

final userAddressesProvider = FutureProvider.autoDispose.family((
  ref,
  int userId,
) async {
  final useCases = ref.watch(addressUseCasesProvider);
  final result = await useCases.getAddressesByUserId(userId);

  if (result.isSuccess) {
    return result.valueOrNull!;
  } else {
    throw Exception(result.errorOrNull?.message ?? 'Error desconocido');
  }
});

final addressByIdProvider = FutureProvider.autoDispose.family((
  ref,
  int id,
) async {
  final useCases = ref.watch(addressUseCasesProvider);
  final result = await useCases.getAddressById(id);

  if (result.isSuccess) {
    return result.valueOrNull!;
  } else {
    throw Exception(result.errorOrNull?.message ?? 'Error desconocido');
  }
});
