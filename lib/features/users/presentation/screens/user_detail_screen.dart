import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../components/widgets/glass/glass.dart';
import '../../../../components/widgets/shimmers/shimmers.dart';
import '../../../../core/utils/formatters.dart';
import '../../domain/entities/user_entity.dart';
import '../providers/user_providers.dart';

class UserDetailScreen extends ConsumerWidget {
  final UserEntity user;

  const UserDetailScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final userAsync = ref.watch(userByIdProvider(user.id));

    return userAsync.when(
      data: (currentUser) =>
          _buildContent(context, currentUser, theme, colorScheme, ref),
      loading: () =>
          Scaffold(appBar: AppBar(), body: const UserDetailShimmer()),
      error: (error, _) => Scaffold(
        appBar: AppBar(),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              Text('Error al cargar usuario: $error'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.invalidate(userByIdProvider(user.id)),
                child: const Text('Reintentar'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    UserEntity currentUser,
    ThemeData theme,
    ColorScheme colorScheme,
    WidgetRef ref,
  ) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(userByIdProvider(user.id));
          await ref.read(userByIdProvider(user.id).future);
        },
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 200,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        colorScheme.primaryContainer,
                        colorScheme.secondaryContainer,
                      ],
                    ),
                  ),
                  child: Center(
                    child: Hero(
                      tag: 'user-avatar-${currentUser.id}',
                      child: CircleAvatar(
                        radius: 60,
                        backgroundColor: colorScheme.surface,
                        child: Text(
                          currentUser.initials,
                          style: TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            color: colorScheme.primary,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      currentUser.fullName,
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: FilledButton.icon(
                            onPressed: () async {
                              await context.push(
                                '/user/edit',
                                extra: currentUser,
                              );
                            },
                            icon: const Icon(Icons.edit),
                            label: const Text('Editar'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: FilledButton.tonalIcon(
                            onPressed: () {
                              context.push(
                                '/user/${currentUser.id}/addresses',
                                extra: currentUser,
                              );
                            },
                            icon: const Icon(Icons.location_on),
                            label: const Text('Direcciones'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    _SectionHeader(
                      icon: Icons.person,
                      title: 'Información Personal',
                      colorScheme: colorScheme,
                    ),
                    const SizedBox(height: 16),
                    _InfoCard(
                      items: [
                        _InfoItem(
                          icon: Icons.badge,
                          label: 'Nombre',
                          value: currentUser.firstName,
                        ),
                        _InfoItem(
                          icon: Icons.badge_outlined,
                          label: 'Apellido',
                          value: currentUser.lastName,
                        ),
                        _InfoItem(
                          icon: Icons.cake,
                          label: 'Fecha de Nacimiento',
                          value: Formatters.formatDate(currentUser.birthDate),
                        ),
                        _InfoItem(
                          icon: Icons.calendar_today,
                          label: 'Edad',
                          value: '${currentUser.age} años',
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    _SectionHeader(
                      icon: Icons.contact_mail,
                      title: 'Contacto',
                      colorScheme: colorScheme,
                    ),
                    const SizedBox(height: 16),
                    _InfoCard(
                      items: [
                        _InfoItem(
                          icon: Icons.email,
                          label: 'Email',
                          value: currentUser.email,
                        ),
                        _InfoItem(
                          icon: Icons.phone,
                          label: 'Teléfono',
                          value: Formatters.formatPhone(currentUser.phone),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final IconData icon;
  final String title;
  final ColorScheme colorScheme;

  const _SectionHeader({
    required this.icon,
    required this.title,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: colorScheme.primary, size: 24),
        const SizedBox(width: 12),
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.primary,
              ),
        ),
      ],
    );
  }
}

class _InfoCard extends StatelessWidget {
  final List<_InfoItem> items;

  const _InfoCard({required this.items});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GlassCard(
      blur: 15.0,
      opacity: 0.08,
      padding: const EdgeInsets.all(16.0),
      margin: EdgeInsets.zero,
      child: Column(
        children: [
          for (int i = 0; i < items.length; i++) ...[
            _InfoItemWidget(item: items[i]),
            if (i < items.length - 1) ...[
              const SizedBox(height: 16),
              Divider(height: 1, color: theme.colorScheme.outlineVariant),
              const SizedBox(height: 16),
            ],
          ],
        ],
      ),
    );
  }
}

class _InfoItem {
  final IconData icon;
  final String label;
  final String value;

  _InfoItem({required this.icon, required this.label, required this.value});
}

class _InfoItemWidget extends StatelessWidget {
  final _InfoItem item;

  const _InfoItemWidget({required this.item});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: colorScheme.primaryContainer.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(item.icon, size: 20, color: colorScheme.primary),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.label,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                item.value,
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
