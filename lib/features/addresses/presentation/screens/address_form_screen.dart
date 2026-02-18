import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/utils/validators.dart';
import '../../domain/entities/address_entity.dart';
import '../../../users/domain/entities/user_entity.dart';
import '../controllers/address_form_notifier.dart';
import '../controllers/address_form_state.dart';

class AddressFormScreen extends ConsumerStatefulWidget {
  final UserEntity user;
  final AddressEntity? addressToEdit;

  const AddressFormScreen({super.key, required this.user, this.addressToEdit});

  @override
  ConsumerState<AddressFormScreen> createState() => _AddressFormScreenState();
}

class _AddressFormScreenState extends ConsumerState<AddressFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _streetController;
  late TextEditingController _neighborhoodController;
  late TextEditingController _cityController;
  late TextEditingController _stateController;
  late TextEditingController _postalCodeController;
  late AddressLabel _selectedLabel;
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;

  @override
  void initState() {
    super.initState();
    final address = widget.addressToEdit;
    _streetController = TextEditingController(text: address?.street ?? '');
    _neighborhoodController = TextEditingController(
      text: address?.neighborhood ?? '',
    );
    _cityController = TextEditingController(text: address?.city ?? '');
    _stateController = TextEditingController(text: address?.state ?? '');
    _postalCodeController = TextEditingController(
      text: address?.postalCode ?? '',
    );
    _selectedLabel = address?.label ?? AddressLabel.home;
  }

  @override
  void dispose() {
    _streetController.dispose();
    _neighborhoodController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _postalCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.addressToEdit != null;
    final formState = ref.watch(addressFormNotifierProvider);
    final isSaving = formState is AddressFormSaving;

    ref.listen<AddressFormState>(addressFormNotifierProvider, (previous, next) {
      next.when(
        initial: () {},
        saving: () {},
        success: (address) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                widget.addressToEdit != null
                    ? 'Dirección actualizada'
                    : 'Dirección creada',
              ),
            ),
          );
          ref.read(addressFormNotifierProvider.notifier).reset();
          context.pop();
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
        title: Text(isEditing ? 'Editar Dirección' : 'Nueva Dirección'),
      ),
      body: Form(
        key: _formKey,
        autovalidateMode: _autovalidateMode,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            DropdownButtonFormField<AddressLabel>(
              initialValue: _selectedLabel,
              decoration: const InputDecoration(
                labelText: 'Tipo de dirección *',
                prefixIcon: Icon(Icons.label),
              ),
              items: const [
                DropdownMenuItem(
                  value: AddressLabel.home,
                  child: Row(
                    children: [
                      Icon(Icons.home, size: 20),
                      SizedBox(width: 8),
                      Text('Casa'),
                    ],
                  ),
                ),
                DropdownMenuItem(
                  value: AddressLabel.work,
                  child: Row(
                    children: [
                      Icon(Icons.work, size: 20),
                      SizedBox(width: 8),
                      Text('Trabajo'),
                    ],
                  ),
                ),
                DropdownMenuItem(
                  value: AddressLabel.other,
                  child: Row(
                    children: [
                      Icon(Icons.location_on, size: 20),
                      SizedBox(width: 8),
                      Text('Otra'),
                    ],
                  ),
                ),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() => _selectedLabel = value);
                }
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _streetController,
              decoration: const InputDecoration(
                labelText: 'Calle y número *',
                hintText: 'Ej: Av. Reforma 123',
                prefixIcon: Icon(Icons.home_outlined),
              ),
              validator: (value) => Validators.combine([
                (v) => Validators.required(v, fieldName: 'Calle'),
                (v) => Validators.minLength(v, 5, fieldName: 'Calle'),
              ])(value),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _neighborhoodController,
              decoration: const InputDecoration(
                labelText: 'Colonia/Barrio *',
                hintText: 'Ej: Centro',
                prefixIcon: Icon(Icons.location_city),
              ),
              validator: (value) => Validators.combine([
                (v) => Validators.required(v, fieldName: 'Colonia'),
                (v) => Validators.minLength(v, 3, fieldName: 'Colonia'),
              ])(value),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _cityController,
              decoration: const InputDecoration(
                labelText: 'Ciudad *',
                hintText: 'Ej: Ciudad de México',
                prefixIcon: Icon(Icons.location_city_outlined),
              ),
              validator: (value) => Validators.combine([
                (v) => Validators.required(v, fieldName: 'Ciudad'),
                (v) => Validators.minLength(v, 3, fieldName: 'Ciudad'),
              ])(value),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _stateController,
              decoration: const InputDecoration(
                labelText: 'Estado/Provincia *',
                hintText: 'Ej: CDMX',
                prefixIcon: Icon(Icons.map),
              ),
              validator: (value) => Validators.combine([
                (v) => Validators.required(v, fieldName: 'Estado'),
                (v) => Validators.minLength(v, 2, fieldName: 'Estado'),
              ])(value),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _postalCodeController,
              decoration: const InputDecoration(
                labelText: 'Código postal *',
                hintText: '12345',
                prefixIcon: Icon(Icons.markunread_mailbox),
              ),
              keyboardType: TextInputType.number,
              maxLength: 5,
              validator: (value) => Validators.combine([
                (v) => Validators.required(v, fieldName: 'Código postal'),
                Validators.postalCode,
              ])(value),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: isSaving ? null : _saveAddress,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(48),
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
              ),
              child: isSaving
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(isEditing ? 'Guardar Cambios' : 'Crear Dirección'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveAddress() async {
    if (!_formKey.currentState!.validate()) {
      setState(() {
        _autovalidateMode = AutovalidateMode.onUserInteraction;
      });
      return;
    }

    final address = AddressEntity(
      id: widget.addressToEdit?.id ?? DateTime.now().millisecondsSinceEpoch,
      userId: widget.user.id,
      street: _streetController.text.trim(),
      neighborhood: _neighborhoodController.text.trim(),
      city: _cityController.text.trim(),
      state: _stateController.text.trim(),
      postalCode: _postalCodeController.text.trim(),
      label: _selectedLabel,
      isPrimary: widget.addressToEdit?.isPrimary ?? false,
      createdAt: widget.addressToEdit?.createdAt ?? DateTime.now(),
      updatedAt: DateTime.now(),
    );

    await ref
        .read(addressFormNotifierProvider.notifier)
        .saveAddress(
          address: address,
          isUpdate: widget.addressToEdit != null,
          userId: widget.user.id,
        );
  }
}
