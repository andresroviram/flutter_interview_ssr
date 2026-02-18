import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../components/widgets/confirmation_dialog.dart';
import '../../../../components/widgets/shimmers/shimmers.dart';
import '../providers/user_providers.dart';
import '../controllers/search_query_notifier.dart';
import '../controllers/user_list/user_list_notifier.dart';
import '../controllers/user_list/user_list_state.dart';
import '../widgets/user_card.dart';
import '../widgets/search_bar_widget.dart';

class UsersListScreen extends ConsumerStatefulWidget {
  const UsersListScreen({super.key});

  @override
  ConsumerState<UsersListScreen> createState() => _UsersListScreenState();
}

class _UsersListScreenState extends ConsumerState<UsersListScreen> {
  Future<void> _deleteUser(int userId) async {
    await ref
        .read(userListNotifierProvider.notifier)
        .deleteUser(userId: userId);
  }

  @override
  Widget build(BuildContext context) {
    final usersAsync = ref.watch(searchUsersProvider);

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
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.invalidate(searchUsersProvider),
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
          Expanded(
            child: usersAsync.when(
              data: (users) {
                if (users.isEmpty) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.person_outline,
                          size: 64,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'No hay usuarios',
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                      ],
                    ),
                  );
                }
                return RefreshIndicator(
                  onRefresh: () async {
                    ref.invalidate(usersProvider);
                  },
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: users.length,
                    itemBuilder: (context, index) {
                      final user = users[index];
                      return UserCard(
                        user: user,
                        onTap: () {
                          context.push('/user/${user.id}/detail', extra: user);
                        },
                        onEdit: () {
                          context.push('/user/edit', extra: user);
                        },
                        onViewAddresses: () {
                          context.push(
                            '/user/${user.id}/addresses',
                            extra: user,
                          );
                        },
                        onDelete: () async {
                          final confirmed = await showDeleteConfirmationDialog(
                            context: context,
                            itemName: user.fullName,
                            title: 'Eliminar Usuario',
                          );
                          if (confirmed == true) {
                            await _deleteUser(user.id);
                          }
                        },
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
                      onPressed: () => ref.invalidate(usersProvider),
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
        onPressed: () {
          context.push('/user/new');
        },
        icon: const Icon(Icons.add),
        label: const Text('Nuevo Usuario'),
      ),
    );
  }
}
