import 'package:drift/wasm.dart';

/// Web Worker para Drift/SQLite en navegadores
///
/// Este archivo es necesario para que Drift funcione en web. Cuando se compila
/// con dart2js, genera un web worker (dedicado o compartido) que gestiona
/// la base de datos SQLite en el navegador.
///
/// COMPILACIÓN:
/// ------------
/// Opción 1 - Con build_runner (usado en este proyecto):
///   dart run build_runner build -o web:build_web
///   cp build_web/drift_worker.dart.js web/
///
/// Opción 2 - Directo con dart compile (alternativa):
///   dart compile js -O4 web/drift_worker.dart -o web/drift_worker.dart.js
///
/// Opción 3 - Script automatizado:
///   ../scripts/setup_web.ps1 (Windows)
///   ../scripts/setup_web.sh (Linux/Mac)
///
/// IMPORTANTE:
/// -----------
/// - Debe compilarse con dart2js (no dartdevc)
/// - El archivo resultante (~1.1 MB) incluye todo el código necesario
/// - Drift y sqlite3 proveen versiones precompiladas, pero cada proyecto
///   debe compilar su propio worker para personalizaciones
///
/// PERSONALIZACIÓN:
/// ----------------
/// Para agregar funciones SQL personalizadas, modifica así:
///
///   void main() {
///     WasmDatabase.workerMainForOpen(
///       setupAllDatabases: (database) {
///         database.createFunction(
///           functionName: 'unaccent',
///           function: (args) => removeAccents(args.first as String),
///         );
///       },
///     );
///   }
///
/// Más info: https://drift.simonbinder.eu/web/
void main() => WasmDatabase.workerMainForOpen();
