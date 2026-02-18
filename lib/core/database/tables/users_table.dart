import 'package:drift/drift.dart';
import 'package:flutter_interview_ssr/core/database/app_database.dart';
import 'package:flutter_interview_ssr/features/users/domain/entities/user_entity.dart';

class Users extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get firstName => text().named('first_name')();
  TextColumn get lastName => text().named('last_name')();
  DateTimeColumn get birthDate => dateTime().named('birth_date')();
  TextColumn get email => text()();
  TextColumn get phone => text()();
  DateTimeColumn get createdAt => dateTime().named('created_at')();
  DateTimeColumn get updatedAt => dateTime().nullable().named('updated_at')();
}

extension UserDriftMapper on User {
  UserEntity toEntity() {
    return UserEntity(
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
}
