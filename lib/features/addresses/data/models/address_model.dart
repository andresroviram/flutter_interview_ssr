import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/address_entity.dart';

part 'address_model.g.dart';

@JsonSerializable()
class AddressModel {
  final String id;
  @JsonKey(name: 'user_id')
  final String userId;
  final String street;
  final String neighborhood;
  final String city;
  final String state;
  @JsonKey(name: 'postal_code')
  final String postalCode;
  @JsonKey(name: 'label')
  final String labelString;
  @JsonKey(name: 'is_primary')
  final bool isPrimary;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;

  const AddressModel({
    required this.id,
    required this.userId,
    required this.street,
    required this.neighborhood,
    required this.city,
    required this.state,
    required this.postalCode,
    required this.labelString,
    required this.isPrimary,
    required this.createdAt,
    this.updatedAt,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) =>
      _$AddressModelFromJson(json);

  Map<String, dynamic> toJson() => _$AddressModelToJson(this);
}

extension AddressModelMapper on AddressModel {
  AddressEntity toEntity() => AddressEntity(
        id: id,
        userId: userId,
        street: street,
        neighborhood: neighborhood,
        city: city,
        state: state,
        postalCode: postalCode,
        label: AddressLabel.values.firstWhere(
          (l) => l.name == labelString,
          orElse: () => AddressLabel.other,
        ),
        isPrimary: isPrimary,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
}

extension AddressEntityMapper on AddressEntity {
  AddressModel toModel() => AddressModel(
        id: id,
        userId: userId,
        street: street,
        neighborhood: neighborhood,
        city: city,
        state: state,
        postalCode: postalCode,
        labelString: label.name,
        isPrimary: isPrimary,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
}
