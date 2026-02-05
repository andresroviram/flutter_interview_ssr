import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/address_entity.dart';

part 'address_form_state.freezed.dart';

@freezed
class AddressFormState with _$AddressFormState {
  const factory AddressFormState.initial() = AddressFormInitial;
  const factory AddressFormState.saving() = AddressFormSaving;
  const factory AddressFormState.success([AddressEntity? address]) =
      AddressFormSuccess;
  const factory AddressFormState.error(String message) = AddressFormError;
}
