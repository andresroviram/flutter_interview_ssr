import 'package:flutter/material.dart';
import '../../../../core/utils/formatters.dart';

class BirthDatePickerField extends StatelessWidget {
  final DateTime? selectedDate;
  final ValueChanged<DateTime?> onDateSelected;
  final bool showError;

  const BirthDatePickerField({
    super.key,
    required this.selectedDate,
    required this.onDateSelected,
    this.showError = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _selectDate(context),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: 'Fecha de Nacimiento *',
          suffixIcon: const Icon(Icons.calendar_today),
          errorText: selectedDate == null && showError
              ? 'Selecciona tu fecha de nacimiento'
              : null,
        ),
        child: Text(
          selectedDate != null
              ? Formatters.formatDate(selectedDate!)
              : 'Seleccionar fecha',
          style: TextStyle(color: selectedDate != null ? null : Colors.grey),
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final now = DateTime.now();

    final initialDate =
        selectedDate ?? now.subtract(const Duration(days: 365 * 25));

    final firstDate = now.subtract(const Duration(days: 365 * 100));
    final lastDate = now.subtract(const Duration(days: 365 * 18));

    final date = await showDatePicker(
      context: context,
      initialDate: initialDate.isBefore(lastDate) ? initialDate : lastDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    if (date != null) {
      onDateSelected(date);
    }
  }
}
