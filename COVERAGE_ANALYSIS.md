# Análisis de Cobertura - Core

## 📊 Estado Actual: 48.01%

### ✅ Archivos con Tests (7 archivos)
- `core/result.dart` ✓
- `core/error/failures.dart` ✓
- `core/error/exceptions.dart` ✓
- `core/utils/validators.dart` ✓
- `core/utils/formatters.dart` ✓
- `core/utils/debouncer.dart` ✓
- `core/utils/box_converter.dart` ✓

### ❌ Archivos SIN Tests (15 archivos)

#### Alta Prioridad
- `core/database/app_database.dart` - Base de datos principal
- `core/database/database_provider.dart` - Provider de BD
- `core/database/tables/users_table.dart` - Tabla usuarios
- `core/database/tables/addresses_table.dart` - Tabla direcciones
- `core/router/app_router.dart` - Rutas de la app
- `core/utils/input_formatters.dart` - Formatters de input

#### Media Prioridad
- `core/models/address_filters.dart` - Modelos de filtros
- `core/theme/app_theme.dart` - Tema de la app
- `core/theme/app_colors.dart` - Colores

#### Excluidos (No requieren tests)
- `core/database/app_database.g.dart` - ❌ Generado por drift (excluido de git)
- `core/database/connection/*` - Conexiones específicas de plataforma
- Otros archivos `*.g.dart` y `*.freezed.dart` - Código generado automáticamente

> **Nota**: Los archivos generados (`*.g.dart`, `*.freezed.dart`) ahora están excluidos de git y no requieren tests.

### 🎯 Plan de Acción

1. **Prioridad 1**: Tests de Database (app_database.dart, tables/)
2. **Prioridad 2**: Tests de Router (app_router.dart)
3. **Prioridad 3**: Tests de Input Formatters
4. **Prioridad 4**: Tests de Models y Theme

### 📈 Meta de Cobertura
- Actual: 48.01%
- Meta corto plazo: 70%
- Meta largo plazo: 85%
