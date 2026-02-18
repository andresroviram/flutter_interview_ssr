import 'package:flutter/material.dart';
import 'package:flutter_interview_ssr/features/addresses/presentation/controllers/address_form_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../components/widgets/confirmation_dialog.dart';
import '../../../../components/widgets/shimmers/shimmers.dart';
import '../../domain/entities/address_entity.dart';
import '../../../users/domain/entities/user_entity.dart';
import '../providers/address_providers.dart';
import '../controllers/address_form_notifier.dart';
import '../widgets/address_card.dart';

class AddressesScreen extends ConsumerStatefulWidget {
  final UserEntity user;

  const AddressesScreen({super.key, required this.user});

  @override
  ConsumerState<AddressesScreen> createState() => _AddressesScreenState();
}

class _AddressesScreenState extends ConsumerState<AddressesScreen> {
  Future<void> _deleteAddress(String addressId) async {
    await ref
        .read(addressFormNotifierProvider.notifier)
        .deleteAddress(addressId: int.parse(addressId), userId: widget.user.id);

    if (mounted) {
      final state = ref.read(addressFormNotifierProvider);
      state.when(
        initial: () {},
        saving: () {},
        success: (_) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Dirección eliminada')));
        },
        error: (message) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Error: $message')));
        },
      );
    }
  }

  Future<void> _setPrimaryAddress(AddressEntity address) async {
    await ref
        .read(addressFormNotifierProvider.notifier)
        .setPrimaryAddress(address: address, userId: widget.user.id);

    if (mounted) {
      final state = ref.read(addressFormNotifierProvider);
      state.when(
        initial: () {},
        saving: () {},
        success: (_) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Dirección actualizada')),
          );
        },
        error: (message) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Error: $message')));
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final addressesAsync = ref.watch(userAddressesProvider(widget.user.id));

    return Scaffold(
      appBar: AppBar(title: Text('Direcciones de ${widget.user.firstName}')),
      body: addressesAsync.when(
        data: (addresses) {
          if (addresses.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.location_off,
                    size: 64,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No hay direcciones registradas',
                    style: TextStyle(fontSize: 18, color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Agrega tu primera dirección',
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(userAddressesProvider(widget.user.id));
            },
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: addresses.length,
              itemBuilder: (context, index) {
                final address = addresses[index];
                return AddressCard(
                  address: address,
                  onTap: () {
                    context.push(
                      '/user/${widget.user.id}/address/edit',
                      extra: {'user': widget.user, 'address': address},
                    );
                  },
                  onEdit: () {
                    context.push(
                      '/user/${widget.user.id}/address/edit',
                      extra: {'user': widget.user, 'address': address},
                    );
                  },
                  onSetPrimary: () => _setPrimaryAddress(address),
                  onDelete: () async {
                    final confirmed = await showDeleteConfirmationDialog(
                      context: context,
                      itemName: address.shortAddress,
                      title: 'Eliminar Dirección',
                    );
                    if (confirmed == true) {
                      await _deleteAddress(address.id.toString());
                    }
                  },
                );
              },
            ),
          );
        },
        loading: () => const AddressListShimmer(),
        error: (error, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              Text('Error: $error'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  ref.invalidate(userAddressesProvider(widget.user.id));
                },
                child: const Text('Reintentar'),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          context.push(
            '/user/${widget.user.id}/address/new',
            extra: widget.user,
          );
        },
        icon: const Icon(Icons.add_location),
        label: const Text('Nueva Dirección'),
      ),
    );
  }
}
