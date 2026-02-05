import 'package:flutter_interview_ssr/features/addresses/domain/entities/address_entity.dart';
import 'package:flutter_interview_ssr/features/addresses/presentation/screens/address_form_screen.dart';
import 'package:flutter_interview_ssr/features/addresses/presentation/screens/addresses_screen.dart';
import 'package:flutter_interview_ssr/features/users/domain/entities/user_entity.dart';
import 'package:flutter_interview_ssr/features/users/presentation/screens/user_detail_screen.dart';
import 'package:flutter_interview_ssr/features/users/presentation/screens/user_form_screen.dart';
import 'package:flutter_interview_ssr/features/users/presentation/screens/users_list_enhanced_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final appRouterProvider = Provider<GoRouter>(
  (ref) => GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(path: '/', builder: (context, state) => const UsersListEnhancedScreen()),
      GoRoute(
        path: '/user/:userId/detail',
        builder: (context, state) {
          final user = state.extra as UserEntity;
          return UserDetailScreen(user: user);
        },
      ),
      GoRoute(
        path: '/user/new',
        builder: (context, state) => const UserFormScreen(),
      ),
      GoRoute(
        path: '/user/edit',
        builder: (context, state) {
          final user = state.extra as UserEntity;
          return UserFormScreen(userToEdit: user);
        },
      ),
      GoRoute(
        path: '/user/:userId/addresses',
        builder: (context, state) {
          final user = state.extra as UserEntity;
          return AddressesScreen(user: user);
        },
      ),
      GoRoute(
        path: '/user/:userId/address/new',
        builder: (context, state) {
          final user = state.extra as UserEntity;
          return AddressFormScreen(user: user);
        },
      ),
      GoRoute(
        path: '/user/:userId/address/edit',
        builder: (context, state) {
          final data = state.extra as Map<String, dynamic>;
          final user = data['user'] as UserEntity;
          final address = data['address'] as AddressEntity;
          return AddressFormScreen(user: user, addressToEdit: address);
        },
      ),
    ],
  ),
);
