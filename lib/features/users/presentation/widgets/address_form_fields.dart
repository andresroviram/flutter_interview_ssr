import 'package:flutter/material.dart';
import '../../../../core/utils/validators.dart';
import '../../../addresses/domain/entities/address_entity.dart';

class AddressFormFields extends StatefulWidget {
  final TextEditingController streetController;
  final TextEditingController neighborhoodController;
  final TextEditingController cityController;
  final TextEditingController stateController;
  final TextEditingController postalCodeController;
  final AddressLabel selectedLabel;
  final ValueChanged<AddressLabel> onLabelChanged;

  const AddressFormFields({
    super.key,
    required this.streetController,
    required this.neighborhoodController,
    required this.cityController,
    required this.stateController,
    required this.postalCodeController,
    required this.selectedLabel,
    required this.onLabelChanged,
  });

  @override
  State<AddressFormFields> createState() => _AddressFormFieldsState();
}

class _AddressFormFieldsState extends State<AddressFormFields> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ExpansionTile(
        initiallyExpanded: _isExpanded,
        onExpansionChanged: (expanded) {
          setState(() => _isExpanded = expanded);
        },
        leading: const Icon(Icons.location_on),
        title: const Text('Agregar dirección inicial (opcional)'),
        subtitle: const Text('Puedes agregar una dirección ahora o después'),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                DropdownButtonFormField<AddressLabel>(
                  initialValue: widget.selectedLabel,
                  decoration: const InputDecoration(
                    labelText: 'Tipo de dirección',
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
                      widget.onLabelChanged(value);
                    }
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: widget.streetController,
                  decoration: const InputDecoration(
                    labelText: 'Calle y número',
                    hintText: 'Ej: Av. Reforma 123',
                    prefixIcon: Icon(Icons.home_outlined),
                  ),
                  validator:
                      _isExpanded && widget.streetController.text.isNotEmpty
                      ? (value) => Validators.combine([
                          (v) => Validators.required(v, fieldName: 'Calle'),
                          (v) => Validators.minLength(v, 5, fieldName: 'Calle'),
                        ])(value)
                      : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: widget.neighborhoodController,
                  decoration: const InputDecoration(
                    labelText: 'Colonia/Barrio',
                    hintText: 'Ej: Centro',
                    prefixIcon: Icon(Icons.location_city),
                  ),
                  validator:
                      _isExpanded && widget.streetController.text.isNotEmpty
                      ? (value) => Validators.combine([
                          (v) => Validators.required(v, fieldName: 'Colonia'),
                          (v) =>
                              Validators.minLength(v, 3, fieldName: 'Colonia'),
                        ])(value)
                      : null,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: TextFormField(
                        controller: widget.cityController,
                        decoration: const InputDecoration(
                          labelText: 'Ciudad',
                          prefixIcon: Icon(Icons.location_city_outlined),
                        ),
                        validator:
                            _isExpanded &&
                                widget.streetController.text.isNotEmpty
                            ? (value) => Validators.required(
                                value,
                                fieldName: 'Ciudad',
                              )
                            : null,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        controller: widget.stateController,
                        decoration: const InputDecoration(
                          labelText: 'Estado',
                          prefixIcon: Icon(Icons.map),
                        ),
                        validator:
                            _isExpanded &&
                                widget.streetController.text.isNotEmpty
                            ? (value) => Validators.required(
                                value,
                                fieldName: 'Estado',
                              )
                            : null,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: widget.postalCodeController,
                  decoration: const InputDecoration(
                    labelText: 'Código postal',
                    hintText: '12345',
                    prefixIcon: Icon(Icons.markunread_mailbox),
                  ),
                  keyboardType: TextInputType.number,
                  maxLength: 5,
                  validator:
                      _isExpanded && widget.streetController.text.isNotEmpty
                      ? Validators.postalCode
                      : null,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
