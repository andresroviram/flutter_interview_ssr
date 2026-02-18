# Web Assets para Drift

Este directorio contiene los archivos necesarios para ejecutar la aplicación en web con soporte de base de datos SQLite mediante Drift.

## Archivos Necesarios

### 1. sqlite3.wasm (~690 KB)
Biblioteca SQLite3 compilada a WebAssembly. Proporciona toda la funcionalidad de SQLite en el navegador.

**Origen:** Precompilado oficial del proyecto [sqlite3.dart](https://github.com/simolus3/sqlite3.dart)
**Versión:** 2.4.6 (compatible con drift 2.31.0)
**Descarga:** `https://github.com/simolus3/sqlite3.dart/releases/download/sqlite3-2.4.6/sqlite3.wasm`

### 2. drift_worker.dart (7 KB - código fuente)
Código fuente del web worker que gestiona la base de datos en segundo plano.

**Función:** Inicializa y ejecuta la base de datos SQLite en un Web Worker
**Editable:** Sí - puedes agregar funciones SQL personalizadas aquí
**Requiere compilación:** Sí - debe compilarse a JavaScript

### 3. drift_worker.dart.js (~1.1 MB - compilado)
Versión compilada del worker. Este archivo se genera automáticamente.

**NO editar manualmente** - es generado por:
- `dart run build_runner build -o web:build_web`
- O usando `../scripts/setup_web.ps1` / `../scripts/setup_web.sh`

**Formato:** JavaScript compilado con dart2js
**Optimización:** `-O4` para producción, `--no-minify` para debug

## Cómo Obtener/Regenerar los Archivos

### Opción 1: Script Automatizado (Recomendado)
```powershell
# Windows
.\setup_web.ps1

# Linux/Mac
chmod +x setup_web.sh
./setup_web.sh
```

### Opción 2: Manual
```bash
# Descargar sqlite3.wasm
curl -L -o web/sqlite3.wasm https://github.com/simolus3/sqlite3.dart/releases/download/sqlite3-2.4.6/sqlite3.wasm

# Compilar worker
dart run build_runner build -o web:build_web
cp build_web/drift_worker.dart.js web/drift_worker.dart.js
```

### Opción 3: Compilación Directa (más rápida)
```bash
# Solo compilar el worker (asume que sqlite3.wasm ya existe)
dart compile js -O4 web/drift_worker.dart -o web/drift_worker.dart.js
```

## Archivos Estáticos (No Requieren Compilación)

- **index.html** - Punto de entrada HTML
- **manifest.json** - Metadatos de la aplicación web
- **favicon.png** - Icono de la aplicación
- **icons/** - Iconos en diferentes tamaños

## Verificación

Para verificar que todo está listo:
```powershell
# Verificar archivos existen
Test-Path web/sqlite3.wasm          # Debe ser True
Test-Path web/drift_worker.dart.js  # Debe ser True

# Verificar tamaños aproximados
(Get-Item web/sqlite3.wasm).Length / 1KB          # ~690 KB
(Get-Item web/drift_worker.dart.js).Length / 1KB  # ~1160 KB
```

## Troubleshooting

### "sqlite3.wasm not found"
Ejecuta `..\scripts\setup_web.ps1` o descarga manualmente

### "drift_worker.dart.js not found"
Compila con `dart run build_runner build -o web:build_web`

### Worker muy grande (>2 MB)
Verifica que usas `-O4` en release. El archivo debug es más grande.

### Errores de CORS
No abras `index.html` directamente (`file://`). Usa:
- `flutter run -d chrome` para desarrollo
- Un servidor HTTP local para testing de producción

## Más Información

Ver [WEB_SUPPORT.md](../WEB_SUPPORT.md) en la raíz del proyecto para documentación completa.
