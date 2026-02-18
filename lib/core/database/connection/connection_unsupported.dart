import 'package:drift/drift.dart';

DatabaseConnection connect() {
  throw UnimplementedError(
    'No hay soporte de base de datos para esta plataforma. '
    'Solo se soportan plataformas nativas (móvil/desktop) y web.',
  );
}
