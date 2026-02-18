import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/utils/input_formatters.dart';
import '../../../../core/utils/validators.dart';
import '../../domain/entities/user_entity.dart';
import '../widgets/birth_date_picker_field.dart';
import '../widgets/address_form_fields.dart';
import '../controllers/user_form/user_form_notifier.dart';
import '../controllers/user_form/user_form_state.dart';
import '../../../addresses/domain/entities/address_entity.dart';

class UserFormScreen extends ConsumerStatefulWidget {
  final UserEntity? userToEdit;

  const UserFormScreen({super.key, this.userToEdit});

  @override
  ConsumerState<UserFormScreen> createState() => _UserFormScreenState();
}

class _UserFormScreenState extends ConsumerState<UserFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  DateTime? _birthDate;
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;

  late TextEditingController _streetController;
  late TextEditingController _neighborhoodController;
  late TextEditingController _cityController;
  late TextEditingController _stateController;
  late TextEditingController _postalCodeController;
  AddressLabel _selectedLabel = AddressLabel.home;

  @override
  void initState() {
    super.initState();
    final user = widget.userToEdit;
    _firstNameController = TextEditingController(text: user?.firstName ?? '');
    _lastNameController = TextEditingController(text: user?.lastName ?? '');
    _emailController = TextEditingController(text: user?.email ?? '');
    _phoneController = TextEditingController(text: user?.phone ?? '');
    _birthDate = user?.birthDate;

    _streetController = TextEditingController();
    _neighborhoodController = TextEditingController();
    _cityController = TextEditingController();
    _stateController = TextEditingController();
    _postalCodeController = TextEditingController();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _streetController.dispose();
    _neighborhoodController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _postalCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.userToEdit != null;
    final formState = ref.watch(userFormNotifierProvider);
    final isSaving = formState is UserFormSaving;

    ref.listen<UserFormState>(userFormNotifierProvider, (previous, next) {
      next.whenOrNull(
        success: (user) {
          context.pop();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                widget.userToEdit != null
                    ? 'Usuario actualizado'
                    : 'Usuario creado',
              ),
            ),
          );
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
        title: Text(isEditing ? 'Editar Usuario' : 'Nuevo Usuario'),
      ),
      body: Form(
        key: _formKey,
        autovalidateMode: _autovalidateMode,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _firstNameController,
              decoration: const InputDecoration(
                labelText: 'Nombre *',
                hintText: 'Ingresa el nombre',
              ),
              validator: (value) => Validators.combine([
                (v) => Validators.required(v, fieldName: 'Nombre'),
                (v) => Validators.minLength(v, 2, fieldName: 'Nombre'),
                Validators.onlyLetters,
              ])(value),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _lastNameController,
              decoration: const InputDecoration(
                labelText: 'Apellido *',
                hintText: 'Ingresa el apellido',
              ),
              validator: (value) => Validators.combine([
                (v) => Validators.required(v, fieldName: 'Apellido'),
                (v) => Validators.minLength(v, 2, fieldName: 'Apellido'),
                Validators.onlyLetters,
              ])(value),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email *',
                hintText: 'ejemplo@correo.com',
              ),
              keyboardType: TextInputType.emailAddress,
              textCapitalization: TextCapitalization.none,
              inputFormatters: [LowerCaseTextFormatter()],
              validator: (value) => Validators.combine([
                (v) => Validators.required(v, fieldName: 'Email'),
                Validators.email,
              ])(value),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _phoneController,
              decoration: const InputDecoration(
                labelText: 'Teléfono *',
                hintText: '1234567890',
              ),
              keyboardType: TextInputType.phone,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(10),
              ],
              validator: (value) => Validators.combine([
                (v) => Validators.required(v, fieldName: 'Teléfono'),
                Validators.phone,
              ])(value),
            ),
            const SizedBox(height: 16),
            BirthDatePickerField(
              selectedDate: _birthDate,
              onDateSelected: (date) => setState(() => _birthDate = date),
              showError: isSaving,
            ),
            const SizedBox(height: 32),
            if (!isEditing) ..._buildAddressSection(),
            const SizedBox(height: 16),
            if (isEditing) ..._buildManageAddressesButton(),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: isSaving ? null : _saveUser,
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
                  : Text(isEditing ? 'Guardar Cambios' : 'Crear Usuario'),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildAddressSection() {
    return [
      AddressFormFields(
        streetController: _streetController,
        neighborhoodController: _neighborhoodController,
        cityController: _cityController,
        stateController: _stateController,
        postalCodeController: _postalCodeController,
        selectedLabel: _selectedLabel,
        onLabelChanged: (label) => setState(() => _selectedLabel = label),
      ),
    ];
  }

  List<Widget> _buildManageAddressesButton() {
    return [
      OutlinedButton.icon(
        onPressed: () {
          context.push(
            '/user/${widget.userToEdit!.id}/addresses',
            extra: widget.userToEdit,
          );
        },
        icon: const Icon(Icons.location_on),
        label: const Text('Gestionar Direcciones'),
        style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(48)),
      ),
    ];
  }

  Future<void> _saveUser() async {
    if (!_formKey.currentState!.validate() || _birthDate == null) {
      setState(() {
        _autovalidateMode = AutovalidateMode.onUserInteraction;
      });
      return;
    }

    final user = UserEntity(
      id: widget.userToEdit?.id ?? DateTime.now().millisecondsSinceEpoch,
      firstName: _firstNameController.text.trim(),
      lastName: _lastNameController.text.trim(),
      birthDate: _birthDate!,
      email: _emailController.text.trim(),
      phone: _phoneController.text.trim(),
      createdAt: widget.userToEdit?.createdAt ?? DateTime.now(),
      updatedAt: DateTime.now(),
    );

    AddressEntity? initialAddress;
    if (widget.userToEdit == null && _streetController.text.trim().isNotEmpty) {
      initialAddress = AddressEntity(
        id: DateTime.now().millisecondsSinceEpoch,
        userId: user.id,
        street: _streetController.text.trim(),
        neighborhood: _neighborhoodController.text.trim(),
        city: _cityController.text.trim(),
        state: _stateController.text.trim(),
        postalCode: _postalCodeController.text.trim(),
        label: _selectedLabel,
        isPrimary: true,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
    }

    await ref
        .read(userFormNotifierProvider.notifier)
        .submitUserForm(
          user: user,
          isUpdate: widget.userToEdit != null,
          initialAddress: initialAddress,
        );
  }
}
