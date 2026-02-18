# Soporte Web - Flutter Interview SSR

## Cambios Realizados

Se ha implementado soporte completo para web en la aplicación Flutter Interview SSR usando Drift con WebAssembly.

### 1. Dependencias Actualizadas

Se agregaron las siguientes dependencias al `pubspec.yaml`:

```yaml
dependencies:
  drift: 2.31.0
  sqlite3_web: ^0.1.1
  web: ^1.1.0

dev_dependencies:
  build_runner: ^2.10.4
  drift_dev: ^2.31.0
```

### 2. Configuración de Base de Datos Multiplataforma

Se refactorizó la configuración de la base de datos para soportar múltiples plataformas usando el patrón recomendado por Drift:

**Archivos creados:**
- `lib/core/database/connection/connection_io.dart` - Conexión nativa para móvil/desktop (SQLite)
- `lib/core/database/connection/connection_web.dart` - Conexión WASM para web (IndexedDB)
- `lib/core/database/connection/connection_unsupported.dart` - Stub para plataformas no soportadas
- `lib/core/database/connection/shared.dart` - Exports condicionales automáticos
- `web/drift_worker.dart` - Worker mínimo (se compila a JS con build_runner)
- `build.yaml` - Configuración para compilar el worker

**Modificados:**
- `lib/core/database/app_database.dart` - Usa imports condicionales automáticos

> **Nota sobre drift_worker.dart**: Este archivo es necesario porque Drift requiere un web worker para gestionar la base de datos en navegadores. Aunque es código Dart mínimo (solo llama a `WasmDatabase.workerMainForOpen()`), debe ser compilado a JavaScript. Drift no proporciona un worker precompilado universal, por eso cada proyecto debe compilar el suyo usando `build_runner`.

### 3. Archivos Web Necesarios

Se requieren dos archivos en la carpeta `web/`:

1. **sqlite3.wasm** (~690 KB) - Biblioteca SQLite compilada a WebAssembly
2. **drift_worker.dart.js** (~1.1 MB) - Worker de Drift compilado con dart2js

#### Por qué compilar el worker localmente

Drift proporciona un worker precompilado en sus releases, pero **no es universal**. Debe compilarse localmente porque:
- Cada proyecto puede necesitar funciones SQL personalizadas
- Permite control sobre optimizaciones y debugging
- Garantiza compatibilidad con la versión exacta de drift usada

#### Obtener los archivos:

**Opción 1: Script automatizado (Recomendado)**
```bash
# Windows PowerShell
.\setup_web.ps1

# Linux/Mac
chmod +x setup_web.sh
./setup_web.sh
```

El script automáticamente:
- Descarga sqlite3.wasm
- Compila drift_worker.dart.js usando build_runner

**Opción 2: Manual con build_runner (usado en este proyecto)**
```bash
# 1. Descargar sqlite3.wasm
curl -L -o web/sqlite3.wasm https://github.com/simolus3/sqlite3.dart/releases/download/sqlite3-2.4.6/sqlite3.wasm

# 2. Compilar el worker con build_runner
dart run build_runner build --delete-conflicting-outputs -o web:build_web
cp build_web/drift_worker.dart.js web/drift_worker.dart.js
```

**Opción 3: Manual con dart compile (alternativa más rápida)**
```bash
# 1. Descargar sqlite3.wasm
curl -L -o web/sqlite3.wasm https://github.com/simolus3/sqlite3.dart/releases/download/sqlite3-2.4.6/sqlite3.wasm

# 2. Compilar el worker directamente
dart compile js -O4 web/drift_worker.dart -o web/drift_worker.dart.js
```

> **Nota:** Ambas opciones de compilación usan `dart2js` internamente. `build_runner` es preferido porque se integra con el flujo de trabajo existente de código generado. `dart compile js` es más rápido pero requiere instalación de Dart SDK standalone.

### 4. Web Index Actualizado

Se mejoró `web/index.html` con:
- Meta viewport para responsive design
- Descripción actualizada del proyecto

## Cómo Ejecutar en Web

### Modo Desarrollo
```bash
flutter run -d chrome
```

### Compilar para Producción
```bash
flutter build web --release
```

Los archivos compilados estarán en `build/web/`

### Servir Localmente
```bash
# Opción 1: Con servidor Python
cd build/web
python -m http.server 8000

# Opción 2: Con dhttpd (Dart)
dart pub global activate dhttpd
dhttpd --path build/web
```

## Características Web

✅ **Base de datos WASM** - SQLite3 compilado a WebAssembly para mejor rendimiento
✅ **Múltiples estrategias de almacenamiento** - Drift selecciona automáticamente la mejor implementación:
   - **opfsShared** - Origin-Private FileSystem con SharedWorker (Firefox)
   - **opfsLocks** - Origin-Private FileSystem con COOP/COEP headers
   - **sharedIndexedDb** - IndexedDB con SharedWorker
   - **unsafeIndexedDb** - IndexedDB sin sincronización (fallback)
   - **inMemory** - Base de datos en memoria (fallback último recurso)
✅ **Responsive design** - Configuración viewport optimizada
✅ **Persistencia local** - Los datos se guardan en el navegador
✅ **Arquitectura limpia** - Mismo código para todas las plataformas
✅ **Web Workers** - La base de datos se ejecuta en un worker para mejor rendimiento

## Notas Técnicas

### Implementaciones de Almacenamiento

Drift detecta automáticamente las capacidades del navegador y elige la mejor implementación. Puedes ver cuál está usando en la configuración en [connection_web.dart](lib/core/database/connection/connection_web.dart).

- **IndexedDB**: Compatible con todos los navegadores modernos
- **Origin-Private FileSystem**: Mejor rendimiento, requiere navegadores actualizados
- **Web Workers**: Dedicados para mejor rendimiento y sincronización entre pestañas

### Headers COOP/COEP (Opcional)

Para activar la implementación más rápida (opfsLocks), se requieren headers adicionales:

```
Cross-Origin-Opener-Policy: same-origin
Cross-Origin-Embedder-Policy: require-corp
```

En desarrollo con Flutter:
```bash
flutter run -d chrome \
  --web-header=Cross-Origin-Opener-Policy=same-origin \
  --web-header=Cross-Origin-Embedder-Policy=require-corp
```

**Nota:** Estos headers pueden causar incompatibilidades con algunos servicios de terceros (ej. Google Auth). Drift funciona perfectamente sin ellos usando IndexedDB.

### Imports Condicionales

El sistema usa exports condicionales que seleccionan automáticamente la implementación correcta:
```dart
export 'connection_unsupported.dart'
    if (dart.library.ffi) 'connection_io.dart'
    if (dart.library.js_interop) 'connection_web.dart';
```

Esto permite que el mismo código funcione en todas las plataformas sin cambios.

## Pruebas

Para validar que todo funciona:

1. **Tests unitarios**: 
   ```bash
   flutter test
   ```

2. **Pruebas en navegador**:
   ```bash
   flutter run -d chrome
   ```

3. **Verificar persistencia**:
   - Crea usuarios y direcciones
   - Cierra el navegador (o pestaña)
   - Reabre la aplicación
   - Verifica que los datos persisten

4. **Múltiples pestañas**:
   - Abre la app en dos pestañas
   - Crea datos en una
   - Verifica sincronización en la otra (si soportado por el navegador)

## Soporte de Navegadores

| Navegador | Soporte | Notas |
|-----------|---------|-------|
| Chrome/Edge | ✅ Completo | Mejor rendimiento con COOP/COEP |
| Firefox | ✅ Completo | opfsShared disponible |
| Safari | ✅ Bueno | IndexedDB, ligeramente más lento |
| CCompilación Avanzada

### Compilar sqlite3.wasm desde el código fuente (opcional)

Si necesitas una versión personalizada de SQLite3 (con extensiones específicas), puedes compilarlo tú mismo:

**Requisitos:**
- Toolchain de C con soporte WebAssembly (clang con wasi-sdk)
- CMake
- binaryen (optimizador)

**Proceso:**
```bash
git clone https://github.com/simolus3/sqlite3.dart.git
cd sqlite3.dart/sqlite3

cmake -S assets/wasm -B .dart_tool/sqlite3_build --toolchain toolchain.cmake
cmake --build .dart_tool/sqlite3_build/ -t output -j
```

Esto genera `sqlite3.wasm` y `sqlite3.debug.wasm` en `example/web/`.

> ⚠️ **Para la mayoría de proyectos:** Usa el `sqlite3.wasm` precompilado oficial. Solo compila desde fuente si necesitas extensiones SQLite específicas no incluidas en la versión estándar.

### Funciones SQL Personalizadas

Para agregar funciones SQL personalizadas, edita [web/drift_worker.dart](web/drift_worker.dart):

```dart
void main() {
  WasmDatabase.workerMainForOpen(
    setupAllDatabases: (database) {
      // Función para remover acentos en búsquedas
      database.createFunction(
        functionName: 'unaccent',
        function: (args) {
          final text = args.first as String;
          return text
              .replaceAll('á', 'a')
              .replaceAll('é', 'e')
              .replaceAll('í', 'i')
              .replaceAll('ó', 'o')
              .replaceAll('ú', 'u');
        },
      );
      
      // Función para calcular distancia entre coordenadas
      database.createFunction(
        functionName: 'distance',
        function: (args) {
          final lat1 = args[0] as double;
          final lon1 = args[1] as double;
          final lat2 = args[2] as double;
          final lon2 = args[3] as double;
          // Implementar fórmula de Haversine...
          return 0.0; // placeholder
        },
      );
    },
  );
}
```

Después de modificar, recompila:
```bash
./setup_web.ps1  # o usar dart compile js directamente
```

## hrome Android | ⚠️ Limitado | Sin SharedWorker, evitar múltiples pestañas |
| Navegadores antiguos | ❌ No soportado | Requieren navegadores modernos con WASM |

## Depuración

- Los logs de drift aparecerán en la consola del navegador
- Puedes ver qué implementación está usando en los logs al iniciar
- Para inspeccionar la base de datos en DevTools:
  - Chrome: Application → Storage → IndexedDB
  - Firefox: Storage → IndexedDB

## Estructura de Archivos Web

```
web/
├── favicon.png
├── index.html
├── manifest.json
├── drift_worker.dart.js      # Worker oficial precompilado
└── sqlite3.wasm               # SQLite WebAssembly binary
```

## Despliegue

Para desplegar tu aplicación web:

1. Compile en modo release: `flutter build web --release`
2. Los archivos en `build/web` están listos para desplegar
3. Asegúrate de que el servidor web sirva `.wasm` con `Content-Type: application/wasm`
4. (Opcional) Configura headers COOP/COEP para mejor rendimiento

## Troubleshooting

### Error: "sqlite3.wasm not found"
- Verifica que `sqlite3.wasm` esté en la carpeta `web/`
- Ejecuta el script de descarga nuevamente

### Error: "drift_worker.dart.js not found"
- Verifica que `drift_wconfiguración: `.\setup_web.ps1` o `./setup_web.sh`
- O compílalo manualmente: `dart run build_runner build -o web:build_web
- Ejecuta el script de descarga nuevamente: `./download_web_files.ps1`

### La base de datos no persiste
- Verifica la consola para ver qué implementación está usando
- Si usa `inMemory`, tu navegador no soporta almacenamiento
- Actualiza tu navegador a una versión más reciente

### Errores CORS
- No uses `file://` para abrir el HTML
- Usa un servidor web local (ver sección "Servir Localmente")
