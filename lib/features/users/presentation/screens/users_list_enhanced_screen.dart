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
import '../controllers/pagination/paginate_notifier.dart';
import '../widgets/user_card.dart';
import '../widgets/search_bar_widget.dart';
import '../widgets/empty_users_state.dart';

class UsersListEnhancedScreen extends ConsumerStatefulWidget {
  const UsersListEnhancedScreen({super.key});

  @override
  ConsumerState<UsersListEnhancedScreen> createState() =>
      _UsersListEnhancedScreenState();
}

class _UsersListEnhancedScreenState
    extends ConsumerState<UsersListEnhancedScreen> {
  static const _initialFilters = UserFiltersState();

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

  Future<void> _resetUsersList() async {
    final data = await ref.refresh(searchUsersProvider.future);
    if (!mounted) return;
    ref.read(usersPaginateProvider.notifier).reset(data);
  }

  @override
  Widget build(BuildContext context) {
    final usersAsync = ref.watch(filteredAndSortedUsersProvider);
    final currentFilters = ref.watch(currentFiltersProvider);
    final paginateState = ref.watch(usersPaginateProvider);

    ref.listen<String>(searchQueryProvider, (previous, next) {
      if (previous != next) {
        ref.read(usersPaginateProvider.notifier).resetPagination();
      }
    });

    ref.listen<UserListState>(userListNotifierProvider, (previous, next) {
      next.whenOrNull(
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
            onPressed: _resetUsersList,
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
              ref.read(usersPaginateProvider.notifier).resetPagination();
            },
          ),
          Expanded(
            child: usersAsync.when(
              data: (users) {
                if (users.isEmpty) {
                  return EmptyUsersState(currentFilters: currentFilters);
                }

                if (paginateState.displayedItems.isEmpty ||
                    paginateState.displayedItems.length > users.length) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (mounted) {
                      ref
                          .read(usersPaginateProvider.notifier)
                          .loadInitialPage(users);
                    }
                  });
                }

                final hasMoreItems = users.hasMorePages(
                  paginateState.currentPage,
                  paginateState.itemsPerPage,
                );

                return RefreshIndicator(
                  onRefresh: _resetUsersList,
                  child: PaginatedListView<UserEntity>(
                    items: paginateState.displayedItems.isEmpty
                        ? users.paginate(1, paginateState.itemsPerPage)
                        : paginateState.displayedItems,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    hasMoreItems: hasMoreItems,
                    onLoadMore: () => ref
                        .read(usersPaginateProvider.notifier)
                        .loadMoreItems(users),
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
                            await _resetUsersList();
                          },
                          onEdit: () async {
                            await context.push('/user/edit', extra: user);
                            await _resetUsersList();
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
                      onPressed: _resetUsersList,
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
          await _resetUsersList();
        },
        icon: const Icon(Icons.add),
        label: const Text('Nuevo Usuario'),
      ),
    );
  }
}
