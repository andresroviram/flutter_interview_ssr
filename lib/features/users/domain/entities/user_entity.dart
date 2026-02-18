import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final int id;
  final String firstName;
  final String lastName;
  final DateTime birthDate;
  final String email;
  final String phone;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const UserEntity({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.birthDate,
    required this.email,
    required this.phone,
    required this.createdAt,
    this.updatedAt,
  });

  String get fullName => '$firstName $lastName';

  String get initials {
    final firstInitial = firstName.isNotEmpty ? firstName[0].toUpperCase() : '';
    final lastInitial = lastName.isNotEmpty ? lastName[0].toUpperCase() : '';
    return '$firstInitial$lastInitial';
  }

  int get age {
    final now = DateTime.now();
    var age = now.year - birthDate.year;
    if (now.month < birthDate.month ||
        (now.month == birthDate.month && now.day < birthDate.day)) {
      age--;
    }
    return age;
  }

  @override
  List<Object?> get props => [
    id,
    firstName,
    lastName,
    birthDate,
    email,
    phone,
    createdAt,
    updatedAt,
  ];

  @override
  String toString() =>
      'UserEntity(id: $id, fullName: $fullName, email: $email)';
}
