import 'package:equatable/equatable.dart';

enum AddressLabel {
  home('Casa'),
  work('Trabajo'),
  other('Otro');

  final String label;
  const AddressLabel(this.label);
}

class AddressEntity extends Equatable {
  final int id;
  final int userId;
  final String street;
  final String neighborhood;
  final String city;
  final String state;
  final String postalCode;
  final AddressLabel label;
  final bool isPrimary;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const AddressEntity({
    required this.id,
    required this.userId,
    required this.street,
    required this.neighborhood,
    required this.city,
    required this.state,
    required this.postalCode,
    required this.label,
    this.isPrimary = false,
    required this.createdAt,
    this.updatedAt,
  });

  String get fullAddress =>
      '$street, $neighborhood, $city, $state, CP $postalCode';

  String get shortAddress => '$street, $neighborhood';

  AddressEntity copyWith({
    int? id,
    int? userId,
    String? street,
    String? neighborhood,
    String? city,
    String? state,
    String? postalCode,
    AddressLabel? label,
    bool? isPrimary,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return AddressEntity(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      street: street ?? this.street,
      neighborhood: neighborhood ?? this.neighborhood,
      city: city ?? this.city,
      state: state ?? this.state,
      postalCode: postalCode ?? this.postalCode,
      label: label ?? this.label,
      isPrimary: isPrimary ?? this.isPrimary,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        userId,
        street,
        neighborhood,
        city,
        state,
        postalCode,
        label,
        isPrimary,
        createdAt,
        updatedAt,
      ];

  @override
  String toString() =>
      'AddressEntity(id: $id, label: ${label.label}, isPrimary: $isPrimary)';
}
