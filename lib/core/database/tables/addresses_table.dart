import 'package:drift/drift.dart';
import 'package:flutter_interview_ssr/core/database/app_database.dart';
import 'package:flutter_interview_ssr/features/addresses/domain/entities/address_entity.dart';

class Addresses extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get userId => integer().named('user_id')();
  TextColumn get street => text()();
  TextColumn get neighborhood => text()();
  TextColumn get city => text()();
  TextColumn get state => text()();
  TextColumn get postalCode => text().named('postal_code')();
  TextColumn get label => text()();
  BoolColumn get isPrimary => boolean().named('is_primary')();
  DateTimeColumn get createdAt => dateTime().named('created_at')();
  DateTimeColumn get updatedAt => dateTime().nullable().named('updated_at')();
}

extension AddressDriftMapper on AddressesData {
  AddressEntity toEntity() {
    return AddressEntity(
      id: id,
      userId: userId,
      street: street,
      neighborhood: neighborhood,
      city: city,
      state: state,
      postalCode: postalCode,
      label: AddressLabel.values.firstWhere(
        (l) => l.name == label,
        orElse: () => AddressLabel.other,
      ),
      isPrimary: isPrimary,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
