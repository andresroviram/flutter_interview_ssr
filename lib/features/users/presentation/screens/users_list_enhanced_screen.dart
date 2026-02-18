import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../components/widgets/confirmation_dialog.dart';
import '../../../../components/widgets/shimmers/shimmers.dart';
import '../../../../components/widgets/animated/animated.dart';
import '../../../../components/widgets/filters/filters.dart';
import '../../../../components/widgets/pagination/pagination.dart';
import '../../domain/entities/user_entity.dart';
import '../providers/user_providers.dart';
import '../controllers/search_query_notifier.dart';
import '../controllers/user_filters/user_filters_notifier.dart';
import '../controllers/user_filters/user_filters_state.dart';
import '../controllers/user_list/user_list_notifier.dart';
import '../controllers/user_list/user_list_state.dart';
import '../widgets/user_card.dart';
import '../widgets/search_bar_widget.dart';

class UsersListEnhancedScreen extends ConsumerStatefulWidget {
  const UsersListEnhancedScreen({super.key});

  @override
  ConsumerState<UsersListEnhancedScreen> createState() =>
      _UsersListEnhancedScreenState();
}

class _UsersListEnhancedScreenState
    extends ConsumerState<UsersListEnhancedScreen> {
  static const _initialFilters = UserFiltersState();
  int _currentPage = 1;
  final int _itemsPerPage = 20;
  List<UserEntity> _displayedUsers = [];

  Future<void> _deleteUser(int userId) async {
    await ref
        .read(userListNotifierProvider.notifier)
        .deleteUser(userId: userId);
  }

  Future<void> _openFiltersPanel() async {
    await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => UserFiltersPanel(
        initialFilters: _initialFilters,
        onApplyFilters: (filters) {
          ref.read(currentFiltersProvider.notifier).updateFilters(filters);
        },
      ),
    );
  }

  void _loadInitialPage(List<UserEntity> allUsers) {
    _currentPage = 1;
    _displayedUsers = allUsers.paginate(_currentPage, _itemsPerPage);
  }

  Future<void> _loadMoreUsers(List<UserEntity> allUsers) async {
    if (!allUsers.hasMorePages(_currentPage, _itemsPerPage)) {
      return;
    }

    await Future.delayed(const Duration(milliseconds: 500));

    setState(() {
      _currentPage++;
      final nextPageUsers = allUsers.paginate(_currentPage, _itemsPerPage);
      _displayedUsers = [..._displayedUsers, ...nextPageUsers];
    });
  }

  @override
  Widget build(BuildContext context) {
    final usersAsync = ref.watch(filteredAndSortedUsersProvider);
    final currentFilters = ref.watch(currentFiltersProvider);

    ref.listen<String>(searchQueryProvider, (previous, next) {
      if (previous != next) {
        setState(() {
          _currentPage = 1;
          _displayedUsers = [];
        });
      }
    });

    ref.listen<UserListState>(userListNotifierProvider, (previous, next) {
      next.when(
        initial: () {},
        loading: () {},
        success: () {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Usuario eliminado')));
        },
        error: (message) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Error: $message')));
        },
      );
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Usuarios'),
        actions: [
          IconButton(
            icon: Badge(
              isLabelVisible: currentFilters.hasActiveFilters,
              label: Text('${currentFilters.activeFiltersCount}'),
              child: const Icon(Icons.filter_list),
            ),
            onPressed: _openFiltersPanel,
            tooltip: 'Filtros',
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              unawaited(ref.refresh(searchUsersProvider.future));
              setState(() {
                _currentPage = 1;
                _displayedUsers = [];
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SearchBarWidget(
              hintText: 'Buscar por nombre o email...',
              onChanged: (query) {
                ref.read(searchQueryProvider.notifier).updateQuery(query);
              },
            ),
          ),
          ActiveFiltersBar(
            filters: currentFilters,
            onUpdateFilters: (filters) {
              ref.read(currentFiltersProvider.notifier).updateFilters(filters);
              setState(() {
                _currentPage = 1;
                _displayedUsers = [];
              });
            },
          ),
          Expanded(
            child: usersAsync.when(
              data: (users) {
                if (users.isEmpty) {
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
                              ref
                                  .read(currentFiltersProvider.notifier)
                                  .resetFilters();
                              ref
                                  .read(searchQueryProvider.notifier)
                                  .updateQuery('');
                            },
                            child: const Text('Limpiar filtros'),
                          ),
                        ],
                      ],
                    ),
                  );
                }

                if (_displayedUsers.isEmpty ||
                    _displayedUsers.length > users.length) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (mounted) {
                      setState(() {
                        _loadInitialPage(users);
                      });
                    }
                  });
                }

                final hasMoreItems = users.hasMorePages(
                  _currentPage,
                  _itemsPerPage,
                );

                return RefreshIndicator(
                  onRefresh: () async {
                    unawaited(ref.refresh(searchUsersProvider.future));
                    setState(() {
                      _currentPage = 1;
                      _displayedUsers = [];
                    });
                  },
                  child: PaginatedListView<UserEntity>(
                    items: _displayedUsers.isEmpty
                        ? users.paginate(1, _itemsPerPage)
                        : _displayedUsers,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    hasMoreItems: hasMoreItems,
                    onLoadMore: () => _loadMoreUsers(users),
                    itemBuilder: (context, user, index) {
                      final delay = Duration(milliseconds: 50 * (index % 10));

                      return SlideInWidget(
                        delay: delay,
                        duration: const Duration(milliseconds: 400),
                        child: UserCard(
                          user: user,
                          onTap: () async {
                            await context.push(
                              '/user/${user.id}/detail',
                              extra: user,
                            );
                            unawaited(ref.refresh(searchUsersProvider.future));
                            setState(() {
                              _currentPage = 1;
                              _displayedUsers = [];
                            });
                          },
                          onEdit: () async {
                            await context.push('/user/edit', extra: user);
                            unawaited(ref.refresh(searchUsersProvider.future));
                            setState(() {
                              _currentPage = 1;
                              _displayedUsers = [];
                            });
                          },
                          onViewAddresses: () {
                            context.push(
                              '/user/${user.id}/addresses',
                              extra: user,
                            );
                          },
                          onDelete: () async {
                            final confirmed =
                                await showDeleteConfirmationDialog(
                                  context: context,
                                  itemName: user.fullName,
                                  title: 'Eliminar Usuario',
                                );
                            if (confirmed == true) {
                              await _deleteUser(user.id);
                            }
                          },
                        ),
                      );
                    },
                  ),
                );
              },
              loading: () => const UserListShimmer(),
              error: (error, _) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 48,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 16),
                    Text('Error: $error'),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        unawaited(ref.refresh(searchUsersProvider.future));
                        setState(() {
                          _currentPage = 1;
                          _displayedUsers = [];
                        });
                      },
                      child: const Text('Reintentar'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await context.push('/user/new');
          unawaited(ref.refresh(searchUsersProvider.future));
          setState(() {
            _currentPage = 1;
            _displayedUsers = [];
          });
        },
        icon: const Icon(Icons.add),
        label: const Text('Nuevo Usuario'),
      ),
    );
  }
}
