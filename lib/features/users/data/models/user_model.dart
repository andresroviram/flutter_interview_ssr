import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/user_entity.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel {
  final String id;
  @JsonKey(name: 'first_name')
  final String firstName;
  @JsonKey(name: 'last_name')
  final String lastName;
  @JsonKey(name: 'birth_date')
  final DateTime birthDate;
  final String email;
  final String phone;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;

  const UserModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.birthDate,
    required this.email,
    required this.phone,
    required this.createdAt,
    this.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}

extension UserModelMapper on UserModel {
  UserEntity toEntity() => UserEntity(
        id: id,
        firstName: firstName,
        lastName: lastName,
        birthDate: birthDate,
        email: email,
        phone: phone,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
}

extension UserEntityMapper on UserEntity {
  UserModel toModel() => UserModel(
        id: id,
        firstName: firstName,
        lastName: lastName,
        birthDate: birthDate,
        email: email,
        phone: phone,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
}
